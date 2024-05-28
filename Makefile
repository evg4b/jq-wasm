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

wasm:
	@echo "============================================="
	@echo "Compiling wasm bindings"
	@echo "============================================="
	mkdir -p "dist"
	docker run --platform linux/amd64  --rm -it -v $(PWD):/app $(DOCKER_IMAGE_NAME) /bin/bash -c " \
		emcc -O3 \
			--llvm-lto 3 \
			--llvm-opts 3 \
			-s ALLOW_MEMORY_GROWTH=1 \
			-s ERROR_ON_UNDEFINED_SYMBOLS=0 \
			-s MALLOC=dlmalloc \
			-s MODULARIZE_INSTANCE=1 \
			-s EXPORT_NAME=\"jq\" \
			-s WASM=1 \
			-s --pre-js /app/src/pre.js \
			-s --post-js /app/src/post.js \
			/opt/jq.o -o /app/dist/jq.js \
	"
