'use client'

import { useState } from 'react'
import Auth from '@/components/Auth'
import SlotMachine from '@/components/SlotMachine'
import type { User } from '@supabase/supabase-js'

export default function Home() {
  const [user, setUser] = useState<User | null>(null)
  const [showGame, setShowGame] = useState(false)

  const handleAuth = (user: User | null) => {
    setUser(user)
    setShowGame(true)
  }

  if (!showGame) {
    return <Auth onAuth={handleAuth} />
  }

  return <SlotMachine userId={user?.id} />
}