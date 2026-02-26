import { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';

const AvisosAdmin = () => {
  const [aviso, setAviso] = useState({
    titulo: '',
    contenido: '',
    mostrar: false
  });
  const [loading, setLoading] = useState(true);
  const [encuestas, setEncuestas] = useState([]);
  const [nuevaEncuesta, setNuevaEncuesta] = useState({ pregunta: '', opciones: ['', ''], activa: true });
  const [editandoId, setEditandoId] = useState(null);
  const [usuarios, setUsuarios] = useState([]);
  const [votos, setVotos] = useState([]);
  const [mostrarTodos, setMostrarTodos] = useState({});

  // 1. Cargar el aviso actual al iniciar
  useEffect(() => {
    fetchDatos();
  }, []);

  const fetchDatos = async () => {
    setLoading(true);
    // Carga aviso (tu código actual)
    const { data: avisoData } = await supabase.from('avisos').select('*').eq('id', 1).single();
    if (avisoData) setAviso(avisoData);

    // NUEVO: Carga encuestas, perfiles y votos
    const { data: encData } = await supabase.from('encuestas').select('*').order('created_at', { ascending: false });
    const { data: profData } = await supabase.from('profiles').select('id, nick');
    const { data: votosData } = await supabase.from('votos_encuesta').select('*');

    setEncuestas(encData || []);
    setUsuarios(profData || []);
    setVotos(votosData || []);
    setLoading(false);
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setAviso(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  const handleOpcionChange = (idx, valor) => {
    const nuevas = [...nuevaEncuesta.opciones];
    nuevas[idx] = valor;
    setNuevaEncuesta({ ...nuevaEncuesta, opciones: nuevas });
  };

  const guardarEncuesta = async () => {
    if (!nuevaEncuesta.pregunta) return alert("Escribe una pregunta");
    const { error } = await supabase.from('encuestas').upsert({
      id: editandoId || undefined,
      pregunta: nuevaEncuesta.pregunta,
      opciones: nuevaEncuesta.opciones.filter(o => o.trim() !== ''),
      activa: nuevaEncuesta.activa
    });
    if (error) alert(error.message);
    else {
      setNuevaEncuesta({ pregunta: '', opciones: ['', ''], activa: true });
      setEditandoId(null);
      fetchDatos();
    }
  };

  const borrarEncuesta = async (id) => {
    if (confirm("¿Borrar encuesta y sus votos?")) {
      await supabase.from('encuestas').delete().eq('id', id);
      fetchDatos();
    }
  };

  // --- FUNCIÓN PARA ATAJOS DE TECLADO (AHORA DENTRO DEL COMPONENTE) ---
  const handleKeyDown = (e) => {
    const isModKey = e.ctrlKey || e.metaKey;

    if (isModKey && e.key === 'b') {
      e.preventDefault();
      const campo = e.target;
      const start = campo.selectionStart;
      const end = campo.selectionEnd;
      const seleccionado = aviso.contenido.substring(start, end);

      if (seleccionado) {
        const nuevoTexto =
          aviso.contenido.substring(0, start) + `**${seleccionado}**` + aviso.contenido.substring(end);
        setAviso({ ...aviso, contenido: nuevoTexto });
        setTimeout(() => {
          campo.focus();
          campo.setSelectionRange(start, end + 4);
        }, 10);
      }
    }
    else if (isModKey && e.key === 'i') {
      e.preventDefault();
      const campo = e.target;
      const start = campo.selectionStart;
      const end = campo.selectionEnd;
      const seleccionado = aviso.contenido.substring(start, end);

      if (seleccionado) {
        const nuevoTexto =
          aviso.contenido.substring(0, start) + `*${seleccionado}*` + aviso.contenido.substring(end);
        setAviso({ ...aviso, contenido: nuevoTexto });
        setTimeout(() => {
          campo.focus();
          campo.setSelectionRange(start, end + 2);
        }, 10);
      }
    }
  };

  // 2. Lógica para Guardar (Upsert)
  const guardarAviso = async () => {
    const { error } = await supabase
      .from('avisos')
      .upsert({
        id: 1,
        titulo: aviso.titulo,
        contenido: aviso.contenido,
        mostrar: aviso.mostrar,
        updated_at: new Date()
      });

    if (error) {
      alert('Error al guardar: ' + error.message);
    } else {
      alert('Aviso actualizado correctamente');
    }
  };

  const borrarCampos = async () => {
    const estadoLimpio = { titulo: '', contenido: '', mostrar: false };
    setAviso(estadoLimpio);
    await supabase.from('avisos').update(estadoLimpio).eq('id', 1);
  };

  if (loading) return <p>Cargando configuración...</p>;

  return (
    <div style={{ padding: '20px', maxWidth: '600px', border: '1px solid #ccc', borderRadius: '8px' }}>
      <h2>Panel de Administración de Avisos</h2>

      <div style={{ marginBottom: '15px' }}>
        <label style={{ fontWeight: 'bold' }}>Título del Aviso:</label>
        <input
          type="text"
          name="titulo"
          value={aviso.titulo}
          onChange={handleChange}
          style={{ width: '100%', padding: '10px', marginTop: '5px' }}
        />
      </div>

      <div style={{ marginBottom: '15px' }}>
        <label style={{ fontWeight: 'bold' }}>Contenido:</label>
        <textarea
          name="contenido"
          value={aviso.contenido}
          onChange={handleChange}
          onKeyDown={handleKeyDown} // <--- IMPORTANTE: Conectar la función aquí
          placeholder="Escribe aquí... Usa Cmd+B para negrita o Cmd+I para cursiva"
          rows="6"
          style={{ width: '100%', padding: '10px', marginTop: '5px', fontFamily: 'inherit' }}
        />
      </div>

      <div style={{ marginBottom: '20px' }}>
        <label style={{ display: 'flex', alignItems: 'center', cursor: 'pointer' }}>
          <input
            type="checkbox"
            name="mostrar"
            checked={aviso.mostrar}
            onChange={handleChange}
            style={{ marginRight: '10px' }}
          />
          <strong>Publicar aviso (Hacer visible para usuarios)</strong>
        </label>
      </div>

      <div style={{ display: 'flex', gap: '10px' }}>
        <button onClick={guardarAviso} style={{ backgroundColor: '#3ecf8e', color: 'white', padding: '10px 25px', border: 'none', borderRadius: '4px', cursor: 'pointer', fontWeight: 'bold' }}>
          Guardar Cambios
        </button>
        <button onClick={borrarCampos} style={{ backgroundColor: '#ff4d4f', color: 'white', padding: '10px 25px', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
          Borrar Todo
        </button>
      </div>

      {/* SECCIÓN CREAR ENCUESTA */}
      <div style={{ marginTop: '30px', padding: '20px', border: '1px solid #3498db', borderRadius: '8px', background: '#f0f7ff' }}>
        <h3>{editandoId ? 'Editar Encuesta' : 'Crear Nueva Encuesta'}</h3>
        <input type="text" placeholder="Pregunta" value={nuevaEncuesta.pregunta} onChange={(e) => setNuevaEncuesta({ ...nuevaEncuesta, pregunta: e.target.value })} style={{ width: '100%', padding: '10px', marginBottom: '10px' }} />

        {nuevaEncuesta.opciones.map((op, idx) => (
          <input key={idx} type="text" placeholder={`Opción ${idx + 1}`} value={op} onChange={(e) => handleOpcionChange(idx, e.target.value)} style={{ width: '100%', padding: '8px', marginBottom: '5px' }} />
        ))}

        <div style={{ marginBottom: '10px' }}>
          <button onClick={() => setNuevaEncuesta({ ...nuevaEncuesta, opciones: [...nuevaEncuesta.opciones, ''] })}>➕ Opción</button>
          <button onClick={() => { if (nuevaEncuesta.opciones.length > 1) setNuevaEncuesta({ ...nuevaEncuesta, opciones: nuevaEncuesta.opciones.slice(0, -1) }) }} style={{ marginLeft: '5px' }}>➖ Quitar</button>
        </div>

        <label style={{ display: 'block', marginBottom: '10px' }}>
          <input type="checkbox" checked={nuevaEncuesta.activa} onChange={(e) => setNuevaEncuesta({ ...nuevaEncuesta, activa: e.target.checked })} /> Encuesta Activa
        </label>

        <button onClick={guardarEncuesta} style={{ background: '#3498db', color: 'white', padding: '10px 20px', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
          {editandoId ? 'Actualizar' : 'Guardar Encuesta'}
        </button>
      </div>

      {/* LISTADO Y RESULTADOS */}
      <div style={{ marginTop: '30px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '15px' }}>
          <h3 style={{ margin: 0 }}>Encuestas y Resultados</h3>
        </div>

        {encuestas.map(enc => {
          const vEnc = votos.filter(v => v.encuesta_id === enc.id);
          return (
            <div key={enc.id} style={{
              padding: '20px',
              border: '1px solid #e1e8ed',
              marginTop: '20px',
              borderRadius: '12px',
              background: 'white',
              boxShadow: '0 2px 8px rgba(0,0,0,0.05)'
            }}>
              {/* Cabecera: Título + Estado + Acciones */}
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '15px' }}>
                <div style={{ flex: 1 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '5px' }}>
                    <span style={{
                      fontSize: '0.65rem',
                      fontWeight: 'bold',
                      padding: '3px 8px',
                      borderRadius: '12px',
                      textTransform: 'uppercase',
                      background: enc.activa ? '#e6fffa' : '#fff5f5',
                      color: enc.activa ? '#2d8a6e' : '#e53e3e',
                      border: `1px solid ${enc.activa ? '#3ecf8e' : '#feb2b2'}`
                    }}>
                      {enc.activa ? '● Activa' : '○ Finalizada'}
                    </span>
                    <strong style={{ fontSize: '1.1rem', color: '#2c3e50' }}>{enc.pregunta}</strong>
                  </div>
                </div>
                <div style={{ display: 'flex', gap: '5px' }}>
                  <button onClick={() => { setEditandoId(enc.id); setNuevaEncuesta({ pregunta: enc.pregunta, opciones: enc.opciones, activa: enc.activa }); }}
                    style={{ padding: '5px 10px', fontSize: '0.75rem', cursor: 'pointer', borderRadius: '4px', border: '1px solid #ccc' }}>
                    Editar
                  </button>
                  <button onClick={() => borrarEncuesta(enc.id)}
                    style={{ padding: '5px 10px', fontSize: '0.75rem', cursor: 'pointer', borderRadius: '4px', border: '1px solid #ff4d4f', color: '#ff4d4f', background: 'none' }}>
                    Borrar
                  </button>
                </div>
              </div>

              {/* Resumen de Votos (Barritas visuales simples) */}
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: '10px', padding: '10px', background: '#f8f9fa', borderRadius: '8px', fontSize: '0.85rem' }}>
                {enc.opciones.map((op, i) => {
                  const numVotos = vEnc.filter(v => v.opcion_index === i).length;
                  return (
                    <div key={i} style={{ padding: '4px 10px', background: '#fff', border: '1px solid #dee2e6', borderRadius: '6px' }}>
                      <strong>{op}:</strong> {numVotos}
                    </div>
                  );
                })}
                <div style={{ padding: '4px 10px', color: '#7f8c8d' }}>
                  <strong>No votado:</strong> {usuarios.length - vEnc.length}
                </div>
              </div>

              {/* Detalle de Usuarios en 2 Columnas */}
              {/* Busca donde dice "Detalle de Usuarios en 2 Columnas" y pega esto: */}
              <div style={{ marginTop: '15px' }}>
                {/* El checkbox ahora vive aquí adentro, uno para cada encuesta */}
                <label style={{ fontSize: '0.75rem', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'flex-end', marginBottom: '8px', color: '#7f8c8d' }}>
                  <input
                    type="checkbox"
                    checked={!!mostrarTodos[enc.id]}
                    onChange={(e) => setMostrarTodos({ ...mostrarTodos, [enc.id]: e.target.checked })}
                    style={{ marginRight: '5px' }}
                  />
                  Mostrar todos los usuarios
                </label>

                <div style={{
                  display: 'grid',
                  gridTemplateColumns: 'repeat(2, 1fr)',
                  gap: '8px'
                }}>
                  {usuarios.map(u => {
                    const vo = vEnc.find(v => v.usuario_id === u.id);

                    // ESTE ES EL CAMBIO CLAVE: ahora comprueba el ID de esta encuesta específica
                    if (!vo && !mostrarTodos[enc.id]) return null;

                    return (
                      <div key={u.id} style={{
                        display: 'flex',
                        justifyContent: 'space-between',
                        padding: '8px 12px',
                        background: vo ? '#f0f7ff' : '#fdfdfd',
                        borderRadius: '6px',
                        border: vo ? '1px solid #d0e7ff' : '1px solid #eee',
                        fontSize: '0.8rem'
                      }}>
                        <span style={{ fontWeight: '600', color: '#34495e' }}>{u.nick}</span>
                        <span style={{
                          color: vo ? '#2980b9' : '#95a5a6',
                          fontStyle: vo ? 'normal' : 'italic',
                          fontWeight: vo ? 'bold' : 'normal'
                        }}>
                          {vo ? enc.opciones[vo.opcion_index] : '---'}
                        </span>
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>
          );
        })}
      </div>

    </div>
  );
};

export default AvisosAdmin;