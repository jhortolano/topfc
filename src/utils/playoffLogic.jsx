import { supabase } from '../supabaseClient';

export const verificarYObtenerRankingLiguilla = async (torneoId) => {
  try {
    // 1. Comprobar si todos los partidos han sido jugados
    const { data: partidos, error: errP } = await supabase
      .from('extra_matches')
      .select('is_played')
      .eq('extra_id', torneoId);

    if (errP) throw errP;
    if (!partidos?.length || !partidos.every(p => p.is_played)) return null;

    // 2. Obtener configuración
    const { data: config } = await supabase
      .from('playoffs_extra')
      .select('pasan_por_grupo')
      .eq('id', torneoId)
      .single();

    const pasanPorGrupo = config?.pasan_por_grupo || 1;

    // 3. Obtener posiciones con el Nick/Nombre del usuario
    // Nota: Asegúrate de que 'user_nickname' o el nombre del campo existe en tu vista
    const { data: ranking, error: errR } = await supabase
      .from('v_posiciones_dinamicas')
      .select('user_id, nick, group_id, puntos, diferencia_goles')
      .eq('playoff_extra_id', torneoId)
      .order('group_id', { ascending: true })
      .order('puntos', { ascending: false })
      .order('diferencia_goles', { ascending: false });

    if (errR) throw errR;

    // 4. Filtrar clasificados por cada grupo
    const gruposIds = [...new Set(ranking.map(r => r.group_id))];
    let clasificados = [];

    gruposIds.forEach(gid => {
      const clasificadosGrupo = ranking
        .filter(r => r.group_id === gid)
        .slice(0, pasanPorGrupo);
      clasificados.push(...clasificadosGrupo);
    });

    // 5. ORDENAR RANKING GLOBAL (De mejor a peor)
    // Esto es vital para que analizarEstructuraPlayoffs asigne los BYE correctamente
    return clasificados.sort((a, b) => {
      if (b.puntos !== a.puntos) return b.puntos - a.puntos;
      return b.diferencia_goles - a.diferencia_goles;
    });

  } catch (error) {
    console.error("Error en playoffLogic:", error);
    return null;
  }
};

export const analizarEstructuraPlayoffs = (ranking) => {
  if (!ranking || ranking.length === 0) return null;

  const n = ranking.length;

  // 1. Determinar fase base (potencia de 2: 2, 4, 8, 16, 32)
  let fasePotencia = 2;
  let nombreFase = "Final";

  if (n > 16) { fasePotencia = 32; nombreFase = "Dieciseisavos"; } // 16 partidos
  else if (n > 8) { fasePotencia = 16; nombreFase = "Octavos"; }   // 8 partidos
  else if (n > 4) { fasePotencia = 8; nombreFase = "Cuartos"; }    // 4 partidos
  else if (n > 2) { fasePotencia = 4; nombreFase = "Semifinales"; }// 2 partidos
  else { fasePotencia = 2; nombreFase = "Final"; }

  const numSlotsCuadro = fasePotencia / 2;
  const numPartidosReales = n - numSlotsCuadro;
  const numByes = numSlotsCuadro - numPartidosReales;

  // 2. Preparar los enfrentamientos por "Nivel de fuerza"
  const mejoresPasanDirecto = ranking.slice(0, numByes);
  const candidatosPlayIn = ranking.slice(numByes);

  const enfrentamientosOrdenados = [];
  // Primero los BYEs (los más fuertes)
  mejoresPasanDirecto.forEach(p => enfrentamientosOrdenados.push({ tipo: 'BYE', p1: p, p2: null }));
  // Luego los partidos (los más "debiles")
  for (let i = 0; i < numPartidosReales; i++) {
    enfrentamientosOrdenados.push({
      tipo: 'REAL',
      p1: candidatosPlayIn[i],
      p2: candidatosPlayIn[candidatosPlayIn.length - 1 - i]
    });
  }

  // 3. DISTRIBUCIÓN ESTILO "SNAKE" / SEMBRADO PROFESIONAL
  // Esta lógica asegura: 1º en el Slot 1, 2º en el Último, 
  // 3º en el penúltimo, 4º en el segundo... (o viceversa para equilibrar)
  let resultadoFinal = new Array(numSlotsCuadro);
  let inicio = 0;
  let fin = numSlotsCuadro - 1;

  enfrentamientosOrdenados.forEach((enfrentamiento, index) => {
    if (index === 0) {
      // El mejor de todos: Arriba del todo
      resultadoFinal[0] = enfrentamiento;
    } else if (index === 1) {
      // El segundo mejor: Abajo del todo
      resultadoFinal[numSlotsCuadro - 1] = enfrentamiento;
    } else if (index % 2 === 0) {
      // Los siguientes pares (3º mejor, 5º...): Van desde abajo hacia el centro
      // Esto hace que el 3º mejor esté cerca del 2º pero en otro partido
      resultadoFinal[fin - 1] = enfrentamiento;
      fin--;
    } else {
      // Los siguientes impares (4º mejor, 6º...): Van desde arriba hacia el centro
      resultadoFinal[inicio + 1] = enfrentamiento;
      inicio++;
    }
  });

  // Limpiar posibles huecos vacíos por si la lógica fallara en algún n extraño
  const cuadroLimpio = resultadoFinal.filter(slot => slot !== undefined);

  // 4. Consola
  console.log(`📌 ESTRUCTURA: ${nombreFase} (${cuadroLimpio.length} partidos)`);
  cuadroLimpio.forEach((slot, i) => {
    const label = slot.tipo === 'BYE'
      ? `⭐ (BYE) ${slot.p1.nick}`
      : `⚔️ ${slot.p1.nick} VS ${slot.p2.nick}`;
    console.log(`Slot ${i + 1}: ${label}`);
  });

  return { nombreFase, cuadroFinal: cuadroLimpio };
};



