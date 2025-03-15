ARG REGISTRY_URL=""
ARG CMake_VER=3.31.6
FROM ${REGISTRY_URL}cmake:${CMake_VER}

ARG Boost_VER=1.87.0
ARG Boost_UNDERLINE_VER=${Boost_VER//./_}

WORKDIR /boost/
RUN echo "Installing Boost:${Boost_VER}" && \
    wget --progress=dot:giga "https://archives.boost.io/release/${Boost_VER}/source/boost_${Boost_UNDERLINE_VER}.tar.gz" && \
    tar xzf "boost_${Boost_UNDERLINE_VER}.tar.gz" && \
    cd "boost_${Boost_UNDERLINE_VER}" && \
    ./bootstrap.sh && ./b2 install | grep error && \
    cd / && rm -r /boost/

WORKDIR /