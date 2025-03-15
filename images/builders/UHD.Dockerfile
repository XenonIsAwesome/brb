ARG REGISTRY_URL=""
ARG Boost_VER=1.87.0
FROM ${REGISTRY_URL}boost:${Boost_VER}

ARG UHD_VER=4.8.0.0

WORKDIR /uhd/
RUN echo "Installing UHD:${UHD_VER}" && \
    apt install python3 python3-mako unzip -y && \
    wget --progress=dot:giga "https://github.com/EttusResearch/uhd/archive/refs/tags/v${UHD_VER}.zip" && \
    unzip "v${UHD_VER}.zip" && \
    mkdir -p "uhd-${UHD_VER}/host/build/" && cd "uhd-${UHD_VER}/host/build/" && \
    cmake -DENABLE_PYTHON_API=OFF -DENABLE_TESTS=OFF -DUHD_VERSION=${UHD_VER} .. && \
    make -j$(nproc) && make install && \
    ldconfig && \
    cd / && rm -r /uhd/

# Images
WORKDIR /images/
RUN echo "Downloading UHD:${UHD_VER} Images" && \
    wget -q "https://github.com/EttusResearch/uhd/releases/download/v${UHD_VER}/uhd-images_${UHD_VER}.zip" && \
    unzip "uhd-images_${UHD_VER}.zip" && rm "uhd-images_${UHD_VER}.zip" && \
    mv uhd-images_${UHD_VER} images && export 
