import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://placeholder.supabase.co'
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'placeholder-key'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Types for our database tables
export interface Profile {
  id: string
  username?: string
  display_name?: string
  avatar_url?: string
  created_at?: string
  updated_at?: string
}

export interface Game {
  id: number
  slug: string
  name: string
  provider: string
  rtp: number
  thumbnail?: string
  volatility?: 'low' | 'medium' | 'high' | 'extreme'
  image_url: string
  description?: string
}

export interface Score {
  id: number
  game_id: number
  user_id: string
  score: number
  achieved_at: string
  is_public: boolean
}

export interface GameEvent {
  id: number
  user_id: string
  game_id?: string
  event_type: 'play_start' | 'play_end' | 'jackpot' | 'bonus_trigger'
  metadata?: any
  created_at: string
}