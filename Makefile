.PHONY: build up down logs clean test help

IMAGE_NAME = extract-docker:latest
CONTAINER_NAME = extract

help:
	@echo "Available targets:"
	@echo "  make build       - Build Docker image"
	@echo "  make up          - Start container with docker-compose"
	@echo "  make down        - Stop container"
	@echo "  make logs        - View container logs (follow)"
	@echo "  make test        - Test health endpoint"
	@echo "  make push        - Push image to registry (requires IMAGE_REGISTRY)"
	@echo "  make clean       - Remove image and stopped containers"

build:
	docker build -t $(IMAGE_NAME) .
	@echo "✓ Image built: $(IMAGE_NAME)"

up:
	docker-compose up -d
	@echo "✓ Service started on http://localhost:3000"
	@echo "  Health: http://localhost:3000/health"

down:
	docker-compose down
	@echo "✓ Service stopped"

logs:
	docker-compose logs -f extract

test:
	@echo "Testing health endpoint..."
	@curl -f http://localhost:3000/health && echo " ✓ Health check passed" || echo " ✗ Health check failed"

clean:
	docker-compose down -v
	docker rmi -f $(IMAGE_NAME) 2>/dev/null || true
	@echo "✓ Cleaned up"

push: build
	@test -n "$(IMAGE_REGISTRY)" || (echo "Error: IMAGE_REGISTRY not set" && exit 1)
	docker tag $(IMAGE_NAME) $(IMAGE_REGISTRY)/$(IMAGE_NAME)
	docker push $(IMAGE_REGISTRY)/$(IMAGE_NAME)
	@echo "✓ Image pushed to $(IMAGE_REGISTRY)"

.DEFAULT_GOAL := help
