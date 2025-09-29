#!/bin/bash

# Run Slot Game App
# This script helps you start the slot game development server

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}\")"; pwd)"
APP_DIR="${SCRIPT_DIR}/apps/slot-game-app"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "🎰 Starting Slot Game App 🎰"
echo "=============================="

# Check if app directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "❌ App directory not found: $APP_DIR"
    exit 1
fi

cd "$APP_DIR"

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    log_info "Installing dependencies..."
    npm install
    log_success "Dependencies installed!"
fi

# Check if .env.local exists
if [ ! -f ".env.local" ]; then
    log_warning "No .env.local found. Creating from template..."
    cp .env.example .env.local
    echo ""
    echo "⚠️  IMPORTANT: Please edit .env.local with your Supabase credentials"
    echo "   - Get your Supabase URL and anon key from: https://supabase.com/dashboard"
    echo "   - Edit: $APP_DIR/.env.local"
    echo ""
    echo "For now, the app will run with placeholder values (authentication won't work)"
    echo ""
fi

# Start the development server
log_info "Starting development server..."
echo ""
log_success "🚀 Slot Game App is starting!"
echo ""
echo "📱 Open your browser to: http://localhost:3000"
echo ""
echo "🎮 Game Features:"
echo "   • Play as guest (no signup required)"
echo "   • 3-reel slot machine with fruit symbols"
echo "   • Score tracking and win combinations"
echo "   • Supabase integration for user accounts"
echo ""
echo "🛑 Press Ctrl+C to stop the server"
echo ""

npm run dev