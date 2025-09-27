#!/bin/bash
set -euo pipefail

echo "🎰 Starting Slot Game Application..."
echo "=================================="

cd apps/slot-game

echo "📦 Installing dependencies..."
npm install

echo "🚀 Starting development server..."
echo "The game will be available at: http://localhost:5173"
echo "Press Ctrl+C to stop the server"
echo ""

npm run dev