export const actualizarPrimeraFasePlayoffs = async (torneoId, ranking, estructura) => {
  const { cuadroFinal } = estructura;

  try {
    const { data: partidosBD, error: errFetch } = await supabase
      .from('extra_playoffs_matches')
      .select('id, numero_jornada')
      .eq('playoff_extra_id', torneoId)
      .is('p1_from_match_id', null)
      .is('p2_from_match_id', null)
      .order('id', { ascending: true });

    if (errFetch) throw errFetch;
    if (!partidosBD || partidosBD.length === 0) return;

    const partidosIda = partidosBD.filter(p => p.numero_jornada.includes('IDA') || !p.numero_jornada.includes('VUELTA'));
    const partidosVuelta = partidosBD.filter(p => p.numero_jornada.includes('VUELTA'));

    const promesasUpdate = [];

    // --- PROCESAR IDA ---
    partidosIda.forEach((partidoBD, index) => {
      const enfrentamiento = cuadroFinal[index];
      if (!enfrentamiento) return;

      const esBye = enfrentamiento.tipo === 'BYE';

      promesasUpdate.push(
        supabase
          .from('extra_playoffs_matches')
          .update({
            player1_id: enfrentamiento.p1.user_id,
            player2_id: esBye ? null : enfrentamiento.p2.user_id,
            is_played: esBye ? true : false // <--- AQUÍ SE PONE: Si es BYE, ya está jugado
          })
          .eq('id', partidoBD.id)
      );
    });

    // --- PROCESAR VUELTA ---
    partidosVuelta.forEach((partidoBD, index) => {
      const enfrentamiento = cuadroFinal[index];
      if (!enfrentamiento) return;

      const esBye = enfrentamiento.tipo === 'BYE';

      promesasUpdate.push(
        supabase
          .from('extra_playoffs_matches')
          .update({
            player1_id: esBye ? null : enfrentamiento.p2.user_id, // Invertido
            player2_id: enfrentamiento.p1.user_id, // Invertido
            is_played: esBye ? true : false // <--- TAMBIÉN EN VUELTA: Si es BYE, ya está jugado
          })
          .eq('id', partidoBD.id)
      );
    });

    const resultados = await Promise.all(promesasUpdate);
    const errorCritico = resultados.find(r => r.error);
    if (errorCritico) throw errorCritico.error;

    await propagarByesFaseInicial(torneoId);

    return { success: true };

  } catch (error) {
    console.error("Error al actualizar extra_playoffs_matches:", error);
    return null;
  }
};

