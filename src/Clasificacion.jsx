import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'

// --- COMPONENTE AVATAR REUTILIZADO ---
const Avatar = ({ url, size = '30px' }) => (
  <div style={{
    width: size, height: size, borderRadius: '50%', overflow: 'hidden',
    background: '#34495e', border: '2px solid #2ecc71', flexShrink: 0
  }}>
    {url ? (
      <img src={url} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
    ) : (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100%', fontSize: '0.7rem', color: '#7f8c8d' }}>👤</div>
    )}
  </div>
);

// --- SELECTORES ---
function CategorySelector({ current, onChange, season }) {
  const [categories, setCategories] = useState([])
  useEffect(() => {
    async function load() {
      if (!season) return;
      const { data: divData } = await supabase.from('matches').select('division').eq('season', season)
      const uniqueDivs = divData ? [...new Set(divData.map(d => d.division))].sort((a, b) => a - b) : []
      const { data: poData } = await supabase.from('playoffs').select('id, name').eq('season', season)
      const formattedPlayoffs = poData ? poData.map(p => ({ id: p.id, label: p.name.toUpperCase(), type: 'po' })) : []
      const all = [...uniqueDivs.map(d => ({ id: d, label: `DIV ${d}`, type: 'div' })), ...formattedPlayoffs]
      setCategories(all)
      if (all.length > 0 && !all.find(c => c.id === current)) onChange(all[0].id)
    }
    load()
  }, [season])

  return (
    <div style={{ display: 'flex', gap: '5px', marginBottom: '15px', flexWrap: 'wrap' }}>
      {categories.map(cat => (
        <button key={cat.id} onClick={() => onChange(cat.id)} style={{
          padding: '6px 12px', borderRadius: '15px', border: 'none',
          background: current === cat.id ? (cat.type === 'div' ? '#2ecc71' : '#34495e') : '#ecf0f1',
          color: current === cat.id ? 'white' : '#7f8c8d', 
          fontSize: '0.7rem', fontWeight: 'bold', cursor: 'pointer'
        }}> {cat.label} </button>
      ))}
    </div>
  )
}

function SeasonSelector({ current, onChange }) {
  const [seasons, setSeasons] = useState([])
  useEffect(() => {
    async function load() {
      const { data } = await supabase.from('matches').select('season')
      if (data) setSeasons([...new Set(data.map(d => d.season))].sort((a, b) => b - a))
    }
    load()
  }, [])
  return (
    <select value={current || ''} onChange={(e) => onChange(parseInt(e.target.value))} 
      style={{ padding: '4px', borderRadius: '4px', fontSize: '0.8rem', border: '1px solid #ddd' }}>
      {seasons.map(s => <option key={s} value={s}>Temporada {s}</option>)}
    </select>
  )
}

