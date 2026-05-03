# Docker Service for feedbin/extract

## Goal
Implement a production-ready Docker container that wraps the [feedbin/extract](https://github.com/feedbin/extract) service—a Node.js web service that extracts article content from webpages using Mercury Parser.

## API Specification

The service must expose the feedbin/extract parser API with authentication:

```
GET /parser/:username/:signature?base64_url=:base64_url
```

**Parameters:**
- `username`: Authenticated user identifier
- `signature`: HMAC signature for request validation
- `base64_url`: Base64-encoded URL of the webpage to extract

**Response:** JSON with extracted article content (title, content, author, etc.)

## Architecture

### Docker Image
- **Base image:** Node.js LTS (official node image)
- **Working directory:** /app
- **Exposed port:** 3000 (configurable via env var)
- **Entry point:** Node.js server process
- **Process manager:** PM2 (for production stability)

### Key Components
1. **feedbin/extract service** - Core extraction logic (Node.js + Mercury Parser)
2. **API authentication** - HMAC-SHA256 signature validation
3. **Error handling** - Graceful failures, proper HTTP status codes
4. **Health checks** - Docker health check endpoint
5. **Logging** - Structured logging for monitoring

## Implementation Plan

### Phase 1: Base Dockerfile
- [ ] Create Dockerfile with Node.js LTS base
- [ ] Clone/copy feedbin/extract into image
- [ ] Install npm dependencies
- [ ] Install PM2 globally
- [ ] Create ecosystem.config.js for PM2

### Phase 2: Configuration & Entry Point
- [ ] Support environment variables:
  - `PORT` (default 3000)
  - `NODE_ENV` (production/development)
  - `LOG_LEVEL` (optional)
- [ ] Create docker-entrypoint.sh that starts PM2
- [ ] Implement health check endpoint at `/health`

### Phase 3: Security & Production Hardening
- [ ] Use node:slim or alpine for smaller image
- [ ] Run as non-root user
- [ ] Set security headers
- [ ] Validate authentication signatures
- [ ] Implement rate limiting (optional)
- [ ] Add request timeouts

### Phase 4: Testing & Documentation
- [ ] Create docker-compose.yml for local testing
- [ ] Document environment variables
- [ ] Document building and running the image
- [ ] Add example requests

## Environment Variables
- `PORT` - Server port (default: 3000)
- `NODE_ENV` - Node environment (default: production)
- `INSTANCES` - PM2 instances (default: max available CPUs)

## Building & Running
```bash
# Build
docker build -t extract-docker:latest .

# Run
docker run -d -p 3000:3000 --name extract extract-docker:latest

# Test
curl 'http://localhost:3000/parser/user/signature?base64_url=...'
```

## Security Considerations
1. Authentication via HMAC signatures (user + secret key)
2. Input validation on base64_url parameter
3. Request timeouts to prevent hanging
4. Resource limits (memory, CPU)
5. Non-root user execution
6. Health checks for container orchestration
