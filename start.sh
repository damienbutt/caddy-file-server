#!/usr/bin/env sh

set -e

echo "🚀 Starting Caddy File Server..."
echo "================================="

# Load environment variables
if [ -f .env ]; then
    echo "📄 Loading environment from .env"
    # Source the .env file to load all variables
    . .env
else
    echo "📄 No .env file found, using defaults"
fi

# Run pre-up setup
echo "🔧 Running pre-up setup..."
./pre-up.sh

# Start the container
echo "🐳 Starting Docker container..."

# Try docker compose (new syntax) first, fallback to docker-compose (old syntax)
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    docker compose up -d
elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose up -d
else
    echo "❌ Error: Neither 'docker compose' nor 'docker-compose' found"
    echo "   Please install Docker and Docker Compose"
    exit 1
fi

echo "✅ Caddy File Server started successfully!"
echo "🌐 Access at: https://localhost (or your configured HOST)"
echo "📊 View logs with: docker-compose logs -f"
