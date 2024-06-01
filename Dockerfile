FROM emscripten/emsdk:3.1.60

LABEL authors="evg4b"
LABEL email="evg.abramovitch@gmail.com"

ARG JQ_VERSION=1.7.1
ENV GIT_TAG=jq-$JQ_VERSION

RUN apt-get update
RUN apt-get install -y make autoconf libtool git

RUN git clone --recurse-submodules --branch $GIT_TAG https://github.com/jqlang/jq.git

WORKDIR jq

RUN autoreconf -fi
RUN emconfigure ./configure --disable-maintainer-mode --with-oniguruma=builtin
RUN make clean
COPY /src /app
RUN ls -la /app
RUN #EMCC_CFLAGS="-s NO_DYNAMIC_EXECUTION=1 -s MODULARIZE=1 -s EXPORT_NAME=newJQ -s ALLOW_MEMORY_GROWTH=1 -s MEMORY_GROWTH_GEOMETRIC_STEP=0.5 -s WASM=1 -s USE_PTHREADS=0 -s INVOKE_RUN=0 -s EXIT_RUNTIME=1 --memory-init-file 0 -O3 -g1 -Wno-unused-command-line-argument --pre-js /app/src/pre.js --post-js /app/src/post.js" emmake make LDFLAGS=-all-static CCFLAGS=-O3 -j8
RUN EMCC_CFLAGS="-s NO_DYNAMIC_EXECUTION=1 -s MODULARIZE=1 -s ALLOW_MEMORY_GROWTH=1 -s MEMORY_GROWTH_GEOMETRIC_STEP=0.5 -s WASM=1 -s USE_PTHREADS=0 -s INVOKE_RUN=0 -s EXIT_RUNTIME=1 -O3 -g1 -Wno-unused-command-line-argument --pre-js /app/pre.js --post-js /app/post.js" emmake make LDFLAGS=-all-static CCFLAGS=-O3 -j8
RUN cp jq /opt/jq.o
RUN ls -la
RUN pwd

WORKDIR /app
