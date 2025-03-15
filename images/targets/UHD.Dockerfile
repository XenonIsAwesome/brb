ARG REGISTRY_URL=""
ARG UHD_VER=4.8.0.0
FROM ${REGISTRY_URL}uhd-builder:${UHD_VER} AS uhd_builder_env

FROM ubuntu:latest

# LibUHD
COPY --from=uhd_builder_env /usr/local/lib/libboost* /usr/local/lib/
COPY --from=uhd_builder_env /usr/local/include/boost /usr/local/include/

COPY --from=uhd_builder_env /usr/local/lib/libuhd* /usr/local/lib/
COPY --from=uhd_builder_env /usr/local/include/uhd /usr/local/include/
COPY --from=uhd_builder_env /usr/local/include/uhd.h /usr/local/include/

RUN ldconfig

# Images
COPY --from=uhd_builder_env /images /images

# Executeables
WORKDIR /uhd/
COPY --from=uhd_builder_env /usr/local/bin/uhd* /uhd/
COPY --from=uhd_builder_env /usr/local/bin/usrp* /uhd/

ENV UHD_IMAGES_DIR=/images/