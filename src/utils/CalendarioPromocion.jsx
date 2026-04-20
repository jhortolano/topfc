import { useState, useEffect } from 'react'
import { supabase } from '../supabaseClient'

const AvatarConZoom = ({ url }) => {
  const [isTouched, setIsTouched] = useState(false);
  return (
    <div
      onTouchStart={() => setIsTouched(true)}
      onTouchEnd={() => setIsTouched(false)}
      onMouseEnter={e => { e.currentTarget.style.transform = 'scale(2.8)'; e.currentTarget.style.zIndex = '100'; }}
      onMouseLeave={e => { e.currentTarget.style.transform = 'scale(1)'; e.currentTarget.style.zIndex = '1'; }}
      style={{
        width: '24px', height: '24px', borderRadius: '50%', overflow: 'hidden', background: '#eee', 
        border: '1px solid #ddd', flexShrink: 0, cursor: 'pointer', transition: 'transform 0.2s ease-in-out',
        position: 'relative', zIndex: isTouched ? 100 : 1, transform: isTouched ? 'scale(2.8)' : 'scale(1)'
      }}
    >
      {url ? <img src={url} style={{ width: '100%', height: '100%', objectFit: 'cover' }} alt="avatar" /> : 
             <div style={{ fontSize: '0.6rem', color: '#bdc3c7', textAlign: 'center', lineHeight: '24px' }}>👤</div>}
    </div>
  );
};

