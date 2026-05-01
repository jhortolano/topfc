import React, { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient'; // Ajusta la ruta a tu cliente

const EspecificarEquiposExtraPlayoff = ({ extraPlayoffId, season }) => {
  const [tieneDiccionario, setTieneDiccionario] = useState(false);
  const [equipos, setEquipos] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchEstadoDiccionario();
  }, [extraPlayoffId]);

  const fetchEstadoDiccionario = async () => {
    setLoading(true);
    // 1. Consultar si tiene_diccionario es True
    const { data: playoffData } = await supabase
      .from('playoffs_extra')
      .select('tiene_diccionario')
      .eq('id', extraPlayoffId)
      .single();

    if (playoffData) {
      setTieneDiccionario(playoffData.tiene_diccionario);
      if (playoffData.tiene_diccionario) {
        fetchDiccionarioExistente();
      }
    }
    setLoading(false);
  };

  const fetchDiccionarioExistente = async () => {
    const { data, error } = await supabase
      .from('diccionario_equipos')
      .select('*')
      .eq('id_playoff', extraPlayoffId);

    if (error) {
      console.error("Error cargando diccionario:", error.message);
      return;
    }
    setEquipos(data || []);
  };

  const handleCheckboxChange = async (e) => {
    const checked = e.target.checked;

    if (!checked) {
      const confirmar = window.confirm("¿Quiere borrar todos los equipos guardados?");
      if (confirmar) {
        // Borrar en cascada
        await supabase.from('diccionario_equipos').delete().eq('id_playoff', extraPlayoffId);
        await supabase.from('playoffs_extra').update({ tiene_diccionario: false }).eq('id', extraPlayoffId);
        setTieneDiccionario(false);
        setEquipos([]);
      }
    } else {
      // Activar diccionario y generar filas
      await supabase.from('playoffs_extra').update({ tiene_diccionario: true }).eq('id', extraPlayoffId);
      setTieneDiccionario(true);
      generarNuevasFilas();
    }
  };

  const generarNuevasFilas = async () => {
    setLoading(true);
    // Obtener IDs de jugadores de los partidos
    const { data: matches } = await supabase
      .from('extra_matches')
      .select('player1_id, player2_id')
      .eq('extra_id', extraPlayoffId);

    const playerIds = [...new Set(matches.flatMap(m => [m.player1_id, m.player2_id]))].filter(id => id);

    // Obtener nicks de perfiles
    const { data: profiles } = await supabase
      .from('profiles')
      .select('id, nick')
      .in('id', playerIds);

    const nuevasFilas = profiles.map(p => ({
      user_id: p.id,
      nick: p.nick,
      es_liga: false,
      es_playoff: false,
      es_extra_playoff: true,
      season: season,
      id_playoff: extraPlayoffId,
      texto1: '',
      texto2: '',
      texto3: ''
    }));

    // Insertar en Supabase
    const { data: insertedData, error } = await supabase
      .from('diccionario_equipos')
      .insert(nuevasFilas)
      .select();

    if (!error) setEquipos(insertedData);
    setLoading(false);
  };

  const handleTextChange = (index, field, value) => {
    const newEquipos = [...equipos];
    newEquipos[index][field] = value;
    setEquipos(newEquipos);
  };

  const guardarCambios = async () => {
    for (const equipo of equipos) {
      await supabase
        .from('diccionario_equipos')
        .update({
          texto1: equipo.texto1,
          texto2: equipo.texto2,
          texto3: equipo.texto3
        })
        .eq('id_playoff', extraPlayoffId)
        .eq('nick', equipo.nick);
    }
    alert("Datos guardados correctamente");
  };

  if (loading) return <p>Cargando panel...</p>;

  return (
    <div style={{ border: '1px solid #ccc', padding: '15px', marginTop: '10px' }}>
      <label>
        <input
          type="checkbox"
          checked={tieneDiccionario}
          onChange={handleCheckboxChange}
        />
        Especificar equipos
      </label>

      {tieneDiccionario && (
        <div style={{ marginTop: '20px' }}>
          <table style={{ width: '100%', textAlign: 'left' }}>
            <thead>
              <tr>
                <th>Nick</th>
                <th>Texto 1</th>
                <th>Texto 2</th>
                <th>Texto 3</th>
              </tr>
            </thead>
            <tbody>
              {equipos.map((eq, index) => (
                <tr key={eq.id || index}>
                  <td>{eq.nick}</td>
                  <td>
                    <input
                      type="text"
                      value={eq.texto1 || ''}
                      onChange={(e) => handleTextChange(index, 'texto1', e.target.value)}
                    />
                  </td>
                  <td>
                    <input
                      type="text"
                      value={eq.texto2 || ''}
                      onChange={(e) => handleTextChange(index, 'texto2', e.target.value)}
                    />
                  </td>
                  <td>
                    <input
                      type="text"
                      value={eq.texto3 || ''}
                      onChange={(e) => handleTextChange(index, 'texto3', e.target.value)}
                    />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <button onClick={guardarCambios} style={{ marginTop: '15px' }}>
            Guardar
          </button>
        </div>
      )}
    </div>
  );
};

export default EspecificarEquiposExtraPlayoff;