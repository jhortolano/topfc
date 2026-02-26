import { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';

const AvisosAdmin = () => {
  const [aviso, setAviso] = useState({
    titulo: '',
    contenido: '',
    mostrar: false
  });
  const [loading, setLoading] = useState(true);

  // 1. Cargar el aviso actual al iniciar
  useEffect(() => {
    fetchAviso();
  }, []);

  const fetchAviso = async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from('avisos')
      .select('*')
      .eq('id', 1)
      .single();

    if (data) setAviso(data);
    if (error) console.error('Error cargando aviso:', error.message);
    setLoading(false);
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setAviso(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
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
    </div>
  );
};

export default AvisosAdmin;