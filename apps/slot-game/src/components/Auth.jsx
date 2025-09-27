import { useState } from 'react'
import { supabase } from '../supabaseClient'
import './Auth.css'

const Auth = () => {
  const [loading, setLoading] = useState(false)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [isSignUp, setIsSignUp] = useState(false)
  const [message, setMessage] = useState('')

  const handleAuth = async (e) => {
    e.preventDefault()
    setLoading(true)
    setMessage('')

    try {
      let result
      if (isSignUp) {
        result = await supabase.auth.signUp({
          email,
          password,
        })
        if (result.error) throw result.error
        setMessage('Check your email for the confirmation link!')
      } else {
        result = await supabase.auth.signInWithPassword({
          email,
          password,
        })
        if (result.error) throw result.error
      }
    } catch (error) {
      setMessage(error.message)
    } finally {
      setLoading(false)
    }
  }

  const handleDemoLogin = async () => {
    setLoading(true)
    setMessage('')
    
    // For demo purposes, create a demo user session
    setEmail('demo@slotgame.com')
    setMessage('Demo mode - you can play without authentication!')
    
    // Simulate login success after a short delay
    setTimeout(() => {
      setLoading(false)
      // In a real app, you'd set user session here
      window.dispatchEvent(new CustomEvent('demo-login', { 
        detail: { 
          user: { 
            id: 'demo-user', 
            email: 'demo@slotgame.com' 
          }
        }
      }))
    }, 1000)
  }

  return (
    <div className="auth-container">
      <div className="auth-card">
        <div className="auth-header">
          <h1>🎰 Slot Game</h1>
          <p>Welcome to the ultimate slot machine experience!</p>
        </div>

        <form onSubmit={handleAuth} className="auth-form">
          <div className="form-group">
            <label htmlFor="email">Email</label>
            <input
              id="email"
              type="email"
              placeholder="Enter your email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="password">Password</label>
            <input
              id="password"
              type="password"
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>

          <button type="submit" className="auth-button" disabled={loading}>
            {loading ? 'Loading...' : (isSignUp ? 'Sign Up' : 'Sign In')}
          </button>

          <button 
            type="button" 
            className="demo-button"
            onClick={handleDemoLogin}
            disabled={loading}
          >
            🎮 Play Demo
          </button>

          <button
            type="button"
            className="toggle-auth"
            onClick={() => setIsSignUp(!isSignUp)}
          >
            {isSignUp 
              ? 'Already have an account? Sign In' 
              : 'Need an account? Sign Up'
            }
          </button>

          {message && (
            <div className={`message ${message.includes('error') || message.includes('Error') ? 'error' : 'success'}`}>
              {message}
            </div>
          )}
        </form>
      </div>
    </div>
  )
}

export default Auth
