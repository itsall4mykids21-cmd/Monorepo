# 🎰 Slot Game

A modern, interactive slot machine game built with React and Supabase.

## Features

- **Interactive Slot Machine**: 3-reel slot machine with animated spinning
- **User Authentication**: Supabase Auth integration with demo mode
- **Credit System**: Virtual credits with purchase options
- **Real-time Database**: Game events and scores stored in Supabase
- **Responsive Design**: Works great on desktop and mobile
- **Modern UI**: Beautiful gradients and animations

## Game Symbols & Payouts

- 💰💰💰 - 1000 credits
- 💎💎💎 - 500 credits  
- ⭐⭐⭐ - 300 credits
- 🔔🔔🔔 - 200 credits
- 🍇🍇🍇 - 150 credits
- 🍊🍊🍊 - 100 credits
- 🍋🍋🍋 - 75 credits
- 🍒🍒🍒 - 50 credits

## Getting Started

### Prerequisites

- Node.js (v16 or higher)
- Supabase account (optional, demo mode available)

### Installation

1. Navigate to the slot game directory:
   ```bash
   cd apps/slot-game
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. (Optional) Set up Supabase:
   - Copy `.env.example` to `.env`
   - Fill in your Supabase URL and anon key
   - Run the database schema from the root `database-schema.sql`

4. Start the development server:
   ```bash
   npm run dev
   ```

5. Open your browser to `http://localhost:5173`

### Demo Mode

You can play the game without setting up Supabase by clicking the "🎮 Play Demo" button. This gives you access to all game features with local state management.

## Database Integration

The game integrates with the following Supabase tables:

- `profiles` - User profile information
- `game_events` - Game play tracking
- `scores` - High scores and leaderboards
- `wallets` - Credit/balance management

## Development

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint

### Project Structure

```
src/
├── components/
│   ├── Auth.jsx/css - Authentication component
│   ├── SlotMachine.jsx/css - Main game component
│   └── UserProfile.jsx/css - User profile & credits
├── supabaseClient.js - Supabase configuration
├── App.jsx - Main application
└── main.jsx - Entry point
```

## Technologies Used

- **React 19** - UI framework
- **Vite** - Build tool and dev server
- **Supabase** - Backend as a service
- **CSS3** - Styling with gradients and animations
- **ESLint** - Code linting

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is part of the larger monorepo and follows the same licensing terms.
