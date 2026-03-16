import { useState } from 'react'
import { supabase } from '../supabaseClient'

export default function SwitchPlayer({ season, availableUsers, onComplete }) {
  const [loading, setLoading] = useState(false);
  const [playerOut, setPlayerOut] = useState('');
  const [playerIn, setPlayerIn] = useState('');

  const handleSwitch = async () => {
    if (!playerOut || !playerIn) return alert("Selecciona ambos jugadores");
    if (playerOut === playerIn) return alert("El jugador de entrada y salida no pueden ser el mismo");
    
    // Actualizamos el mensaje de confirmación para que sea veraz
    const confirm = window.confirm(`¿Estás seguro? Se reemplazarán TODOS los partidos (jugados y pendientes) de la Temporada ${season}. El nuevo jugador heredará los resultados del anterior.`);
    if (!confirm) return;

    setLoading(true);
    try {
      // 1. Reemplazar como Local en todos los partidos de la temporada
      const { error: errLocal } = await supabase
        .from('matches')
        .update({ home_team: playerIn })
        .eq('season', season)
        .eq('home_team', playerOut);

      // 2. Reemplazar como Visitante en todos los partidos de la temporada
      const { error: errAway } = await supabase
        .from('matches')
        .update({ away_team: playerIn })
        .eq('season', season)
        .eq('away_team', playerOut);

      if (errLocal || errAway) throw new Error("Error al actualizar la base de datos");

      alert("¡Cambio global completado con éxito!");
      onComplete(); 
    } catch (error) {
      alert("Error: " + error.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{
      padding: '15px', background: '#f8fafc', borderRadius: '8px', 
      border: '1px solid #e2e8f0', marginTop: '10px', display: 'flex', 
      flexDirection: 'column', gap: '10px', boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.05)'
    }}>
      <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
        <div style={{ flex: 1 }}>
          <label style={{ display: 'block', fontSize: '0.7rem', fontWeight: 'bold', color: '#64748b', marginBottom: '4px' }}>JUGADOR QUE SALE:</label>
          <select 
            value={playerOut} 
            onChange={e => setPlayerOut(e.target.value)}
            style={{ width: '100%', padding: '8px', borderRadius: '4px', border: '1px solid #cbd5e1' }}
          >
            <option value="">Selecciona...</option>
            {availableUsers.map(u => <option key={u.id} value={u.id}>{u.nick}</option>)}
          </select>
        </div>

        <div style={{ flex: 1 }}>
          <label style={{ display: 'block', fontSize: '0.7rem', fontWeight: 'bold', color: '#64748b', marginBottom: '4px' }}>NUEVO SUSTITUTO:</label>
          <select 
            value={playerIn} 
            onChange={e => setPlayerIn(e.target.value)}
            style={{ width: '100%', padding: '8px', borderRadius: '4px', border: '1px solid #cbd5e1' }}
          >
            <option value="">Selecciona...</option>
            {availableUsers.map(u => <option key={u.id} value={u.id}>{u.nick}</option>)}
          </select>
        </div>
      </div>

      <button
        onClick={handleSwitch}
        disabled={loading}
        style={{
          background: loading ? '#94a3b8' : '#3498db', 
          color: 'white', border: 'none', padding: '10px', 
          borderRadius: '6px', cursor: loading ? 'default' : 'pointer', 
          fontWeight: 'bold', transition: 'background 0.2s'
        }}
      >
        {loading ? 'ACTUALIZANDO...' : 'CONFIRMAR SUSTITUCIÓN TOTAL'}
      </button>
      <small style={{ color: '#94a3b8', fontSize: '0.65rem', textAlign: 'center' }}>
        * Esta acción modificará el historial de la temporada actual.
      </small>
    </div>
  );
}