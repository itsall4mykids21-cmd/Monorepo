# 🎰 Slot Game Monorepo Setup Guide

This guide will help you set up and run the complete slot game application with Supabase integration.

## Quick Start

### Option 1: Run the Slot Game (Recommended)

```bash
# Make the script executable (if not already)
chmod +x run-slot-game.sh

# Start the slot game application
./run-slot-game.sh
```

The game will be available at: http://localhost:5173

### Option 2: Manual Setup

```bash
# Navigate to the slot game directory
cd apps/slot-game

# Install dependencies
npm install

# Start development server
npm run dev
```

## Features Implemented

### ✅ Core Game Features
- **Interactive 3-reel slot machine** with animated spinning
- **8 different symbols** with varying payout values
- **Credit system** with virtual currency
- **Real-time game mechanics** with win detection
- **Responsive design** for desktop and mobile

### ✅ User Experience
- **Authentication system** (Supabase Auth + Demo mode)
- **User profiles** with avatar and display name
- **Credit management** with purchase options
- **Beautiful UI** with gradient backgrounds and animations
- **Game feedback** with win notifications

### ✅ Backend Integration
- **Supabase database** integration
- **Game events logging** for analytics
- **User profile management**
- **Score tracking** system
- **Wallet/transaction** management

### ✅ Technical Implementation
- **React 19** with modern hooks
- **Vite** for fast development and building
- **CSS animations** for engaging gameplay
- **Error handling** and loading states
- **Mobile-responsive** design

## Game Mechanics

### Symbols & Payouts
- 💰💰💰 - 1000 credits (Jackpot!)
- 💎💎💎 - 500 credits
- ⭐⭐⭐ - 300 credits  
- 🔔🔔🔔 - 200 credits
- 🍇🍇🍇 - 150 credits
- 🍊🍊🍊 - 100 credits
- 🍋🍋🍋 - 75 credits
- 🍒🍒🍒 - 50 credits

### How to Play
1. **Login or use Demo mode** to start playing
2. **Add credits** using the credit buttons (100, 500, 1000)
3. **Click SPIN** to play (costs 10 credits per spin)
4. **Win by matching** 3 symbols in the middle row
5. **Collect winnings** automatically added to your balance

## Database Setup (Optional)

The game works in demo mode without Supabase, but for full functionality:

1. **Create a Supabase project** at https://supabase.com
2. **Run the database schema** from `database-schema.sql`
3. **Copy environment variables**:
   ```bash
   cp apps/slot-game/.env.example apps/slot-game/.env
   ```
4. **Fill in your Supabase credentials** in the `.env` file:
   ```
   VITE_SUPABASE_URL=https://your-project-ref.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-key
   ```

## Development Commands

```bash
# Start development server
npm run dev

# Build for production  
npm run build

# Preview production build
npm run preview

# Run linting
npm run lint
```

## Project Structure

```
apps/slot-game/
├── src/
│   ├── components/
│   │   ├── Auth.jsx/css          # Authentication UI
│   │   ├── SlotMachine.jsx/css   # Main game component
│   │   └── UserProfile.jsx/css   # User profile & credits
│   ├── supabaseClient.js         # Database configuration
│   ├── App.jsx                   # Main application
│   └── main.jsx                  # Entry point
├── public/                       # Static assets
├── .env.example                  # Environment template
├── package.json                  # Dependencies & scripts
└── README.md                     # Detailed documentation
```

## Screenshots

### Authentication Screen
Clean, modern login interface with demo mode option.

### Game Interface  
Beautiful slot machine with animated reels, credit display, and paytable.

### Gameplay
Real-time spinning animation with credit deduction and win detection.

## Technologies Used

- **Frontend**: React 19, Vite, CSS3
- **Backend**: Supabase (PostgreSQL, Auth, Real-time)
- **Styling**: Custom CSS with gradients and animations
- **Build**: Vite with ESLint
- **Database**: PostgreSQL with comprehensive gaming schema

## Troubleshooting

### Common Issues

1. **Port 5173 already in use**
   ```bash
   # Kill the process using the port
   lsof -ti:5173 | xargs kill -9
   ```

2. **Dependencies not installing**
   ```bash
   # Clear npm cache and reinstall
   npm cache clean --force
   rm -rf node_modules package-lock.json
   npm install
   ```

3. **Supabase connection errors**
   - Check your `.env` file has correct credentials
   - Verify your Supabase project is active
   - Use demo mode for testing without Supabase

### Getting Help

- Check the detailed README in `apps/slot-game/README.md`
- Review the database schema in `database-schema.sql`
- Use demo mode to test without backend setup

## Next Steps

The slot game is fully functional with:
- ✅ Complete gameplay mechanics
- ✅ User authentication  
- ✅ Credit management
- ✅ Database integration
- ✅ Responsive design
- ✅ Production-ready build

Ready to play! 🎰