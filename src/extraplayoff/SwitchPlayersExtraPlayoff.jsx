import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

export default function SwitchPlayersExtraPlayoff({ torneoId, allProfiles, onFinished }) {
  const [loading, setLoading] = useState(false);
  const [jugadoresPlayoff, setJugadoresPlayoff] = useState([]);
  const [selectedOldPlayer, setSelectedOldPlayer] = useState('');
  const [selectedNewPlayer, setSelectedNewPlayer] = useState('');

  useEffect(() => {
    if (torneoId) fetchJugadoresActuales();
  }, [torneoId]);

  // 1. Obtener jugadores que realmente están participando en esta playoff
  const fetchJugadoresActuales = async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from('extra_matches')
      .select('player1_id, player2_id')
      .eq('extra_id', torneoId);

    if (error) {
      console.error("Error cargando jugadores de la liguilla:", error);
    } else {
      const ids = new Set();
      data.forEach(m => {
        if (m.player1_id) ids.add(m.player1_id);
        if (m.player2_id) ids.add(m.player2_id);
      });
      
      // Mapeamos los IDs a los nicks usando el prop allProfiles
      const lista = allProfiles
        .filter(p => ids.has(p.id))
        .sort((a, b) => a.nick.localeCompare(b.nick));
      
      setJugadoresPlayoff(lista);
    }
    setLoading(false);
  };

  // 2. Filtrar base de datos general (excluyendo "Retirados")
  const candidatosDisponibles = allProfiles.filter(p => 
    !p.nick?.toLowerCase().startsWith("retirado")
  );

  const ejecutarSustitucion = async () => {
    if (!selectedOldPlayer || !selectedNewPlayer) return alert("Selecciona ambos jugadores");
    if (selectedOldPlayer === selectedNewPlayer) return alert("No puedes sustituir un jugador por sí mismo");
    
    const confirmacion = confirm("¿Estás seguro? Se reemplazará al jugador en todos los partidos de liguilla y eliminatorias de este torneo.");
    if (!confirmacion) return;

    setLoading(true);
    try {
      // TABLA 1: extra_matches (Liguilla)
      const res1_p1 = await supabase.from('extra_matches').update({ player1_id: selectedNewPlayer }).eq('extra_id', torneoId).eq('player1_id', selectedOldPlayer);
      const res1_p2 = await supabase.from('extra_matches').update({ player2_id: selectedNewPlayer }).eq('extra_id', torneoId).eq('player2_id', selectedOldPlayer);

      // TABLA 2: extra_playoffs_matches (Eliminatorias/Cuadro)
      const res2_p1 = await supabase.from('extra_playoffs_matches').update({ player1_id: selectedNewPlayer }).eq('playoff_extra_id', torneoId).eq('player1_id', selectedOldPlayer);
      const res2_p2 = await supabase.from('extra_playoffs_matches').update({ player2_id: selectedNewPlayer }).eq('playoff_extra_id', torneoId).eq('player2_id', selectedOldPlayer);

      alert("✅ Jugador sustituido correctamente en todas las fases.");
      if (onFinished) onFinished();
    } catch (err) {
      console.error(err);
      alert("Error al procesar la sustitución.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ 
      marginTop: '15px', 
      padding: '15px', 
      background: '#f0f7ff', 
      borderRadius: '8px', 
      border: '1px solid #b8daff' 
    }}>
      <h5 style={{ margin: '0 0 10px 0', color: '#004085' }}>🔄 Sustituir Jugador en Torneo</h5>
      <p style={{ fontSize: '0.75rem', color: '#666', marginBottom: '10px' }}>
        Sustituye a un participante por otro de la base de datos (se actualizarán liguilla y cuadro).
      </p>

      <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
        <div style={{ flex: 1, minWidth: '200px' }}>
          <label style={{ fontSize: '0.7rem', display: 'block', fontWeight: 'bold' }}>Sustituir a:</label>
          <select 
            value={selectedOldPlayer} 
            onChange={e => setSelectedOldPlayer(e.target.value)}
            style={{ width: '100%', padding: '8px', borderRadius: '4px' }}
          >
            <option value="">-- Jugador actual --</option>
            {jugadoresPlayoff.map(p => <option key={p.id} value={p.id}>{p.nick}</option>)}
          </select>
        </div>

        <div style={{ flex: 1, minWidth: '200px' }}>
          <label style={{ fontSize: '0.7rem', display: 'block', fontWeight: 'bold' }}>Por el nuevo jugador:</label>
          <select 
            value={selectedNewPlayer} 
            onChange={e => setSelectedNewPlayer(e.target.value)}
            style={{ width: '100%', padding: '8px', borderRadius: '4px' }}
          >
            <option value="">-- Buscar en DB --</option>
            {candidatosDisponibles.map(p => <option key={p.id} value={p.id}>{p.nick}</option>)}
          </select>
        </div>

        <button 
          onClick={ejecutarSustitucion}
          disabled={loading}
          style={{
            alignSelf: 'flex-end',
            padding: '8px 20px',
            background: '#007bff',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            fontWeight: 'bold',
            cursor: 'pointer'
          }}
        >
          {loading ? 'Procesando...' : 'Confirmar Cambio'}
        </button>
      </div>
    </div>
  );
}