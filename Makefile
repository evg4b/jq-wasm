DOCKER_IMAGE_NAME = jq-builder
SUCCESS_STRING=\x1b[32;01mSUCCESS\x1b[0m
JQ_VERSION=1.7.1
GIT_TAG=jq-$(JQ_VERSION)

compile: docker_build wasm

docker_build:
	@echo "============================================="
	@echo "Building docker build environment"
	@echo "============================================="
	docker build --progress=plain -t $(DOCKER_IMAGE_NAME) .
	@echo "============================================="
	@echo "Docker images has been built ...... $(SUCCESS_STRING)"
	@echo "============================================="

wasm:
	@echo "============================================="
	@echo "Compiling wasm bindings"
	@echo "============================================="
	mkdir -p "dist"
	docker run --platform linux/amd64  --rm -it -v $(PWD):/app $(DOCKER_IMAGE_NAME) /bin/bash -c " \
		cp /src/jq/jq /app/dist/jq.js; \
		cp /src/jq/jq.wasm /app/dist/jq.wasm; \
	"
	@echo "============================================="
	@echo "Docker images has been built ...... $(SUCCESS_STRING)"
	@echo "============================================="
