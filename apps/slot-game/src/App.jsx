import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import Auth from './components/Auth'
import UserProfile from './components/UserProfile'
import SlotMachine from './components/SlotMachine'
import './App.css'

function App() {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)
  const [credits, setCredits] = useState(1000)
  const [isSpinning, setIsSpinning] = useState(false)
  const [message, setMessage] = useState('')

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null)
      setLoading(false)
    })

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null)
    })

    // Listen for demo login
    const handleDemoLogin = (event) => {
      setUser(event.detail.user)
      setLoading(false)
    }
    
    window.addEventListener('demo-login', handleDemoLogin)

    return () => {
      subscription.unsubscribe()
      window.removeEventListener('demo-login', handleDemoLogin)
    }
  }, [])

  const handleSpin = () => {
    if (credits < 10) {
      setMessage('Not enough credits! Add more credits to play.')
      return
    }
    
    setIsSpinning(true)
    setCredits(credits - 10) // Deduct spin cost
    setMessage('')
    
    // Log game event to Supabase (if connected)
    if (user && user.id !== 'demo-user') {
      logGameEvent('play_start')
    }
  }

  const handleWin = (winAmount) => {
    setCredits(credits + winAmount)
    setMessage(`🎉 Congratulations! You won ${winAmount} credits!`)
    
    // Log win event to Supabase (if connected)
    if (user && user.id !== 'demo-user') {
      logGameEvent('jackpot', { winAmount })
    }
    
    // Clear message after 5 seconds
    setTimeout(() => setMessage(''), 5000)
  }

  const logGameEvent = async (eventType, metadata = {}) => {
    try {
      await supabase
        .from('game_events')
        .insert([
          {
            user_id: user.id,
            game_id: 'slot-machine-1',
            event_type: eventType,
            metadata
          }
        ])
    } catch (error) {
      console.error('Error logging game event:', error)
    }
  }

  const handleSignOut = async () => {
    if (user.id === 'demo-user') {
      setUser(null)
      return
    }
    
    const { error } = await supabase.auth.signOut()
    if (error) console.error('Error signing out:', error)
  }

  if (loading) {
    return (
      <div className="loading-screen">
        <div className="loading-spinner">🎰</div>
        <p>Loading Slot Game...</p>
      </div>
    )
  }

  if (!user) {
    return <Auth />
  }

  return (
    <div className="app">
      <header className="app-header">
        <h1>🎰 Slot Game</h1>
        <button onClick={handleSignOut} className="sign-out-btn">
          Sign Out
        </button>
      </header>

      <div className="game-container">
        <UserProfile 
          user={user} 
          credits={credits} 
          onCreditsChange={setCredits} 
        />
        
        {message && (
          <div className={`game-message ${message.includes('won') ? 'win' : 'info'}`}>
            {message}
          </div>
        )}
        
        <SlotMachine 
          onSpin={handleSpin}
          credits={credits}
          isSpinning={isSpinning}
          onWin={handleWin}
        />
      </div>
    </div>
  )
}

export default App
