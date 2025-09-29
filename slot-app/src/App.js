

import './App.css';
import { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';
import { games } from './games';

const slotSymbols = ['🍒', '🍋', '🔔', '⭐', '🍀', '💎'];

function getRandomSymbols() {
  return [
    slotSymbols[Math.floor(Math.random() * slotSymbols.length)],
    slotSymbols[Math.floor(Math.random() * slotSymbols.length)],
    slotSymbols[Math.floor(Math.random() * slotSymbols.length)]
  ];
}

function calculateWin(symbols) {
  // Simple win logic: all symbols match
  return symbols[0] === symbols[1] && symbols[1] === symbols[2];
}

function App() {
  const [symbols, setSymbols] = useState(getRandomSymbols());
  const [message, setMessage] = useState('');
  const [score, setScore] = useState(0);
  const [spinning, setSpinning] = useState(false);
  const [user, setUser] = useState(null);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [leaderboard, setLeaderboard] = useState([]);
  const [selectedGame, setSelectedGame] = useState(null);

  useEffect(() => {
    // Check for logged in user
    const session = supabase.auth.getSession();
    session.then(({ data }) => {
      if (data && data.session && data.session.user) {
        setUser(data.session.user);
      }
    });
    // Fetch leaderboard
    fetchLeaderboard();
  }, []);

  const fetchLeaderboard = async () => {
    const { data, error } = await supabase
      .from('scores')
      .select('score, user_id')
      .order('score', { ascending: false })
      .limit(10);
    if (!error && data) {
      setLeaderboard(data);
    }
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (data && data.user) {
      setUser(data.user);
      setMessage('Logged in!');
    } else {
      setMessage(error?.message || 'Login failed');
    }
  };

  const handleSignup = async (e) => {
    e.preventDefault();
    const { data, error } = await supabase.auth.signUp({ email, password });
    if (data && data.user) {
      setUser(data.user);
      setMessage('Signed up!');
    } else {
      setMessage(error?.message || 'Signup failed');
    }
  };

  const handleLogout = async () => {
    await supabase.auth.signOut();
    setUser(null);
    setMessage('Logged out');
  };

  const handleGameSelect = (game) => {
    setSelectedGame(game);
    setMessage(`Selected: ${game.name}`);
  };

  const spin = async () => {
    setSpinning(true);
    const newSymbols = getRandomSymbols();
    setSymbols(newSymbols);
    const win = calculateWin(newSymbols);
    if (win) {
      setMessage('You win! 🎉');
      setScore(score + 1);
      // Save score to Supabase
      if (user) {
        await supabase.from('scores').insert([
          {
            score: score + 1,
            achieved_at: new Date().toISOString(),
            is_public: true,
            user_id: user.id
          }
        ]);
        fetchLeaderboard();
      }
    } else {
      setMessage('Try again!');
    }
    setSpinning(false);
  };

  return (
    <div className="App">
      <h1>Slot Game</h1>
      <h2>Available Games</h2>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: '1rem', marginBottom: '2rem' }}>
        {games.map((game, idx) => (
          <div 
            key={idx} 
            style={{ 
              textAlign: 'center', 
              width: '120px', 
              cursor: 'pointer',
              border: selectedGame?.name === game.name ? '3px solid #4CAF50' : '1px solid #ddd',
              borderRadius: '8px',
              padding: '0.5rem'
            }}
            onClick={() => handleGameSelect(game)}
          >
            <img src={game.image} alt={game.name} style={{ width: '100px', height: '100px', objectFit: 'cover', background: '#eee', borderRadius: '8px' }} />
            <div style={{ marginTop: '0.5rem', fontWeight: 'bold' }}>{game.name}</div>
          </div>
        ))}
      </div>
      {selectedGame && (
        <div style={{ marginBottom: '2rem', textAlign: 'center' }}>
          <h3>Now Playing: {selectedGame.name}</h3>
          <img src={selectedGame.image} alt={selectedGame.name} style={{ width: '80px', height: '80px', objectFit: 'cover', borderRadius: '8px' }} />
        </div>
      )}
      {!user ? (
        <div style={{ marginBottom: '2rem' }}>
          <form onSubmit={handleLogin} style={{ marginBottom: '1rem' }}>
            <input
              type="email"
              placeholder="Email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              required
              style={{ marginRight: '0.5rem' }}
            />
            <input
              type="password"
              placeholder="Password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              required
              style={{ marginRight: '0.5rem' }}
            />
            <button type="submit">Login</button>
          </form>
          <form onSubmit={handleSignup}>
            <input
              type="email"
              placeholder="Email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              required
              style={{ marginRight: '0.5rem' }}
            />
            <input
              type="password"
              placeholder="Password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              required
              style={{ marginRight: '0.5rem' }}
            />
            <button type="submit">Sign Up</button>
          </form>
        </div>
      ) : (
        <div style={{ marginBottom: '1rem' }}>
          <span>Logged in as: {user.email}</span>
          <button onClick={handleLogout} style={{ marginLeft: '1rem' }}>Logout</button>
        </div>
      )}
      <div style={{ fontSize: '3rem', margin: '1rem' }}>
        {symbols.join(' ')}
      </div>
      <button onClick={spin} disabled={spinning || !user} style={{ fontSize: '1.5rem', padding: '0.5rem 2rem' }}>
        {spinning ? 'Spinning...' : 'Spin'}
      </button>
      <div style={{ margin: '1rem', fontSize: '1.2rem' }}>{message}</div>
      <div>Score: {score}</div>
      <h2>Leaderboard</h2>
      <ol>
        {leaderboard.map((entry, idx) => (
          <li key={idx}>
            User: {entry.user_id?.slice(0, 8) || 'N/A'} - Score: {entry.score}
          </li>
        ))}
      </ol>
    </div>
  );
}

export default App;
