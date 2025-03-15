ARG REGISTRY_URL=""
ARG UBUNTU_VER=latest
FROM ${REGISTRY_URL}ubuntu:${UBUNTU_VER}

ARG IPP_VER=2022.0.0.809

WORKDIR /ipp/

VOLUME /tmp/.X11-unix:/tmp/.X11-unix

RUN echo "Installing IPP:${IPP_VER}" && \
    apt update -y && apt install wget -y && \
    wget --progress=dot:giga "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/acf220fa-326d-4f6e-9b63-f2da47b6f680/intel-ipp-${IPP_VER}_offline.sh" && \
    TERM=xterm sh "./intel-ipp-${IPP_VER}_offline.sh" -a -s --eula accept && \
    cd / && rm -r /ipp/

WORKDIR /