export default function CalendarioPromocion({ season }) {
  const [partidos, setPartidos] = useState([]);
  const [fechasMap, setFechasMap] = useState({});
  const [loading, setLoading] = useState(true);
  const [userNick, setUserNick] = useState(null);

  useEffect(() => {
    async function loadData() {
      if (!season) return;
      setLoading(true);

      const { data: weeksData } = await supabase
        .from('weeks_promo')
        .select('*')
        .eq('season', season);
      
      const fMap = {};
      weeksData?.forEach(w => {
        const faseKey = (w.idavuelta || "").toLowerCase().trim();
        fMap[faseKey] = {
          objInicio: new Date(w.start_at),
          objFin: new Date(w.end_at),
          inicioStr: new Date(w.start_at).toLocaleString([], { day: '2-digit', month: '2-digit' }),
          finStr: new Date(w.end_at).toLocaleString([], { day: '2-digit', month: '2-digit' })
        };
      });
      setFechasMap(fMap);

      const { data: matchesData, error } = await supabase
        .from('promo_matches')
        .select(`
          *,
          local:player1_id(nick, avatar_url),
          visitante:player2_id(nick, avatar_url)
        `)
        .eq('season', season)
        .order('division', { ascending: true });

      if (!error) setPartidos(matchesData || []);
      setLoading(false);
    }
    loadData();
  }, [season]);

  useEffect(() => {
    async function getMyNick() {
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        const { data } = await supabase.from('profiles').select('nick').eq('id', user.id).maybeSingle();
        if (data) setUserNick(data.nick);
      }
    }
    getMyNick();
  }, []);

  if (loading) return <p style={{ textAlign: 'center', fontSize: '0.8rem', color: '#95a5a6' }}>Cargando promoción...</p>;
  if (partidos.length === 0) return <p style={{ textAlign: 'center', fontSize: '0.8rem', color: '#95a5a6' }}>No hay partidos de promoción.</p>;

  const ahora = new Date();
  const divisionesUnicas = [...new Set(partidos.map(p => p.division))].filter(d => d !== null).sort();

  return (
    <div style={{ marginTop: '20px' }}>
      {divisionesUnicas.map(div => {
        const partidosDeEstaDiv = partidos.filter(p => p.division === div);
        const fasesEnDiv = [...new Set(partidosDeEstaDiv.map(p => p.idavuelta))];
        const tieneVueltaGlobal = fasesEnDiv.some(f => f?.toLowerCase().includes('vuelta'));

        return (
          <div key={`div-container-${div}`} style={{ marginBottom: '30px' }}>
            <h3 style={{ fontSize: '0.85rem', color: '#e17055', marginBottom: '12px', fontWeight: 'bold', borderLeft: '4px solid #e17055', paddingLeft: '8px' }}>
              PROMOCIÓN DIVISIÓN {div}
            </h3>

            {fasesEnDiv.map(fase => {
              const partidosFase = partidosDeEstaDiv.filter(p => p.idavuelta === fase);
              const faseKey = (fase || "").toLowerCase().trim();
              const infoFecha = fechasMap[faseKey];
              
              // Lógica de Highlight: ¿es hoy la fecha de esta fase?
              const esFechaActual = infoFecha && ahora >= infoFecha.objInicio && ahora <= infoFecha.objFin;
              
              const nombreFaseVisual = fase || (tieneVueltaGlobal ? "Ida" : "Eliminatoria");

              return (
                <div key={`${div}-${fase}`} style={{ 
                  marginBottom: '15px', 
                  borderRadius: '8px', 
                  overflow: 'hidden', 
                  boxShadow: esFechaActual ? '0 4px 12px rgba(225, 112, 85, 0.2)' : '0 2px 4px rgba(0,0,0,0.03)',
                  border: esFechaActual ? '2px solid #e17055' : '1px solid #eee',
                  transition: 'all 0.3s ease'
                }}>
                  <div style={{ 
                    background: esFechaActual ? '#e17055' : '#fdf2f0', 
                    padding: '8px 12px', 
                    borderBottom: '1px solid #eee', 
                    display: 'flex', 
                    justifyContent: 'space-between', 
                    alignItems: 'center' 
                  }}>
                    <span style={{ fontSize: '0.65rem', fontWeight: 'bold', color: esFechaActual ? 'white' : '#d35400', textTransform: 'uppercase' }}>
                      {nombreFaseVisual} {esFechaActual && " (ACTUAL)"}
                    </span>
                    {infoFecha && (
                      <span style={{ fontSize: '0.65rem', color: esFechaActual ? 'white' : '#7f8c8d', fontWeight: '600' }}>
                        {infoFecha.inicioStr} al {infoFecha.finStr}
                      </span>
                    )}
                  </div>

                  {partidosFase.map(p => {
                    const esMiPartido = userNick && (p.local?.nick === userNick || p.visitante?.nick === userNick);
                    return (
                      <div key={`match-${p.id}`} style={{ 
                        display: 'flex', alignItems: 'center', padding: '10px', fontSize: '0.75rem', gap: '10px',
                        borderBottom: '1px solid #f9f9f9', 
                        background: esMiPartido ? 'rgba(225, 112, 85, 0.08)' : 'white',
                        borderLeft: esMiPartido ? '4px solid #e17055' : '4px solid transparent'
                      }}>
                        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: '8px', textAlign: 'right' }}>
                          <span style={{ fontWeight: esMiPartido ? 'bold' : 'normal' }}>{p.local?.nick || 'TBD'}</span>
                          <AvatarConZoom url={p.local?.avatar_url} />
                        </div>

                        <div style={{ width: '45px', textAlign: 'center', fontWeight: 'bold', background: '#f8f9fa', borderRadius: '4px', padding: '2px 0' }}>
                          {p.is_played ? `${p.home_score}-${p.away_score}` : 'vs'}
                        </div>

                        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'flex-start', gap: '8px' }}>
                          <AvatarConZoom url={p.visitante?.avatar_url} />
                          <span style={{ fontWeight: esMiPartido ? 'bold' : 'normal' }}>{p.visitante?.nick || 'TBD'}</span>
                        </div>

                        <div style={{ width: '20px', textAlign: 'center' }}>
                          {p.stream_url && (
                            <a href={p.stream_url} target="_blank" rel="noreferrer" style={{ textDecoration: 'none' }}>📺</a>
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>
              );
            })}
          </div>
        );
      })}
    </div>
  );
}