export const procesarYPublicarPlayoffs = async (torneoId) => {
  try {
    console.log("🚀 Iniciando proceso de publicación de playoffs...");

    // 1. Obtener el ranking de la liguilla ya filtrado y ordenado
    // Esta es tu función original que devuelve los clasificados
    const ranking = await verificarYObtenerRankingLiguilla(torneoId);

    if (!ranking) {
      return { success: false, message: "Liguilla no terminada" };
    }

    // 2. Analizar la estructura para saber quién juega contra quién (Seeds/Byes)
    // Esta es tu función que calcula los emparejamientos
    const estructura = analizarEstructuraPlayoffs(ranking);

    if (!estructura) {
      console.error("❌ Error al calcular la estructura de los playoffs.");
      return { success: false };
    }

    // 3. Ejecutar la actualización en la tabla extra_playoffs_matches
    // Usamos la lógica de buscar p1_from_match_id e is_p2_from_match_id NULL
    const resultado = await actualizarPrimeraFasePlayoffs(torneoId, ranking, estructura);

    if (resultado && resultado.success) {
      console.log("🏆 Playoffs publicados y actualizados con éxito.");
      return { success: true, fase: estructura.nombreFase };
    } else {
      throw new Error("Error en la actualización de la base de datos");
    }

  } catch (error) {
    console.error("error crítico en el flujo de playoffs:", error);
    return { success: false, error: error.message };
  }
};

const propagarByesFaseInicial = async (torneoId) => {
  try {
    // 1. Buscamos partidos de la primera fase (parents NULL) que sean BYE (player2 NULL) y terminados
    const { data: partidosBye, error } = await supabase
      .from('extra_playoffs_matches')
      .select('id, player1_id')
      .eq('playoff_extra_id', torneoId)
      .is('p1_from_match_id', null)
      .is('p2_from_match_id', null)
      .is('player2_id', null)
      .eq('is_played', true);

    if (error) throw error;
    if (!partidosBye || partidosBye.length === 0) return;

    const promesasPropagacion = [];

    for (const partido of partidosBye) {
      // 2. Buscamos en qué partido de la siguiente fase este partido es el origen (p1 o p2)
      // Actualizamos al jugador 1 del partido original en el hueco correspondiente

      // Caso: Es el origen del Jugador 1 en la siguiente fase
      promesasPropagacion.push(
        supabase
          .from('extra_playoffs_matches')
          .update({ player1_id: partido.player1_id })
          .eq('playoff_extra_id', torneoId)
          .eq('p1_from_match_id', partido.id)
      );

      // Caso: Es el origen del Jugador 2 en la siguiente fase
      promesasPropagacion.push(
        supabase
          .from('extra_playoffs_matches')
          .update({ player2_id: partido.player1_id })
          .eq('playoff_extra_id', torneoId)
          .eq('p2_from_match_id', partido.id)
      );
    }

    await Promise.all(promesasPropagacion);
    console.log(`✨ Se han propagado ${partidosBye.length} jugadores por BYE.`);

  } catch (error) {
    console.error("Error al propagar BYEs:", error);
  }
};

/**
 * Función genérica para promocionar al ganador de un partido de playoff 
 * a la siguiente fase.
 */
