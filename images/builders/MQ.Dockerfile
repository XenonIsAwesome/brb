ARG Boost_VER=1.87.0
FROM boost:${Boost_VER}

ARG MQ_C_VER="master"
ARG AMPQ_VER="master"

WORKDIR /mq_c/
RUN echo "Installing rabbitmq-c:${MQ_C_VER}" && \
    apt install unzip -y && \
    wget "https://github.com/alanxz/rabbitmq-c/archive/refs/heads/${MQ_C_VER}.zip" && \
    unzip ${MQ_C_VER}.zip && \
    mkdir -p rabbitmq-c-${MQ_C_VER}/build/ && cd rabbitmq-c-${MQ_C_VER}/build/ && \
    cmake .. && cmake --build .  --target install && \
    cd / rm -r /mq_c/

WORKDIR /ampq/
RUN echo "Installing SimpleAmqpClient:${AMPQ_VER}" && \
    wget "https://github.com/alanxz/SimpleAmqpClient/archive/refs/heads/${AMPQ_VER}.zip" && \
    unzip ${AMPQ_VER}.zip && \
    mkdir -p SimpleAmqpClient-${AMPQ_VER}/build/ && cd SimpleAmqpClient-${AMPQ_VER}/build/ && \
    cmake -DCMAKE_CXX_STANDARD=11 .. && cmake --build .  --target install && \
    cd / && rm -r /ampq/

WORKDIR /

