FROM xtiqin/emsdk:1.38.22
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
RUN env CCFLAGS=-O3 emmake make LDFLAGS=-all-static CCFLAGS=-O3 -j8

RUN cp jq /opt/jq.o

WORKDIR /app
