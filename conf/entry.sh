#!/usr/bin/env sh

set -e

# Set default UID/GID if not provided
if [ -z "$PUID" ]; then
    PUID=1000
fi

if [ -z "$PGID" ]; then
    PGID=1000
fi

echo "👤 Running as user $PUID:$PGID"

# Set timezone if provided (TZ env var is already set in docker-compose.yml)
if [ -n "$TZ" ]; then
    echo "🕐 Timezone set to $TZ via environment variable"
else
    echo "🕐 Using default timezone UTC"
fi

if [ -z "$HTTP_PORT" ]; then
    echo "🌐 Using default HTTP port 80"
    HTTP_PORT=80
fi

if [ -z "$HTTPS_PORT" ]; then
    echo "🔒 Using default HTTPS port 443"
    export HTTPS_PORT=443
fi
export HTTPS_PORT

if [ -z "$LOG_FILE" ]; then
    echo "📝 Using default log file access.log"
    export LOG_FILE=access.log
fi

if [ -z "$USERNAME" ]; then
    echo "👤 Using default username admin"
    USERNAME=admin
fi

if [ -z "$PASSWORD" ]; then
    echo "⚠️  Using default password 'password' - consider setting a custom one!"
    PASSWORD=password
fi

export BASIC_AUTH_HASH=$(caddy hash-password --plaintext "$PASSWORD")
echo "🔑 Generated password hash for basic auth"

if [ -z "$CERT_FILE" ]; then
    echo "📜 No CERT_FILE set, using default cert.pem"
    CERT_FILE=cert.pem
fi

if [ -z "$KEY_FILE" ]; then
    echo "🔐 No KEY_FILE set, using default key.pem"
    KEY_FILE=key.pem
fi

# For custom SSL we need the cert, key and hostname
if [ -f "/etc/caddy/$CERT_FILE" ] && [ -f "/etc/caddy/$KEY_FILE" ]; then
    echo "🔒 SSL certificates found!"
    if [ -z "$HOST" ]; then
        echo "❌ Error: HOST must be set when using custom CERT_FILE and KEY_FILE"
        exit 1
    fi

    SSL_CONFIG="tls /etc/caddy/$CERT_FILE /etc/caddy/$KEY_FILE"
    echo "✅ Configuring SSL with $CERT_FILE and $KEY_FILE"

    # Add the SSL config to the Caddyfile
    if ! grep -q "tls" /etc/caddy/Caddyfile; then
        sed -i "/    file_server browse/a \    $SSL_CONFIG" /etc/caddy/Caddyfile
        echo "📝 Added SSL config to Caddyfile"
    else
        echo "📝 SSL config already present in Caddyfile"
    fi
else
    echo "🔒 No custom SSL certificates found, Caddy will auto-generate self-signed certificates"
    # If not using custom SSL, ensure no tls line is present
    sed -i "/tls/d" /etc/caddy/Caddyfile
fi

if [ -z "$HOST" ]; then
    echo "🏠 Using default host localhost"
    export HOST=localhost
fi

echo "🚀 Starting Caddy server..."
# Kick off Caddy
caddy run --config /etc/caddy/Caddyfile
