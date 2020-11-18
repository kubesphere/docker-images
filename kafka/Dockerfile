FROM openjdk:11-jre-slim

ARG kafka_version=2.6.0
ARG scala_version=2.13
ARG build_date=2020-11-11

LABEL ks_kafka_description="Apache Kafka" \
      ks_kafka_build-date="${build_date}" \
      ks_kafka_version="${scala_version}_${kafka_version}" \
      maintainer="spwangxp"

ENV KAFKA_VERSION=${kafka_version} \
    SCALA_VERSION=${scala_version} \
    KAFKA_HOME=/opt/kafka \
    MY_POD_NAME=kafka-0 \
    PATH=${PATH}:${KAFKA_HOME}/bin \
    KAFKA_DATA_DIR=/data/kafka \
    KAFKA_LISTENERS=PLAINTEXT://:9092 \
    KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://:9092 \
    KAFKA_ZOOKEEPER_CONNECT=127.0.0.1:2181/kafka/tmp \
    KAFKA_NUM_PARTITIONS=1 \
    KAFKA_NUM_NETWORK_THREADS=3 \
    KAFKA_NUM_IO_THREADS=8 \
    KAFKA_SOCKET_SEND_BUFFER_BYTES=102400 \
    KAFKA_SOCKET_RECEIVE_BUFFER_BYTES=102400 \
    KAFKA_SOCKET_REQUEST_MAX_BYTES=104857600 \
    KAFKA_NUM_RECOVERY_THREADS_PER_DATA_DIR=1 \
    KAFKA_OFFSETS_TOPIC_REPLIACATION_FACTOR=1 \
    KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
    KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
    KAFKA_LOG_FLUSH_INTERVAL_MESSAGES=10000 \
    KAFKA_LOG_FLUSH_INTERVAL_MS=1000 \
    KAFKA_LOG_RETENTION_HOURS=168 \
    KAFKA_LOG_RETENTION_BYTES=1073741824 \
    KAFKA_LOG_SEGMENT_BYTES=1073741824 \
    KAFKA_LOG_RETENSION_CHECK_INTERVAL_MS=300000 \
    KAFKA_ZOOKEEPER_CONNECTION_TIMEOUT_MS=6000 \
    KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
    KAFKA_REPLICA_LAG_TIME_MAX_MS=10000 \
    KAFKA_GROUP_MAX_SESSION_TIMEOUT_MS=1800000 \
    KAFKA_GROUP_MIN_SESSION_TIMEOUT_MS=6000 \
    KAFKA_AUTO_CREATE_TOPICS_ENABLE=true \
    KAFKA_COMPRESSION_TYPE=producer \
    KAFKA_LOG_CLEAN_POLICY=delete \
    KAFKA_DEFAULT_REPLICATION_FACTOR=1 \
    KAFKA_DELETE_TOPIC_ENABLE=true \
    KAFKA_LOG_CLEANER_ENABLE=true \
    KAFKA_LOG_ROLL_HOURS=168 \
    KAFKA_MESSAGE_MAX_BYTES=1073741823 \
    KAFKA_NUM_REPLICATION_FACTORS=1 \
    KAFKA_QUEUED_MAX_REQUESTS=500 \
    KAFKA_UNCLEAN_LEADER_ELECTION_ENABLE=false \
    KAFKA_EXTERNAL_ACCESS=false \
    JMX_PORT=9999

# Add a user with an explicit UID/GID and create necessary directories
RUN set -eux; \
    groupadd -r kafka --gid=1000; \
    useradd -r -g kafka --uid=1000 kafka; \
    mkdir -p ${KAFKA_DATA_DIR}/logs ${KAFKA_DATA_DIR}/topic_data; \
    chown -R kafka:kafka ${KAFKA_DATA_DIR}

# Install required packges
RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        dirmngr \
        gosu \
        gnupg \
        netcat \
        wget; \
    rm -rf /var/lib/apt/lists/* \
# Verify that gosu binary wor; \
    gosu nobody true

COPY start_kafka.sh kafka_entrypoint.sh /usr/bin/

RUN chmod a+x /usr/bin/*.sh; \
    FILENAME="kafka_${SCALA_VERSION}-${KAFKA_VERSION}"; \
    url="https://mirror.bit.edu.cn/apache/kafka/${KAFKA_VERSION}/${FILENAME}.tgz"; \
    wget "${url}" -O "/tmp/${FILENAME}.tgz"; \
    tar xfz /tmp/${FILENAME}.tgz -C /opt; \
    ln -s /opt/${FILENAME} ${KAFKA_HOME}; \
    chown -R kafka:kafka ${KAFKA_HOME} /opt/${FILENAME}; \
    rm -rf /tmp/*

EXPOSE 9092 9093

WORKDIR $KAFKA_HOME
VOLUME ["${KAFKA_DATA_DIR}"]
USER 1000
ENTRYPOINT ["/usr/bin/kafka_entrypoint.sh"]
# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start_kafka.sh"]