// --- COMPONENTE PRINCIPAL ---
export default function Clasificacion({ config }) {
  const [vS, setVS] = useState(config?.current_season);
  const [vD, setVD] = useState(1);
  const [lista, setLista] = useState([]);
  const [playoffMatches, setPlayoffMatches] = useState([]);

  const esPlayoff = typeof vD === 'string';

  useEffect(() => {
    async function fetch() {
      if (!esPlayoff) {
        const { data } = await supabase.from('clasificacion').select('*').eq('season', vS).eq('division', vD).order('pts', { ascending: false });
        setLista(data || [])
      } else {
        const { data } = await supabase.from('playoff_matches_detallados').select('*').eq('playoff_id', vD).order('start_date', { ascending: true });
        setPlayoffMatches(data || [])
      }
    }
    if (vS) fetch();
  }, [vS, vD, esPlayoff]);

  const renderPlayoffBrackets = () => {
    const getBaseRound = (r) => r ? r.replace(/\(.*\)/g, '').replace(/Ida|Vuelta|IDA|VUELTA/gi, '').trim() : "OTRA";
    const ordenRondas = ["OCTAVOS", "CUARTOS", "SEMIFINALES", "FINAL", "TERCER Y CUARTO PUESTO"];
    const rondasDetectadas = [...new Set(playoffMatches.map(m => getBaseRound(m.round)))];
    const rondasUnicas = rondasDetectadas.sort((a, b) => ordenRondas.indexOf(a.toUpperCase()) - ordenRondas.indexOf(b.toUpperCase()));

    const bracketData = {};

    rondasUnicas.forEach((baseRound, roundIdx) => {
      const matchesInRound = playoffMatches.filter(m => getBaseRound(m.round) === baseRound);
      const enfrentamientos = [];
      const idsProcesados = new Set();

      matchesInRound.forEach(m => {
        if (idsProcesados.has(m.id)) return;
        const n1 = m.local_nick?.trim().toLowerCase() || 'tbd';
        const n2 = m.visitante_nick?.trim().toLowerCase() || 'tbd';
        const pairKey = [n1, n2].sort().join(' vs ');

        const pareja = matchesInRound.filter(pm => {
          if (idsProcesados.has(pm.id)) return false;
          const pn1 = pm.local_nick?.trim().toLowerCase() || 'tbd';
          const pn2 = pm.visitante_nick?.trim().toLowerCase() || 'tbd';
          const pmKey = [pn1, pn2].sort().join(' vs ');
          const compartenNombres = (n1 !== 'tbd' && (n1 === pn1 || n1 === pn2)) || (n2 !== 'tbd' && (n2 === pn1 || n2 === pn2));
          return pmKey === pairKey || (pairKey.includes('tbd') && compartenNombres);
        });

        pareja.sort((a, b) => (a.round.toLowerCase().includes('ida') || a.round.toLowerCase().includes('1')) ? -1 : 1);
        enfrentamientos.push(pareja);
        pareja.forEach(p => idsProcesados.add(p.id));
      });

      if (roundIdx > 0) {
        const prevRoundKey = rondasUnicas[roundIdx - 1];
        const prevEnfrentamientos = bracketData[prevRoundKey];
        enfrentamientos.sort((a, b) => {
          const getMatchPos = (match) => {
            const players = [match[0].local_nick?.toLowerCase(), match[0].visitante_nick?.toLowerCase()].filter(p => p && p !== 'tbd');
            return prevEnfrentamientos.findIndex(prev => 
              players.some(p => prev[0].local_nick?.toLowerCase() === p || prev[0].visitante_nick?.toLowerCase() === p)
            );
          };
          return getMatchPos(a) - getMatchPos(b);
        });
      }
      bracketData[baseRound] = enfrentamientos;
    });

    return (
      <div style={{ display: 'flex', gap: '40px', overflowX: 'auto', padding: '40px 20px', minHeight: '600px', alignItems: 'stretch' }}>
        {rondasUnicas.map((baseRound, roundIdx) => (
          <div key={baseRound} style={{ display: 'flex', flexDirection: 'column', width: '250px', flexShrink: 0 }}>
            <h4 style={{ fontSize: '0.65rem', color: '#64748b', textAlign: 'center', marginBottom: '25px', textTransform: 'uppercase', letterSpacing: '1.5px', fontWeight: '900' }}>
              {baseRound}
            </h4>
            
            <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'space-around', flexGrow: 1 }}>
              {bracketData[baseRound].map((pair, idx) => {
                const m1 = pair[0];
                const m2 = pair[1];

                const checkPlayed = (m) => m && (m.played === true || m.played === 'true' || m.is_played === true || m.home_score !== null);
                
                // Lógica de TBD solo para la PRIMERA ronda mostrada
                const isLocalTBD = !m1.local_nick || m1.local_nick.toLowerCase() === 'tbd';
                const isVisitanteTBD = !m1.visitante_nick || m1.visitante_nick.toLowerCase() === 'tbd';
                const isFirstRound = roundIdx === 0;
                
                // Si es primera fase y hay un TBD, se da por terminado como BYE
                const isBye = isFirstRound && (isLocalTBD || isVisitanteTBD);
                
                const isFinished = isBye || (m2 ? (checkPlayed(m1) && checkPlayed(m2)) : checkPlayed(m1));

                let gL = m1.home_score || 0;
                let gV = m1.away_score || 0;
                if (m2) {
                  if (m2.local_nick === m1.local_nick) {
                    gL += (m2.home_score || 0); gV += (m2.away_score || 0);
                  } else {
                    gL += (m2.away_score || 0); gV += (m2.home_score || 0);
                  }
                }

                // Determinar ganador (si es BYE, gana el que no es TBD)
                const winL = isFinished && ( (isBye && !isLocalTBD) || (!isBye && gL > gV) );
                const winV = isFinished && ( (isBye && !isVisitanteTBD) || (!isBye && gV > gL) );

                return (
                  <div key={idx} style={{ position: 'relative', margin: '15px 0' }}>
                    {isFinished && (
                      <div style={{
                        position: 'absolute', top: '-8px', right: '-8px', 
                        background: '#2ecc71', color: 'white', borderRadius: '50%', 
                        width: '20px', height: '20px', display: 'flex', 
                        alignItems: 'center', justifyContent: 'center', 
                        fontSize: '10px', zIndex: 10, boxShadow: '0 2px 4px rgba(0,0,0,0.2)',
                        border: '2px solid #fff'
                      }}>
                        ✓
                      </div>
                    )}

                    <div style={{ 
                      background: isFinished ? '#f0f9ff' : '#fff', 
                      border: isFinished ? '1.5px solid #7dd3fc' : '1px solid #e2e8f0', 
                      borderRadius: '12px', 
                      padding: '12px', 
                      boxShadow: isFinished ? '0 4px 12px -2px rgba(14, 165, 233, 0.15)' : '0 4px 6px -1px rgba(0,0,0,0.05)', 
                      borderLeft: isFinished ? '5px solid #0ea5e9' : '4px solid #34495e',
                      transition: 'all 0.3s ease'
                    }}>
                      
                      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px', marginBottom: '12px' }}>
                        {/* LOCAL */}
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flex: 1, minWidth: 0 }}>
                          <Avatar url={m1.local_avatar} size="28px" />
                          <span style={{ 
                            fontSize: winL ? '0.8rem' : '0.75rem', 
                            fontWeight: winL ? '900' : '800', 
                            color: winL ? '#10b981' : (isFinished ? '#0369a1' : '#1e293b'), 
                            overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
                            textDecoration: winL ? 'underline' : 'none'
                          }}>
                            {m1.local_nick || 'TBD'}
                          </span>
                        </div>
                        
                        {/* VISITANTE */}
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flex: 1, minWidth: 0, flexDirection: 'row-reverse' }}>
                          <Avatar url={m1.visitante_avatar} size="28px" />
                          <span style={{ 
                            fontSize: winV ? '0.8rem' : '0.75rem', 
                            fontWeight: winV ? '900' : '800', 
                            color: winV ? '#10b981' : (isFinished ? '#0369a1' : '#1e293b'), 
                            overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', textAlign: 'right',
                            textDecoration: winV ? 'underline' : 'none'
                          }}>
                            {m1.visitante_nick || 'TBD'}
                          </span>
                        </div>
                      </div>

                      <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '12px' }}>
                        <div style={{ height: '1px', background: isFinished ? '#bae6fd' : '#f1f5f9', flex: 1 }}></div>
                        <span style={{ 
                          fontSize: '0.65rem', 
                          fontWeight: '900', 
                          color: '#fff', 
                          background: isFinished ? '#0ea5e9' : '#334155', 
                          padding: '3px 10px', 
                          borderRadius: '6px' 
                        }}>
                          {isBye ? 'PASO DIRECTO' : `GLB: ${gL} - ${gV}`}
                        </span>
                        <div style={{ height: '1px', background: isFinished ? '#bae6fd' : '#f1f5f9', flex: 1 }}></div>
                      </div>
                      
                      <div style={{ display: 'flex', gap: '8px' }}>
                        <div style={{ 
                          flex: 1, textAlign: 'center', 
                          background: isFinished ? '#e0f2fe' : '#f8fafc', 
                          borderRadius: '8px', padding: '6px 0', 
                          border: isFinished ? '1px solid #bae6fd' : '1px solid #f1f5f9' 
                        }}>
                          <span style={{ display: 'block', fontSize: '0.5rem', color: isFinished ? '#0369a1' : '#94a3b8', fontWeight: '800' }}>{m2 ? 'IDA' : 'FINAL'}</span>
                          <span style={{ fontSize: '1rem', fontWeight: '900', color: isFinished ? '#0c4a6e' : '#1e293b' }}>{isBye ? '-' : (m1.home_score ?? '-')} : {isBye ? '-' : (m1.away_score ?? '-')}</span>
                        </div>
                        {m2 && (
                          <div style={{ 
                            flex: 1, textAlign: 'center', 
                            background: isFinished ? '#e0f2fe' : '#f8fafc', 
                            borderRadius: '8px', padding: '6px 0', 
                            border: isFinished ? '1px solid #bae6fd' : '1px solid #f1f5f9' 
                          }}>
                            <span style={{ display: 'block', fontSize: '0.5rem', color: isFinished ? '#0369a1' : '#94a3b8', fontWeight: '800' }}>VTA</span>
                            <span style={{ fontSize: '1rem', fontWeight: '900', color: isFinished ? '#0c4a6e' : '#1e293b' }}>
                                {isBye ? '-' : (m2.local_nick === m1.local_nick ? (m2.home_score ?? '-') : (m2.away_score ?? '-'))}
                                :
                                {isBye ? '-' : (m2.visitante_nick === m1.visitante_nick ? (m2.away_score ?? '-') : (m2.home_score ?? '-'))}
                            </span>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        ))}
      </div>
    );
  };

  return (
    <div style={{ fontFamily: 'Inter, system-ui, sans-serif' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '15px' }}>
        <CategorySelector season={vS} current={vD} onChange={setVD} />
        <SeasonSelector current={vS} onChange={setVS} />
      </div>

      {!esPlayoff ? (
        <div style={{ background: '#fff', borderRadius: '12px', border: '1px solid #eee', overflowX: 'auto' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.75rem' }}>
            <thead>
              <tr style={{ background: '#f8f9fa', borderBottom: '2px solid #2ecc71' }}>
                <th style={{ padding: '12px', textAlign: 'left' }}>Jugador</th>
                <th>PTS</th><th>PJ</th><th>DG</th>
              </tr>
            </thead>
            <tbody>
              {lista.map((j, i) => (
                <tr key={i} style={{ borderBottom: '1px solid #f1f1f1', textAlign: 'center' }}>
                  <td style={{ padding: '10px', textAlign: 'left', fontWeight: 'bold', display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <Avatar url={j.img} size="24px" />
                    {j.nick}
                  </td>
                  <td style={{ fontWeight: 'bold', color: '#2ecc71' }}>{j.pts ?? 0}</td>
                  <td>{j.pj ?? 0}</td>
                  <td>{j.dg ?? 0}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <div style={{ background: '#f8fafc', borderRadius: '16px', border: '1px solid #e2e8f0', backgroundImage: 'radial-gradient(#e2e8f0 1px, transparent 1px)', backgroundSize: '20px 20px' }}>
          {renderPlayoffBrackets()}
        </div>
      )}
    </div>
  )
}