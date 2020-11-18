#!/bin/bash -e

exec "${KAFKA_HOME}/bin/kafka-server-start.sh" "${KAFKA_DATA_DIR}/server.properties"
