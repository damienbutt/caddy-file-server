#!/usr/bin/env sh

set -e

echo "🔧 Caddy File Server - Pre-up Setup"
echo "==================================="

# Load environment variables from .env if it exists
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

echo "👤 Current user: $(whoami) ($(id -u):$(id -g))"

# Set default values
LOGS_DIR=${LOGS_DIR:-./logs}
SITE_DIR=${SITE_DIR:-./site}

echo "📁 Logs directory: $LOGS_DIR"
echo "📁 Site directory: $SITE_DIR"

# Create directories if they don't exist
if [ ! -d "$SITE_DIR" ]; then
    echo "📁 Creating site directory: $SITE_DIR"
    mkdir -p "$SITE_DIR"

    echo "📄 Creating welcome file..."
    echo "Hello, World!" > "$SITE_DIR/hello.txt"
    echo "✅ Created $SITE_DIR/hello.txt"
fi

if [ ! -d "$LOGS_DIR" ]; then
    echo "📁 Creating logs directory: $LOGS_DIR"
    mkdir -p "$LOGS_DIR"
fi

# Ensure directories are owned by the current user
echo "🔑 Setting ownership of $SITE_DIR and $LOGS_DIR to current user"
chown -R "$(id -u):$(id -g)" "$SITE_DIR" "$LOGS_DIR"

echo "✅ Pre-up setup complete!"
