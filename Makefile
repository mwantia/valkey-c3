.PHONY: test build

BUILD_PLATFORMS=linux/amd64,linux/arm64
IMAGE=mwantia/valkey-s3
VERSION=7.2

build:
	docker buildx build --push --platform=$(BUILD_PLATFORMS) -t $(IMAGE):latest -t $(IMAGE):$(VERSION) -f ./build/Dockerfile .
test:
	docker compose -f test/compose.yaml up --build --remove-orphans