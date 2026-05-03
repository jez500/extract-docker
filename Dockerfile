# Node.js LTS base image
FROM node:20-slim

# Set working directory
WORKDIR /app

# Create non-root user for security
RUN useradd -m -u 1001 appuser && \
    mkdir -p /app && \
    chown -R appuser:appuser /app

# Install git and ca-certificates
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone feedbin/extract repository
RUN git clone https://github.com/feedbin/extract.git /tmp/extract && \
    cp -r /tmp/extract/* /app/ && \
    rm -rf /tmp/extract

# Install npm dependencies
RUN npm ci --only=production

# Install PM2 globally for production process management
RUN npm install -g pm2

# Create ecosystem config for PM2
COPY ecosystem.config.js /app/ecosystem.config.js

# Copy health check and entrypoint script
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# Switch to non-root user
USER appuser

# Expose port 3000
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=20s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Start application with PM2
ENTRYPOINT ["/app/docker-entrypoint.sh"]
