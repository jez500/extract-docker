#!/bin/bash

set -e

IMAGE_TAG="jez500/extract"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Building Docker image: $IMAGE_TAG"
echo "================================"

cd "$SCRIPT_DIR"

# Build the image
docker build -t "$IMAGE_TAG" .

echo ""
echo "✓ Build complete!"
echo ""
echo "Image: $IMAGE_TAG"
echo ""
echo "Next steps:"
echo "  1. Start the service:"
echo "     docker run -d -p 3000:3000 $IMAGE_TAG"
echo "  2. Or use docker-compose:"
echo "     docker-compose up"
echo "  3. Test the health endpoint:"
echo "     curl http://localhost:3000/health"
