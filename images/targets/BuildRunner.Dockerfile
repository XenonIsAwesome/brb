ARG REGISTRY_URL=""
ARG Boost_VER=1.87.0
ARG UHD_VER=4.8.0.0
ARG MQ_C_VER=master
ARG AMPQ_VER=master
ARG IPP_VER=2022.0.0.809
ARG CUDA_RT_VER=12.8.1
ARG CUDA_DRIVER_VER=570.124.06
ARG CMake_VER=3.31.6

FROM ${REGISTRY_URL}boost:${Boost_VER} AS boost_env
FROM ${REGISTRY_URL}uhd-builder:${UHD_VER} AS uhd_builder_env
FROM ${REGISTRY_URL}mq:${MQ_C_VER}_${AMPQ_VER} AS mq_env
FROM ${REGISTRY_URL}ipp:${IPP_VER} AS ipp_env
FROM ${REGISTRY_URL}cuda:${CUDA_RT_VER}_${CUDA_DRIVER_VER} AS cuda_env

FROM ${REGISTRY_URL}cmake:${CMake_VER}

# LibBoost
COPY --from=boost_env /usr/local/lib/libboost* /usr/local/lib/
COPY --from=boost_env /usr/local/include/boost /usr/local/include/

# LibUHD
COPY --from=uhd_builder_env /usr/local/lib/libuhd* /usr/local/lib/
COPY --from=uhd_builder_env /usr/local/include/uhd /usr/local/include/
COPY --from=uhd_builder_env /usr/local/include/uhd.h /usr/local/include/

# RabbitMQ-C & SimpleAmqpClient
COPY --from=mq_env /usr/local/lib/*mq* /usr/local/lib/
COPY --from=mq_env /usr/local/include/ampq*.h /usr/local/include/
COPY --from=mq_env /usr/local/include/SimpleAmqpClient /usr/local/include/
COPY --from=mq_env /usr/local/include/rabbitmq-c /usr/local/include/

# IPP
COPY --from=ipp_env /opt/intel/oneapi/ipp /opt/intel/oneapi/ipp

# CUDA RT & Driver
COPY --from=cuda_env /usr/local/cuda /usr/local/cuda

RUN ldconfig && \
    apt update -y && \
    apt install libserial-dev -y