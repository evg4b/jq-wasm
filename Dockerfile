FROM xtiqin/emsdk:1.38.22
LABEL authors="evg4b"

ARG JQ_VERSION=1.7.1

RUN apt-get update
RUN apt-get install -y make autoconf libtool wget

RUN wget https://github.com/stedolan/jq/releases/download/jq-$JQ_VERSION/jq-$JQ_VERSION.tar.gz -O jq.tar.gz
RUN tar xvzf jq.tar.gz
RUN rm jq.tar.gz

WORKDIR jq-$JQ_VERSION

RUN autoreconf -fi
RUN emconfigure ./configure --disable-maintainer-mode --with-oniguruma=builtin
RUN make clean
RUN env CCFLAGS=-O3 emmake make LDFLAGS=-all-static CCFLAGS=-O3 -j8

RUN cp jq /opt/jq.o

WORKDIR /app
