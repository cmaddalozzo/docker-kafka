Kafka in Docker
===

This repository provides everything you need to run Kafka in Docker.

For convenience also contains a packaged proxy that can be used to get data from
a legacy Kafka 7 cluster into a dockerized Kafka 8.

Why?
---
The main hurdle of running Kafka in Docker is that it depends on Zookeeper.
Compared to other Kafka docker images, this one runs both Zookeeper and Kafka
in the same container. This means:

* No dependency on an external Zookeeper host, or linking to another container
* Zookeeper and Kafka are configured to work together out of the box

Run
---

```bash
docker run -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=localhost --env ADVERTISED_PORT=9092 --env KAFKA_CREATE_TOPICS='test-topic:1:3' tractableio/kafka
```

```bash
export KAFKA=localhost:9092
kafka-console-producer.sh --broker-list $KAFKA --topic test
```

```bash
export KAFKA=localhost:2181
kafka-console-consumer.sh --zookeeper $ZOOKEEPER --topic test
```


Automatically create topics
---

You can create topics on startup. This is useful for adding topics that are used in automated tests so the test will run quicker and will not fail due to timeout.

Follows the same format as [wurstmeister/kafka](https://github.com/wurstmeister/kafka-docker#automatically-create-topics).

Public Build
---

https://registry.hub.docker.com/u/tractabeio/kafka/

Build from Source
---

    docker build -t tractableio/kafka .

