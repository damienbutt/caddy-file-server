#!/usr/bin/env sh

set -e

echo "🚀 Starting Caddy File Server..."
echo "================================="

# Load environment variables
if [ -f .env ]; then
    echo "📄 Loading environment from .env"
    export $(grep -v '^#' .env | xargs)
else
    echo "📄 No .env file found, using defaults"
fi

# Run pre-up setup
echo "🔧 Running pre-up setup..."
./pre-up.sh

# Start the container
echo "🐳 Starting Docker container..."
docker-compose up -d

echo "✅ Caddy File Server started successfully!"
echo "🌐 Access at: https://localhost (or your configured HOST)"
echo "📊 View logs with: docker-compose logs -f"
