#!/bin/bash

set -e

# Prepare dir
CONFIG="${KAFKA_DATA_DIR}/server.properties"
touch ${CONFIG};

# Generate the config only if it doesn't exist
if [[ -f "${CONFIG}" ]]; then
  {
    echo "broker.id=$((${MY_POD_NAME##*-} + 1))"
    echo "log.dirs=${KAFKA_DATA_DIR}/topic_data"
    echo "num.partitions=${KAFKA_NUM_PARTITIONS}"
    echo "replica.lag.time.max.ms=${KAFKA_REPLICA_LAG_TIME_MAX_MS}"
    echo "group.max.session.timeout.ms=${KAFKA_GROUP_MAX_SESSION_TIMEOUT_MS}"
    echo "group.min.session.timeout.ms=${KAFKA_GROUP_MIN_SESSION_TIMEOUT_MS}"
    echo "auto.create.topics.enable=${KAFKA_AUTO_CREATE_TOPICS_ENABLE}"
    echo "compression.type=${KAFKA_COMPRESSION_TYPE}"
    echo "default.replication.factor=${KAFKA_DEFAULT_REPLICATION_FACTOR}"
    echo "delete.topic.enable=${KAFKA_DELETE_TOPIC_ENABLE}"
    echo "log.cleaner.enable=${KAFKA_LOG_CLEANER_ENABLE}"
    echo "log.cleanup.policy=${KAFKA_LOG_CLEAN_POLICY}"
    echo "log.roll.hours=${KAFKA_LOG_ROLL_HOURS}"
    echo "message.max.bytes=${KAFKA_MESSAGE_MAX_BYTES}"
    echo "num.replica.fetchers=${KAFKA_NUM_REPLICATION_FACTORS}"
    echo "offsets.topic.replication.factor=${KAFKA_OFFSETS_TOPIC_REPLIACATION_FACTOR}"
    echo "queued.max.requests=${KAFKA_QUEUED_MAX_REQUESTS}"
    echo "unclean.leader.election.enable=${KAFKA_UNCLEAN_LEADER_ELECTION_ENABLE}"
    echo "num.network.threads=${KAFKA_NUM_NETWORK_THREADS}"
    echo "num.io.threads=${KAFKA_NUM_IO_THREADS}"
    echo "socket.send.buffer.bytes=${KAFKA_SOCKET_SEND_BUFFER_BYTES}"
    echo "socket.receive.buffer.bytes=${KAFKA_SOCKET_RECEIVE_BUFFER_BYTES}"
    echo "socket.request.max.bytes=${KAFKA_SOCKET_REQUEST_MAX_BYTES}"
    echo "num.recovery.threads.per.data.dir=${KAFKA_NUM_RECOVERY_THREADS_PER_DATA_DIR}"
    echo "transaction.state.log.replication.factor=${KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR}"
    echo "transaction.state.log.min.isr=${KAFKA_TRANSACTION_STATE_LOG_MIN_ISR}"
    echo "log.flush.interval.messages=${KAFKA_LOG_FLUSH_INTERVAL_MESSAGES}"
    echo "log.flush.interval.ms=${KAFKA_LOG_FLUSH_INTERVAL_MS}"
    echo "log.retention.hours=${KAFKA_LOG_RETENTION_HOURS}"
    echo "log.retention.bytes=${KAFKA_LOG_RETENTION_BYTES}"
    echo "log.segment.bytes=${KAFKA_LOG_SEGMENT_BYTES}"
    echo "log.retention.check.interval.ms=${KAFKA_LOG_RETENSION_CHECK_INTERVAL_MS}"
    echo "zookeeper.connection.timeout.ms=${KAFKA_ZOOKEEPER_CONNECTION_TIMEOUT_MS}"
    echo "group.initial.rebalance.delay.ms=${KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS}"
  } >> "${CONFIG}"

  for cfg_extra_entry in $KAFKA_CFG_EXTRA; do
    echo "${cfg_extra_entry}" >> "${CONFIG}"
  done

  {
    echo "zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT}"
    echo "advertised.listeners=EXTERNAL://${MY_POD_IP}:9093,INTERNAL://${MY_POD_IP}:9092"
    echo "listeners=INTERNAL://:9092,EXTERNAL://:9093"
    echo "listener.security.protocol.map=INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT"
    echo "inter.broker.listener.name=INTERNAL"
  } >> "${CONFIG}"
fi

if [[ -n "$KAFKA_HEAP_OPTS" ]]; then
    sed -r -i 's/(export KAFKA_HEAP_OPTS)="(.*)"/\1="'"$KAFKA_HEAP_OPTS"'"/g' "$KAFKA_HOME/bin/kafka-server-start.sh"
fi

## change log directory to $KAFKA_DATA_DIR
sed -i "s|\${kafka.logs.dir}|${KAFKA_DATA_DIR}\/logs|g" "$KAFKA_HOME/config/log4j.properties"

exec "$@"