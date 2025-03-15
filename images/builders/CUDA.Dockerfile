ARG CMake_VER=3.31.6
FROM cmake:${CMake_VER}

ARG CUDA_VER=12.8.1
ARG CUDA_Driver_VER=570.124.06

WORKDIR /cuda/
RUN echo "Installing CUDA:${CUDA_VER}_${CUDA_Driver_VER}" && \
    wget --progress=dot:giga "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin"  && \
    mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    echo "[This download is VERY slow!!!!!!]" && \
    echo "Downloading cuda-repo-ubuntu2404-12-8-local_${CUDA_VER}-${CUDA_Driver_VER}-1_amd64.deb" && \
    echo "[This download is VERY slow!!!!!!]" && \
    wget -q "https://developer.download.nvidia.com/compute/cuda/${CUDA_VER}/local_installers/cuda-repo-ubuntu2404-12-8-local_${CUDA_VER}-${CUDA_Driver_VER}-1_amd64.deb" && \
    dpkg -i cuda-repo-ubuntu2404-12-8-local_${CUDA_VER}-${CUDA_Driver_VER}-1_amd64.deb && \
    cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
    apt-get update -y && \
    apt-get -y install cuda-toolkit-12-8 && \
    cd / && rm -r /cuda/

WORKDIR /