#!/bin/bash
ZOOKEEPER_CONNECT=localhost:2181

if [[ -z "$START_TIMEOUT" ]]; then
    START_TIMEOUT=600
fi

start_timeout_exceeded=false
count=0
step=10
while netstat -lnt | awk '$4 ~ /:'$ADVERTISED_PORT'$/ {exit 1}'; do
    echo "waiting for kafka to be ready"
    sleep $step;
    count=$(expr $count + $step)
    if [ $count -gt $START_TIMEOUT ]; then
        start_timeout_exceeded=true
        break
    fi
done

if $start_timeout_exceeded; then
    echo "Not able to auto-create topic (waited for $START_TIMEOUT sec)"
    exit 1
fi

if [[ -n $KAFKA_CREATE_TOPICS ]]; then
    IFS=','; for topicToCreate in $KAFKA_CREATE_TOPICS; do
        echo "creating topics: $topicToCreate"
        IFS=':' read -a topicConfig <<< "$topicToCreate"
        if [ ${topicConfig[3]} ]; then
          JMX_PORT='' $KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER_CONNECT --replication-factor ${topicConfig[2]} --partitions ${topicConfig[1]} --topic "${topicConfig[0]}" --config cleanup.policy="${topicConfig[3]}" --if-not-exists
        else
          JMX_PORT='' $KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER_CONNECT --replication-factor ${topicConfig[2]} --partitions ${topicConfig[1]} --topic "${topicConfig[0]}" --if-not-exists
        fi
    done
fi
