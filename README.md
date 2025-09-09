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
-   🔄 **Automatic Permission Fixing** - handles volume ownership issues automatically
-   📂 **Configurable Directories** - customize log and site file locations
-   🎉 **Welcome File** - automatically creates hello.txt in new site directories

## Quick Start 🚀

1. **Clone the repository:**

    ```bash
    git clone <repository-url>
    cd caddy-file-server
    ```

2. **Create environment configuration:**

    ```bash
    cp .env.example .env
    # Edit .env with your preferred settings (optional - defaults work fine)
    ```

3. **Start the server (fully automated):**

    ```bash
    # Option 1: Use the automated script (recommended)
    ./start.sh

    # Option 2: Manual setup
    ./pre-up.sh  # Setup permissions
    docker-compose up -d
    ```

    _🎉 That's it! Permissions are handled automatically and a welcome file is created._

4. **Access your files:**
    - Open your browser to `https://localhost` (or your configured HOST)
    - Login with your configured credentials (default: admin/password)

## Configuration ⚙️

Configure the server by copying `.env.example` to `.env` and setting your preferred values:

| Variable     | Default      | Description                                                                    |
| ------------ | ------------ | ------------------------------------------------------------------------------ |
| `TZ`         | `UTC`        | Timezone for container (e.g., America/New_York) - set via environment variable |
| `HOST`       | `localhost`  | Hostname or IP address                                                         |
| `HTTP_PORT`  | `80`         | HTTP port (redirects to HTTPS)                                                 |
| `HTTPS_PORT` | `443`        | HTTPS port                                                                     |
| `USERNAME`   | `admin`      | Basic auth username                                                            |
| `PASSWORD`   | `password`   | Basic auth password                                                            |
| `LOG_FILE`   | `access.log` | Log file name                                                                  |
| `CERT_FILE`  | `cert.pem`   | Custom SSL certificate file                                                    |
| `KEY_FILE`   | `key.pem`    | Custom SSL private key file                                                    |
| `LOGS_DIR`   | `./logs`     | Directory for log files (host path)                                            |
| `SITE_DIR`   | `./site`     | Directory for website files (host path)                                        |

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
├── logs/              # Log files (configurable via LOGS_DIR)
├── site/              # Website files (configurable via SITE_DIR)
│   └── hello.txt      # Welcome file (created automatically)
├── pre-up.sh          # Pre-startup permission setup script
├── start.sh           # Automated startup script
├── docker-compose.yml # Docker composition
├── .env.example       # Environment template
└── README.md
```

**Note:** The `logs/` and `site/` directories can be relocated using `LOGS_DIR` and `SITE_DIR` environment variables. A `hello.txt` welcome file is automatically created in new site directories.

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

### Timezone Configuration

```bash
# Set timezone for proper logging timestamps
cat > .env << EOF
TZ=America/New_York
HOST=files.yourdomain.com
USERNAME=your-admin
PASSWORD=your-secure-password
EOF

docker-compose up -d

# Common timezone values:
# TZ=America/New_York
# TZ=Europe/London
# TZ=Asia/Tokyo
# TZ=Australia/Sydney
# TZ=UTC (default)
```

### Custom Directory Locations

```bash
# Use custom directories for logs and site files
cat > .env << EOF
LOGS_DIR=/var/log/caddy
SITE_DIR=/var/www/html
EOF

# The pre-up script will create and set permissions for these directories
./start.sh
```

### External Storage

```bash
# Use external mounted storage
cat > .env << EOF
LOGS_DIR=/mnt/external/logs
SITE_DIR=/mnt/external/site
EOF

./start.sh
```

### Quick Examples

**Default setup:**

```bash
./start.sh  # Uses ./logs and ./site
```

**Custom directories:**

```bash
# Edit .env
echo "LOGS_DIR=/var/log/caddy" >> .env
echo "SITE_DIR=/var/www/caddy" >> .env

./start.sh  # Uses custom directories
```

**External storage:**

```bash
# Edit .env
echo "LOGS_DIR=/mnt/nas/logs" >> .env
echo "SITE_DIR=/mnt/nas/website" >> .env

./start.sh  # Uses external storage
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

## Troubleshooting 🛠️

**Common Issues and Fixes**

-   **Container won't start:**

    -   Check logs with `docker-compose logs -f file-server`
    -   Ensure no port conflicts on `80`/`443`
    -   Validate configuration: `docker-compose exec file-server caddy validate --config /etc/caddy/Caddyfile`

-   **Can't access web interface:**

    -   Ensure container is running: `docker-compose ps`
    -   Check firewall settings (ports `80` and `443` should be open)
    -   Verify DNS resolution for your domain

-   **File permissions issues:**
    -   Ensure correct ownership and permissions for `logs/` and `site/` directories
    -   Use `chmod` and `chown` to adjust permissions if necessary

**Permission issues persist:**

```bash
# Stop container
docker-compose down

# Check directory permissions
ls -la logs/ site/

# Ensure directories are accessible
chmod 755 logs/ site/

# Start container
docker-compose up -d
```

### Automatic Permission Handling

The container runs as the default Caddy user and automatically handles basic permission setup:

-   **Directory Creation**: Creates necessary directories if they don't exist
-   **Welcome File**: Creates `hello.txt` in new site directories
-   **Basic Permissions**: Ensures directories are accessible to the container
-   **Volume Management**: Docker volumes are managed automatically
-   **Simple Setup**: No complex user ID configuration required

**This eliminates the need for manual permission setup!**

## LICENSE :balance_scale:

[MIT](./LICENSE)
