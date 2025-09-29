'use client'

import { useState, useEffect, useCallback } from 'react'
import { supabase } from '@/lib/supabase'

interface SlotMachineProps {
  userId?: string
}

const SYMBOLS = ['🍒', '🍋', '🍊', '🍇', '⭐', '💎', '🔔', '💰']
const REELS = 3

export default function SlotMachine({ userId }: SlotMachineProps) {
  const [reels, setReels] = useState<string[]>(Array(REELS).fill('🍒'))
  const [isSpinning, setIsSpinning] = useState(false)
  const [score, setScore] = useState(0)
  const [totalScore, setTotalScore] = useState(0)
  const [spins, setSpins] = useState(0)
  const [credits, setCredits] = useState(100)

  const getRandomSymbol = () => SYMBOLS[Math.floor(Math.random() * SYMBOLS.length)]

  const calculateWin = (reels: string[]) => {
    // Check for winning combinations
    if (reels[0] === reels[1] && reels[1] === reels[2]) {
      // Triple match
      const symbol = reels[0]
      switch (symbol) {
        case '💰': return 100
        case '💎': return 75
        case '⭐': return 50
        case '🔔': return 25
        case '🍇': return 20
        case '🍊': return 15
        case '🍋': return 10
        case '🍒': return 5
        default: return 10
      }
    } else if (reels[0] === reels[1] || reels[1] === reels[2] || reels[0] === reels[2]) {
      // Double match
      return 2
    }
    return 0
  }

  const logGameEvent = async (eventType: 'play_start' | 'play_end' | 'jackpot', metadata?: any) => {
    if (!userId) return

    try {
      await supabase.from('game_events').insert({
        user_id: userId,
        game_id: 'slot-machine-1',
        event_type: eventType,
        metadata: metadata || {}
      })
    } catch (error) {
      console.error('Error logging game event:', error)
    }
  }

  const saveScore = async (newScore: number) => {
    if (!userId) return

    try {
      await supabase.from('scores').insert({
        game_id: 1, // Assuming slot machine has game_id 1
        user_id: userId,
        score: newScore,
        is_public: true,
        tenant_id: '00000000-0000-0000-0000-000000000000' // Default tenant
      })
    } catch (error) {
      console.error('Error saving score:', error)
    }
  }

  const spin = useCallback(async () => {
    if (isSpinning || credits <= 0) return

    setIsSpinning(true)
    setCredits(prev => prev - 1)
    setSpins(prev => prev + 1)

    // Log play start
    await logGameEvent('play_start', { spins, credits })

    // Simulate spinning animation
    const spinDuration = 2000
    const intervals: NodeJS.Timeout[] = []

    // Start spinning each reel
    for (let i = 0; i < REELS; i++) {
      const interval = setInterval(() => {
        setReels(prev => {
          const newReels = [...prev]
          newReels[i] = getRandomSymbol()
          return newReels
        })
      }, 100)
      intervals.push(interval)

      // Stop spinning this reel after a delay
      setTimeout(() => {
        clearInterval(interval)
        if (i === REELS - 1) {
          // All reels stopped, calculate result
          setTimeout(() => {
            const finalReels = Array(REELS).fill(0).map(() => getRandomSymbol())
            setReels(finalReels)
            
            const winAmount = calculateWin(finalReels)
            if (winAmount > 0) {
              setScore(winAmount)
              setTotalScore(prev => {
                const newTotal = prev + winAmount
                if (winAmount >= 50) {
                  logGameEvent('jackpot', { winAmount, finalReels })
                }
                saveScore(newTotal)
                return newTotal
              })
              setCredits(prev => prev + winAmount)
            } else {
              setScore(0)
            }

            // Log play end
            logGameEvent('play_end', { winAmount, finalReels, totalScore })
            setIsSpinning(false)
          }, 500)
        }
      }, spinDuration + (i * 200))
    }
  }, [isSpinning, credits, spins, totalScore, userId])

  const resetGame = () => {
    setScore(0)
    setTotalScore(0)
    setSpins(0)
    setCredits(100)
    setReels(Array(REELS).fill('🍒'))
  }

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gradient-to-br from-purple-900 to-blue-900 text-white p-4">
      <div className="bg-gray-800 rounded-lg p-8 shadow-2xl border border-yellow-400">
        <h1 className="text-4xl font-bold text-center mb-6 text-yellow-400">🎰 Slot Machine 🎰</h1>
        
        <div className="flex justify-between mb-6">
          <div className="text-center">
            <div className="text-yellow-400 font-bold">Credits</div>
            <div className="text-2xl">{credits}</div>
          </div>
          <div className="text-center">
            <div className="text-yellow-400 font-bold">Total Score</div>
            <div className="text-2xl">{totalScore}</div>
          </div>
          <div className="text-center">
            <div className="text-yellow-400 font-bold">Spins</div>
            <div className="text-2xl">{spins}</div>
          </div>
        </div>

        <div className="flex justify-center mb-6">
          <div className="flex space-x-4 bg-black p-6 rounded-lg border-4 border-yellow-400">
            {reels.map((symbol, index) => (
              <div
                key={index}
                className={`text-6xl w-20 h-20 flex items-center justify-center bg-white text-black rounded-lg border-2 border-gray-400 ${
                  isSpinning ? 'animate-pulse' : ''
                }`}
              >
                {symbol}
              </div>
            ))}
          </div>
        </div>

        {score > 0 && (
          <div className="text-center mb-4">
            <div className="text-2xl font-bold text-green-400 animate-bounce">
              🎉 You Won {score} Credits! 🎉
            </div>
          </div>
        )}

        <div className="flex justify-center space-x-4">
          <button
            onClick={spin}
            disabled={isSpinning || credits <= 0}
            className={`px-8 py-4 rounded-lg font-bold text-xl transition-colors ${
              isSpinning || credits <= 0
                ? 'bg-gray-600 cursor-not-allowed'
                : 'bg-red-600 hover:bg-red-700 text-white'
            }`}
          >
            {isSpinning ? '🎰 Spinning...' : '🎰 SPIN!'}
          </button>
          
          <button
            onClick={resetGame}
            className="px-8 py-4 bg-blue-600 hover:bg-blue-700 rounded-lg font-bold text-xl text-white transition-colors"
          >
            🔄 Reset
          </button>
        </div>

        {credits <= 0 && (
          <div className="text-center mt-4">
            <div className="text-red-400 font-bold">
              No more credits! Press Reset to play again.
            </div>
          </div>
        )}
      </div>

      <div className="mt-8 text-center text-sm opacity-75">
        <p>Win conditions:</p>
        <p>💰💰💰 = 100 | 💎💎💎 = 75 | ⭐⭐⭐ = 50 | 🔔🔔🔔 = 25</p>
        <p>🍇🍇🍇 = 20 | 🍊🍊🍊 = 15 | 🍋🍋🍋 = 10 | 🍒🍒🍒 = 5</p>
        <p>Any two matching = 2 credits</p>
      </div>
    </div>
  )
}