# 🎰 Slot Game App

A modern slot machine game built with Next.js, React, TypeScript, and Supabase.

## Features

- 🎰 Interactive slot machine with 3 reels
- 🎨 Beautiful UI with animations and visual effects
- 🏆 Score tracking and high scores
- 👤 User authentication with Supabase Auth
- 📊 Game events logging to Supabase database
- 🎮 Guest play mode (no authentication required)
- 📱 Responsive design

## Game Rules

- Start with 100 credits
- Each spin costs 1 credit
- Win combinations:
  - 💰💰💰 = 100 credits
  - 💎💎💎 = 75 credits
  - ⭐⭐⭐ = 50 credits
  - 🔔🔔🔔 = 25 credits
  - 🍇🍇🍇 = 20 credits
  - 🍊🍊🍊 = 15 credits
  - 🍋🍋🍋 = 10 credits
  - 🍒🍒🍒 = 5 credits
  - Any two matching symbols = 2 credits

## Setup Instructions

### 1. Install Dependencies

```bash
cd apps/slot-game-app
npm install
```

### 2. Set up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Run the database schema from `../../database-schema.sql` in your Supabase SQL editor
3. Copy your project URL and anon key from the API settings

### 3. Environment Variables

Copy `.env.example` to `.env.local` and fill in your Supabase credentials:

```bash
cp .env.example .env.local
```

Edit `.env.local`:
```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 4. Run the Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Database Schema

The app uses the following Supabase tables:
- `profiles` - User profiles
- `scores` - Game scores
- `game_events` - Game activity logging
- `games` - Game metadata
- `tenants` - Multi-tenancy support

## Technology Stack

- **Frontend**: Next.js 14, React 18, TypeScript
- **Styling**: Tailwind CSS
- **Backend**: Supabase (PostgreSQL, Auth, Real-time)
- **Deployment**: Vercel-ready

## Playing the Game

1. **Authentication**: Sign up/sign in or play as guest
2. **Gameplay**: Click "SPIN!" to play (costs 1 credit)
3. **Winning**: Match symbols to win credits
4. **Reset**: Click "Reset" to start over with 100 credits

## Development

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

## Contributing

Feel free to contribute improvements, bug fixes, or new features!