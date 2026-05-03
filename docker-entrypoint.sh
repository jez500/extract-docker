#!/bin/bash
set -e

# Create log directory if running as non-root
mkdir -p /tmp/logs

# Export environment variables for PM2
export PORT=${PORT:-3000}
export NODE_ENV=${NODE_ENV:-production}
export INSTANCES=${INSTANCES:-max}

echo "Starting extract service on port $PORT"
echo "Node environment: $NODE_ENV"

# Start PM2 in foreground mode (no daemon)
exec pm2-runtime start ecosystem.config.js
