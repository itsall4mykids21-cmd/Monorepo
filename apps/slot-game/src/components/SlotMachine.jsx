import { useState, useEffect } from 'react'
import './SlotMachine.css'

const SYMBOLS = ['🍒', '🍋', '🍊', '🍇', '⭐', '💎', '🔔', '💰']

const SlotMachine = ({ onSpin, credits, isSpinning, onWin }) => {
  const [reels, setReels] = useState([
    ['🍒', '🍋', '🍊'],
    ['🍇', '⭐', '💎'], 
    ['🔔', '💰', '🍒']
  ])
  const [spinning, setSpinning] = useState(false)

  useEffect(() => {
    setSpinning(isSpinning)
  }, [isSpinning])

  const spinReels = () => {
    if (spinning || credits < 10) return
    
    setSpinning(true)
    onSpin()

    // Animate the spinning
    const spinDuration = 2000 + Math.random() * 1000 // 2-3 seconds
    const interval = setInterval(() => {
      setReels(reels => reels.map(reel => 
        reel.map(() => SYMBOLS[Math.floor(Math.random() * SYMBOLS.length)])
      ))
    }, 100)

    setTimeout(() => {
      clearInterval(interval)
      // Generate final result
      const finalReels = Array(3).fill().map(() => 
        Array(3).fill().map(() => SYMBOLS[Math.floor(Math.random() * SYMBOLS.length)])
      )
      setReels(finalReels)
      
      // Check for wins
      const middleRow = finalReels.map(reel => reel[1])
      const isWin = middleRow[0] === middleRow[1] && middleRow[1] === middleRow[2]
      
      if (isWin) {
        const winAmount = getWinAmount(middleRow[0])
        onWin(winAmount)
      }
      
      setSpinning(false)
    }, spinDuration)
  }

  const getWinAmount = (symbol) => {
    const winAmounts = {
      '💰': 1000,
      '💎': 500,
      '⭐': 300,
      '🔔': 200,
      '🍇': 150,
      '🍊': 100,
      '🍋': 75,
      '🍒': 50
    }
    return winAmounts[symbol] || 50
  }

  return (
    <div className="slot-machine">
      <div className="slot-display">
        {reels.map((reel, reelIndex) => (
          <div key={reelIndex} className={`reel ${spinning ? 'spinning' : ''}`}>
            {reel.map((symbol, symbolIndex) => (
              <div key={symbolIndex} className="symbol">
                {symbol}
              </div>
            ))}
          </div>
        ))}
      </div>
      
      <div className="payline"></div>
      
      <div className="controls">
        <button 
          className={`spin-button ${spinning ? 'disabled' : ''}`}
          onClick={spinReels}
          disabled={spinning || credits < 10}
        >
          {spinning ? 'SPINNING...' : 'SPIN (10 credits)'}
        </button>
      </div>
      
      <div className="paytable">
        <h3>Paytable (3 in a row)</h3>
        <div className="payouts">
          {Object.entries({
            '💰': 1000,
            '💎': 500,
            '⭐': 300,
            '🔔': 200,
            '🍇': 150,
            '🍊': 100,
            '🍋': 75,
            '🍒': 50
          }).map(([symbol, payout]) => (
            <div key={symbol} className="payout-line">
              <span>{symbol}{symbol}{symbol}</span>
              <span>{payout} credits</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}

export default SlotMachine
