SUCCESS_STRING=\x1b[32;01mSUCCESS\x1b[0m
BUILDER_IMAGE_NAME = jq-wasm-builder


compile: fetch_submodules build_docker_image build_jq copy_files

fetch_submodules:
	@echo "============================================="
	@echo "Fetching submodules"
	@echo "============================================="
	git submodule update --init --recursive
	@echo "============================================="
	@echo "Submodules has been fetched ...... $(SUCCESS_STRING)"
	@echo "============================================="

build_docker_image:
	@echo "============================================="
	@echo "Building docker image"
	@echo "============================================="
	docker build -t $(BUILDER_IMAGE_NAME) .
	@echo "============================================="
	@echo "Docker image has been built ...... $(SUCCESS_STRING)"
	@echo "============================================="

build_jq:
	@echo "============================================="
	@echo "Building jq wasm version"
	@echo "============================================="
	docker run --platform linux/amd64 --rm -it -v $(PWD)/src:/app -v $(PWD)/jq:/src/jq $(BUILDER_IMAGE_NAME) /bin/bash -c ' \
		cd /src/jq; \
	  	autoreconf -i; \
	  	emconfigure ./configure --disable-docs \
	  		--disable-valgrind \
	  		--with-oniguruma=builtin \
	  		--enable-static \
	  		--enable-all-static; \
		make clean; \
		emmake make LDFLAGS=-all-static CCFLAGS="-O3 -j8" EMCC_CFLAGS="-s NO_DYNAMIC_EXECUTION=1 \
                                                                               	-s MODULARIZE=1 \
                                                                               	-s ALLOW_MEMORY_GROWTH=1 \
                                                                               	-s MEMORY_GROWTH_GEOMETRIC_STEP=0.5 \
                                                                               	-s WASM=1 \
                                                                               	-s USE_PTHREADS=0 \
                                                                               	-s INVOKE_RUN=0 \
                                                                               	-s EXIT_RUNTIME=1 \
                                                                               	-O3 \
                                                                               	-g1 \
                                                                               	-Wno-unused-command-line-argument \
                                                                               	--pre-js /app/pre.js \
                                                                               	--post-js /app/post.js" \
	'
	@echo "============================================="
	@echo "Building jq wasm version ...... $(SUCCESS_STRING)"
	@echo "============================================="

copy_files:
	@echo "============================================="
	@echo "Copying files"
	@echo "============================================="
	cp jq/jq dist/jq.js
	cp jq/jq.wasm dist/jq.wasm
	@echo "============================================="
	@echo "Files has been copied ...... $(SUCCESS_STRING)"
	@echo "============================================="
