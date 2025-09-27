import { useState, useEffect } from 'react'
import { supabase } from '../supabaseClient'
import './UserProfile.css'

const UserProfile = ({ user, credits, onCreditsChange }) => {
  const [profile, setProfile] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (user) {
      fetchProfile()
    }
  }, [user])

  const fetchProfile = async () => {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .single()

      if (error && error.code !== 'PGRST116') {
        console.error('Error fetching profile:', error)
      } else if (data) {
        setProfile(data)
      }
    } catch (error) {
      console.error('Error:', error)
    } finally {
      setLoading(false)
    }
  }

  const addCredits = (amount) => {
    onCreditsChange(credits + amount)
  }

  if (loading) {
    return <div className="user-profile loading">Loading profile...</div>
  }

  return (
    <div className="user-profile">
      <div className="profile-header">
        <div className="avatar">
          {profile?.avatar_url ? (
            <img src={profile.avatar_url} alt="Avatar" />
          ) : (
            <div className="default-avatar">
              {user?.email?.charAt(0).toUpperCase() || '?'}
            </div>
          )}
        </div>
        <div className="user-info">
          <h3>{profile?.display_name || profile?.username || 'Player'}</h3>
          <p>{user?.email}</p>
        </div>
      </div>
      
      <div className="credits-section">
        <div className="credits-display">
          <span className="credits-label">Credits:</span>
          <span className="credits-amount">{credits.toLocaleString()}</span>
        </div>
        
        <div className="credits-actions">
          <button onClick={() => addCredits(100)} className="add-credits-btn">
            +100 Credits
          </button>
          <button onClick={() => addCredits(500)} className="add-credits-btn">
            +500 Credits
          </button>
          <button onClick={() => addCredits(1000)} className="add-credits-btn">
            +1000 Credits
          </button>
        </div>
      </div>
    </div>
  )
}

export default UserProfile
