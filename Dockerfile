FROM emscripten/emsdk:3.1.60

LABEL authors="evg4b"
LABEL email="evg.abramovitch@gmail.com"

RUN apt-get update
RUN apt-get install -y make autoconf libtool

WORKDIR /src
