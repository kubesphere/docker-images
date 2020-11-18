FROM openjdk:11-jre-slim

ARG cmak_version=3.0.0.5

LABEL cmak_description="Cluster Manager for Apache Kafka: kafka-manager" \
      cmak_version="${cmak_version}" \
      maintainer="spwangxp"

ENV CMAK_HOME=/opt/cmak \
    PATH=${PATH}:${CMAK_HOME}/bin \
    ZK_HOSTS=127.0.0.1:2181/kafka/tmp \
    KAFKA_MANAGER_AUTH_ENABLED=false \
    KAFKA_MANAGER_USERNAME=admin \
    KAFKA_MANAGER_PASSWORD=password

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
        unzip \
        wget; \
    rm -rf /var/lib/apt/lists/* \
# Verify that gosu binary wor; \
    gosu nobody true

# Add a user with an explicit UID/GID and create necessary directories
RUN set -eux; \
    groupadd -r kafka --gid=1000; \
    useradd -r -g kafka --uid=1000 kafka

RUN url="https://github.com/yahoo/CMAK/releases/download/${cmak_version}/cmak-${cmak_version}.zip"; \
    wget "${url}" -O "/tmp/cmak-${cmak_version}.zip"; \
    unzip -q /tmp/cmak-${cmak_version}.zip -d /opt; \
    ln -s /opt/cmak-${cmak_version} ${CMAK_HOME}; \
    chown -R kafka:kafka /opt/cmak-${cmak_version} ${CMAK_HOME}; \
    rm -rf /tmp/*

EXPOSE 9000
WORKDIR ${CMAK_HOME}
USER 1000
ENTRYPOINT ["/opt/cmak/bin/cmak -Dconfig.file=/opt/cmak/conf/application.conf"]
