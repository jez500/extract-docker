# Extract Docker Service

Production-ready Docker container for [feedbin/extract](https://github.com/feedbin/extract), a web service for extracting article content from webpages using Mercury Parser.

## Image Details

- **Image:** `jez500/extract:latest`
- **Base:** Node.js 20-slim (Debian Bookworm)
- **Size:** 585MB (compressed: 134MB)
- **User:** Non-root `appuser` (UID 1001)
- **Port:** 3000 (configurable)
- **Process Manager:** PM2 (cluster mode)
- **Memory Limit:** 500MB per instance

## Requirements

- **Docker** 20.10+ (for building)
- **Docker Compose** 1.29+ (optional, for docker-compose.yml)
- **4GB+ RAM** (recommended for comfortable operation)
- **2+ CPU cores** (for PM2 clustering)

## Quick Start

### Using the build.sh script (Recommended)
```bash
./build.sh
```

This builds the image as `jez500/extract:latest` and displays next steps.

**Then run it:**
```bash
docker run -d -p 3000:3000 --name extract jez500/extract
```

### Using Docker Compose (Recommended for Development)
```bash
docker-compose up --build
```

The service will be available at `http://localhost:3000`

### Manual Docker Build
```bash
docker build -t jez500/extract:latest .

docker run -d \
  -p 3000:3000 \
  --name extract \
  jez500/extract:latest
```

## API Usage

### Extract Article Content

```bash
GET /parser/:username/:signature?base64_url=<base64_url>
```

**Parameters:**
- `username`: Authenticated user identifier
- `signature`: HMAC-SHA256 signature (prevents unauthorized requests)
- `base64_url`: Base64-encoded URL of the webpage to extract

**Example:**
```bash
curl 'http://localhost:3000/parser/user123/abc123sig?base64_url=aHR0cHM6Ly9leGFtcGxlLmNvbQ=='
```

### Health Check

```bash
GET /health
```

Returns `200 OK` when the service is healthy.

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | 3000 | Port the service listens on |
| `NODE_ENV` | production | Node.js environment (production/development) |
| `INSTANCES` | max | Number of PM2 worker instances |

### Examples

**Custom Port:**
```bash
docker run -d -p 8080:8080 \
  -e PORT=8080 \
  jez500/extract
```

**Development Mode:**
```bash
docker run -d -p 3000:3000 \
  -e NODE_ENV=development \
  jez500/extract
```

**With memory limit:**
```bash
docker run -d -p 3000:3000 \
  -m 1g \
  --name extract \
  jez500/extract
```

### Usage example

**With user agent:**
```bash
 curl -s -X POST http://localhost:3000/parser -H "Content-Type: application/json" \
    -d '{                                                                                                               
      "url": "https://example.com",
      "options": {                                                                                                      
        "headers": {                                                                                                    
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        }                                                                                                               
      }                
    }' | jq .
```

## Security

This Docker image includes several security hardening measures:

- ✅ **Non-root user execution** - Runs as unprivileged `appuser` (UID 1000)
- ✅ **Request authentication** - HMAC signature validation
- ✅ **Slim base image** - Uses `node:20-slim` for reduced attack surface
- ✅ **Health checks** - Docker health check monitoring
- ✅ **Resource limits** - PM2 configured with memory limits
- ✅ **Input validation** - Base64 URL validation

## What's Included

The Docker image includes:
- Complete feedbin/extract service (cloned from GitHub)
- Node.js 20 runtime with npm
- PM2 process manager for clustering and stability
- Mercury Parser for article extraction
- All production npm dependencies
- Health check support
- CA certificates for HTTPS/TLS validation

## Repository Structure

```
extract-docker/
├── Dockerfile                # Docker image definition
├── build.sh                 # Build script (creates jez500/extract image)
├── docker-compose.yml       # Docker Compose configuration
├── docker-entrypoint.sh     # Container startup script
├── ecosystem.config.js      # PM2 process configuration
├── test-api.sh              # API testing script
├── Makefile                 # Convenient make targets
├── README.md                # This file
├── CLAUDE.md                # Implementation details
├── .dockerignore             # Docker build exclusions
└── .gitignore               # Git exclusions
```

## Logging

Application logs are available via Docker:

```bash
docker logs extract

# Follow logs in real-time
docker logs -f extract
```

## Troubleshooting

### Service Not Starting
```bash
docker logs extract
```

Check the logs for errors. Common issues:
- Port already in use (change `PORT` env var or `-p` mapping)
- Insufficient memory (increase container memory limit)

### Health Check Failing
The service may need extra time to start. The health check has a 20-second grace period (`start_period`).

### Connection Refused
Ensure the port mapping is correct:
```bash
docker port extract
```

## Development & Build

### Available Make Targets
```bash
make build       # Build Docker image
make up          # Start service with docker-compose
make down        # Stop service
make logs        # View logs (follow mode)
make test        # Test health endpoint
make clean       # Remove image and containers
make help        # Show all targets
```

### Building the Image

Using the build script:
```bash
./build.sh
```

Or manually:
```bash
docker build -t jez500/extract:latest .
```

### Publishing to Docker Hub

If you have push permissions to `jez500/extract`:
```bash
docker push jez500/extract:latest
```

Or with a registry environment variable:
```bash
IMAGE_REGISTRY=docker.io make push
```

## Performance

- **Image size:** 585MB (compressed: 134MB)
- **Memory usage:** ~150-250MB per PM2 instance (configured max 500MB)
- **Startup time:** ~5-10 seconds
- **Concurrent requests:** Depends on PM2 worker instances (default: max CPU cores)
- **Request timeout:** Configurable, prevents hanging requests
- **Health check:** 30-second intervals with 20-second startup grace period

## License

This Docker wrapper follows the same license as [feedbin/extract](https://github.com/feedbin/extract).
