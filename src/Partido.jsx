import { useState, useEffect } from 'react' // Importante añadir useEffect aquí
import { supabase } from './supabaseClient'

const Avatar = ({ url }) => (
  <div style={{ 
    width: '35px', height: '35px', borderRadius: '50%', overflow: 'hidden', 
    background: '#34495e', border: '2px solid #2ecc71', flexShrink: 0 
  }}>
    {url ? (
      <img src={url} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
    ) : (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100%', fontSize: '0.8rem', color: '#7f8c8d' }}>👤</div>
    )}
  </div>
);

function TarjetaResultado({ partido, onUpdated }) {
  const [gL, setGL] = useState(partido.home_score ?? '');
  const [gV, setGV] = useState(partido.away_score ?? '');
  const [enviando, setEnviando] = useState(false);

  const guardar = async () => {
    if (gL === '' || gV === '') return alert("Introduce los goles");
    setEnviando(true);
    const { error } = await supabase
      .from('matches')
      .update({ home_score: parseInt(gL), away_score: parseInt(gV), is_played: true })
      .eq('id', partido.id);
    
    if (!error) {
      alert("Resultado guardado");
      if (onUpdated) onUpdated();
    }
    setEnviando(false);
  }

  return (
    <div style={{ background: '#2c3e50', color: 'white', padding: '15px', borderRadius: '12px', textAlign: 'center', position: 'relative' }}>
      <div style={{ position: 'absolute', top: '5px', left: '10px', fontSize: '0.6rem', color: '#2ecc71', fontWeight: 'bold' }}>
        JORNADA {partido.week}
      </div>

      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: '15px', marginBottom: '10px', marginTop: '15px' }}>
        
        {/* LOCAL: Nick y Avatar */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '5px' }}>
          <Avatar url={partido.local_avatar} />
          <div style={{ fontSize: '0.8rem', fontWeight: 'bold', width: '100%', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {partido.local_nick}
          </div>
        </div>

        {/* MARCADOR / INPUTS */}
        <div style={{ display: 'flex', alignItems: 'center' }}>
          {partido.is_played ? (
            <div style={{ background: '#34495e', padding: '8px 15px', borderRadius: '8px', border: '2px solid #2ecc71', fontWeight: 'bold', fontSize: '1.2rem', minWidth: '60px' }}>
              {partido.home_score} - {partido.away_score}
            </div>
          ) : (
            <div style={{ display: 'flex', gap: '5px', alignItems: 'center' }}>
              <input type="number" min="0" value={gL} onChange={e => setGL(e.target.value)} style={{ width: '45px', textAlign: 'center', padding: '8px', borderRadius: '6px', border: 'none', fontSize: '18px', fontWeight: 'bold' }} />
              <span style={{ fontWeight: 'bold', fontSize: '1.2rem' }}>-</span>
              <input type="number" min="0" value={gV} onChange={e => setGV(e.target.value)} style={{ width: '45px', textAlign: 'center', padding: '8px', borderRadius: '6px', border: 'none', fontSize: '18px', fontWeight: 'bold' }} />
            </div>
          )}
        </div>

        {/* VISITANTE: Avatar y Nick */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '5px' }}>
          <Avatar url={partido.visitante_avatar} />
          <div style={{ fontSize: '0.8rem', fontWeight: 'bold', width: '100%', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {partido.visitante_nick}
          </div>
        </div>

      </div>

      {!partido.is_played && (
        <button onClick={guardar} disabled={enviando} style={{ background: '#2ecc71', color: 'white', border: 'none', padding: '12px', borderRadius: '8px', cursor: 'pointer', fontWeight: 'bold', width: '100%', marginTop: '10px', fontSize: '0.85rem' }}>
          {enviando ? 'GUARDANDO...' : 'POSTEAR RESULTADO'}
        </button>
      )}
    </div>
  )
}

function ProximoPartido({ profile, config, onUpdated }) {
  const [partidos, setPartidos] = useState([])
  const [loading, setLoading] = useState(true)

  const cargar = async () => {
    if (!config || !profile) return;
    setLoading(true)
    
    const { data: currentWeekData } = await supabase
      .from('weeks_schedule')
      .select('start_at, end_at')
      .eq('season', config.current_season)
      .eq('week', config.current_week)
      .single();

    if (currentWeekData) {
      const { data: activeWeeks } = await supabase
        .from('weeks_schedule')
        .select('week')
        .eq('season', config.current_season)
        .eq('start_at', currentWeekData.start_at)
        .eq('end_at', currentWeekData.end_at);

      const weekNumbers = activeWeeks.map(w => w.week);

      const { data } = await supabase
        .from('partidos_detallados')
        .select('*')
        .eq('season', config.current_season)
        .in('week', weekNumbers)
        .or(`local_nick.eq."${profile.nick}",visitante_nick.eq."${profile.nick}"`)
        .order('week', { ascending: true });
      
      setPartidos(data || []);
    }
    setLoading(false)
  }

  useEffect(() => {
    cargar();
  }, [profile, config])

  if (loading) return <div style={{fontSize: '0.8rem', color: '#95a5a6'}}>Cargando partidos...</div>

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
      {partidos.length === 0 ? (
        <div style={{ color: '#95a5a6', fontSize: '0.8rem', textAlign: 'center', padding: '20px' }}>
          No hay partidos programados para la Jornada {config.current_week}.
        </div>
      ) : (
        partidos.map(p => (
          <TarjetaResultado key={p.id} partido={p} onUpdated={cargar} />
        ))
      )}
    </div>
  )
}

export default ProximoPartido;