export const promocionarGanadorPlayoff = async (torneoId, partidoActual) => {
  try {
    const { id, score1, score2, player1_id, player2_id, numero_jornada, is_played, p1_from_match_id } = partidoActual;
    if (!is_played) {
      await verificarYActualizarEstadoFinal(torneoId);
      return { success: true, info: 'Partido no terminado' };
    }
    if (numero_jornada?.toLowerCase().includes('final') && !numero_jornada?.toLowerCase().includes('semis')) {
      await verificarYActualizarEstadoFinal(torneoId);
      return { success: true, info: 'Final terminada' };
    }

    const esIda = numero_jornada?.toUpperCase().includes('IDA');
    const esVuelta = numero_jornada?.toUpperCase().includes('VUELTA');

    let ganadorId = null;
    let idReferencia = id;

    if (esIda || esVuelta) {
      const baseNombre = numero_jornada
        .replace(/IDA/gi, '')
        .replace(/VUELTA/gi, '')
        .trim();

      // 2. BUSQUEDA DE PAREJA: Jugadores cruzados + Misma jornada base
      const { data: pareja, error: errPareja } = await supabase
        .from('extra_playoffs_matches')
        .select('id, score1, score2, is_played, player1_id, player2_id, numero_jornada')
        .eq('playoff_extra_id', torneoId)
        .eq('player1_id', player2_id) // Cruzado
        .eq('player2_id', player1_id) // Cruzado
        .ilike('numero_jornada', `%${baseNombre}%`) // Misma fase (Cuartos, Semis...)
        .neq('id', id)                // Que no sea el mismo partido
        .maybeSingle();

      console.log("- Actual:", numero_jornada, "| Jugado:", is_played);
      console.log("- Pareja encontrada:", pareja?.numero_jornada, "| Jugado:", pareja?.is_played);

      // SUSTITUYE AQUÍ:
      if ((esIda || esVuelta) && (!pareja || pareja.is_played !== true || is_played !== true)) {
        console.log("No promocionando: Eliminatoria incompleta");
        return { success: false, info: 'incompleto' };
      }

      // --- DETERMINAR ROLES ---
      const partidoIda = esIda ? partidoActual : pareja;
      const partidoVuelta = esIda ? pareja : partidoActual;

      // SIEMPRE mandan los IDs de la IDA (tu requerimiento clave)
      idReferencia = partidoIda.id;

      const globalP1 = (partidoIda.score1 || 0) + (partidoVuelta.score2 || 0);
      const globalP2 = (partidoIda.score2 || 0) + (partidoVuelta.score1 || 0);

      if (globalP1 > globalP2) ganadorId = partidoIda.player1_id;
      else if (globalP2 > globalP1) ganadorId = partidoIda.player2_id;

      if (!ganadorId) return { success: true, info: 'Empate global' };
    }
    else {
      // Lógica para partido único
      if (score1 > score2) ganadorId = player1_id;
      else if (score2 > score1) ganadorId = player2_id;
      if (!is_played) return;
    }

    if (!ganadorId) return;

    // 4. ACTUALIZACIÓN: Usando idReferencia (ID de la IDA) para impactar la siguiente fase
    const promesas = [
      supabase.from('extra_playoffs_matches').update({ player1_id: ganadorId }).eq('playoff_extra_id', torneoId).eq('p1_from_match_id', idReferencia),
      supabase.from('extra_playoffs_matches').update({ player2_id: ganadorId }).eq('playoff_extra_id', torneoId).eq('p2_from_match_id', idReferencia)
    ];

    await verificarYActualizarEstadoFinal(torneoId);

    await Promise.all(promesas);
    console.log(`🏆 Ganador ${ganadorId} promocionado usando como referencia IDA ID: ${idReferencia}`);

    return { success: true, ganadorId };

  } catch (error) {
    console.error("Error promocionando ganador:", error);
    return { error };
  }
};

/**
 * Verifica si la final del torneo ha terminado y actualiza el estado del torneo.
 */
export const verificarYActualizarEstadoFinal = async (torneoId) => {
  try {
    const cleanId = torneoId.toString().replace('extra-', '');

    // 1. Buscamos todos los partidos que sean de la FINAL
    const { data: partidosFinal, error } = await supabase
      .from('extra_playoffs_matches')
      .select('is_played')
      .eq('playoff_extra_id', cleanId)
      .ilike('numero_jornada', '%FINAL%')
      .not('numero_jornada', 'ilike', '%SEMIS%'); // Evitar que "SEMIFINAL" cuente como "FINAL"

    if (error) throw error;
    if (!partidosFinal || partidosFinal.length === 0) return;

    // 2. Comprobar si todos los partidos de la final están jugados
    const finalTerminada = partidosFinal.every(m => m.is_played === true);
    const nuevoEstado = finalTerminada ? 'finalizado' : 'activo';

    // 3. Actualizar la tabla principal
    await supabase
      .from('playoffs_extra')
      .update({ estado: nuevoEstado })
      .eq('id', cleanId);

    console.log(`🏁 Estado del torneo ${cleanId} verificado: ${nuevoEstado}`);
  } catch (err) {
    console.error("Error al actualizar estado final:", err);
  }
};