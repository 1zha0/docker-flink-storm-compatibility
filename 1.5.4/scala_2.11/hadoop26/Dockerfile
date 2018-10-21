# AlpineLinux with a glibc-%GLIBC_VERSION%, Python %PYTHON_VERSION%, and Oracle Java %JVM_MAJOR%
FROM flink:1.5.4-hadoop26-scala_2.11-alpine

MAINTAINER Liang Zhao <alpha.roc@gmail.com>

# Flink Version and other ENV
ENV FLINK_VERSION=1.5.4 \
    SCALA_VERSION=2.11 \
    FLINK_HOME=/opt/flink \
    MAVEN_REPO=http://central.maven.org/maven2

# do all in one step
RUN set -ex && \
    apk -U upgrade && \
    apk add curl && \
    curl ${MAVEN_REPO}/org/apache/flink/flink-storm_${SCALA_VERSION}/${FLINK_VERSION}/flink-storm_${SCALA_VERSION}-${FLINK_VERSION}.jar -o ${FLINK_HOME}/lib/flink-storm_${SCALA_VERSION}-${FLINK_VERSION}.jar && \
    curl ${MAVEN_REPO}/org/apache/flink/flink-storm_${SCALA_VERSION}/${FLINK_VERSION}/flink-storm_${SCALA_VERSION}-${FLINK_VERSION}.pom -o /tmp/flink-storm.pom && \
    STORM_CORE_VERSION=$(cat /tmp/flink-storm.pom | grep -A1 -E "storm-core" | grep -Eo '(\<version\>)[^<]+' | cut -d\> -f2 | xargs) && \
    curl ${MAVEN_REPO}/org/apache/storm/storm-core/${STORM_CORE_VERSION}/storm-core-${STORM_CORE_VERSION}.jar -o ${FLINK_HOME}/lib/storm-core-${STORM_CORE_VERSION}.jar && \
    JSON_SIMPLE_VERSION=$(cat /tmp/flink-storm.pom | grep -A1 -E "json-simple" | grep -Eo '(\<version\>)[^<]+' | cut -d\> -f2 | xargs) && \
    curl ${MAVEN_REPO}/com/googlecode/json-simple/json-simple/${JSON_SIMPLE_VERSION}/json-simple-${JSON_SIMPLE_VERSION}.jar -o ${FLINK_HOME}/lib/json-simple-${JSON_SIMPLE_VERSION}.jar && \
    apk del curl && \
    rm -rf /tmp/*

# EOF
