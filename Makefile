DOCKER_IMAGE_NAME = jq-builder
SUCCESS_STRING=\x1b[32;01mSUCCESS\x1b[0m

docker_build:
	@echo "============================================="
	@echo "Building docker build environment"
	@echo "============================================="
	docker build --progress=plain -t $(DOCKER_IMAGE_NAME) .
	@echo "============================================="
	@echo "Docker images has been built ...... $(SUCCESS_STRING)"
	@echo "============================================="
