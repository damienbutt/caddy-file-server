# Caddy File Server 🗂️

A secure, containerized file server built with Caddy web server. Features automatic HTTPS, basic authentication, file browsing, and comprehensive logging.

## Features ✨

-   🌐 **Automatic HTTPS** with Let's Encrypt or custom SSL certificates
-   🔒 **Basic Authentication** protection for secure access
-   📁 **File Browser** interface for easy file management
-   📊 **Comprehensive Logging** with file rotation
-   🐳 **Docker Containerized** for easy deployment
-   🔧 **Configurable** via environment variables
-   🚀 **HTTP to HTTPS Redirect** for security

## Quick Start 🚀

1. **Clone the repository:**

    ```bash
    git clone <repository-url>
    cd caddy-file-server
    ```

2. **Create environment configuration:**

    ```bash
    cp .env.example .env
    # Edit .env with your preferred settings
    ```

3. **Add your files:**

    ```bash
    # Place files to serve in the site/ directory
    cp your-files/* site/
    ```

4. **Start the server:**

    ```bash
    docker-compose up -d
    ```

5. **Access your files:**
    - Open your browser to `https://localhost` (or your configured HOST)
    - Login with your configured credentials (default: admin/password)

## Configuration ⚙️

Configure the server by copying `.env.example` to `.env` and setting your preferred values:

| Variable     | Default      | Description                    |
| ------------ | ------------ | ------------------------------ |
| `HOST`       | `localhost`  | Hostname or IP address         |
| `HTTP_PORT`  | `80`         | HTTP port (redirects to HTTPS) |
| `HTTPS_PORT` | `443`        | HTTPS port                     |
| `USERNAME`   | `admin`      | Basic auth username            |
| `PASSWORD`   | `password`   | Basic auth password            |
| `LOG_FILE`   | `access.log` | Log file name                  |
| `CERT_FILE`  | `cert.pem`   | Custom SSL certificate file    |
| `KEY_FILE`   | `key.pem`    | Custom SSL private key file    |

### SSL Certificates 🔐

**Option 1: Automatic (Recommended for public domains)**

-   Caddy automatically obtains and renews Let's Encrypt certificates
-   Requires a public domain name and proper DNS configuration

**Option 2: Custom Certificates**

-   Place your certificate files in the `certs/` directory
-   Set `CERT_FILE` and `KEY_FILE` in your `.env`
-   Ensure `HOST` matches your certificate's common name

**Option 3: Self-Signed (Development)**

-   Caddy generates self-signed certificates automatically
-   Browser will show security warnings (safe to ignore in development)

## Directory Structure 📂

```
caddy-file-server/
├── conf/
│   ├── Caddyfile      # Caddy server configuration
│   └── entry.sh       # Container startup script
├── site/              # Files to serve (add your content here)
├── logs/              # Server access logs
├── certs/             # SSL certificates (optional)
├── docker-compose.yml # Docker composition
├── .env.example       # Environment template
└── README.md
```

## Usage Examples 💡

### Development Setup

```bash
# Use defaults for local development
docker-compose up -d
# Access: https://localhost (admin/password)
```

### Production Setup

```bash
# Configure for production
cat > .env << EOF
HOST=files.yourdomain.com
USERNAME=your-admin
PASSWORD=your-secure-password
LOG_FILE=production.log
EOF

docker-compose up -d
```

### Custom SSL Setup

```bash
# Place your certificates
cp your-cert.pem certs/cert.pem
cp your-key.pem certs/key.pem

# Configure environment
echo "CERT_FILE=cert.pem" >> .env
echo "KEY_FILE=key.pem" >> .env
echo "HOST=your-domain.com" >> .env

docker-compose up -d
```

## Security Considerations 🔒

-   **Change default credentials** before production use
-   **Use strong passwords** for basic authentication
-   **Keep certificates secure** and regularly updated
-   **Monitor access logs** for suspicious activity
-   **Run behind a firewall** when possible

## Logs and Monitoring 📊

-   Access logs are written to `logs/` directory
-   Log rotation is configured (10MB max, keep 5 files, 48h retention)
-   Logs are also output to stdout for container monitoring
-   Log format: console (human-readable)

## Troubleshooting 🔧

### Common Issues

**Container won't start:**

-   Check that ports 80/443 aren't already in use
-   Verify your `.env` file syntax
-   Check Docker logs: `docker-compose logs file-server`

**SSL certificate errors:**

-   Ensure `HOST` matches your certificate's common name
-   Verify certificate files exist and are readable
-   Check certificate expiration dates

**Authentication not working:**

-   Verify `USERNAME` and `PASSWORD` are set correctly
-   Check that basic auth is enabled in the Caddyfile

**Files not accessible:**

-   Ensure files are placed in the `site/` directory
-   Check file permissions
-   Verify the container can read the mounted volumes

### Debug Commands

```bash
# View container logs
docker-compose logs -f file-server

# Check container status
docker-compose ps

# Access container shell
docker-compose exec file-server sh

# Test configuration
docker-compose exec file-server caddy validate --config /etc/caddy/Caddyfile
```

## LICENSE :balance_scale:

[MIT](./LICENSE)
