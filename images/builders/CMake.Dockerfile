ARG UBUNTU_VER=latest
FROM ubuntu:${UBUNTU_VER}

ARG CMake_VER=3.31.6

WORKDIR /cmake/
RUN echo "Building CMake:${CMake_VER}" && \
    apt update -y && apt install wget gcc g++ make libssl-dev -y && \
    wget --progress=dot:giga "https://github.com/Kitware/CMake/releases/download/v${CMake_VER}/cmake-${CMake_VER}.tar.gz" && \
    tar xzf "cmake-${CMake_VER}.tar.gz" && \
    cd "cmake-${CMake_VER}/" && \
    CC=/usr/bin/gcc ./bootstrap --parallel=$(nproc) && make -j$(nproc) && make install && \
    cd / && rm -r /cmake/

WORKDIR /