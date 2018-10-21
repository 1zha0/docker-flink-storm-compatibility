#!/bin/bash

set -o pipefail -e

# TEMPLATES
# Dockerfile.flink-storm-compatibility.tpl

FLINK_VERSIONS=(1.5.4-2.11--alpine 1.5.4-2.11-hadoop24-alpine 1.5.4-2.11-hadoop26-alpine 1.5.4-2.11-hadoop27-alpine 1.5.4-2.11-hadoop28-alpine 1.6.1-2.11--alpine 1.6.1-2.11-hadoop24-alpine 1.6.1-2.11-hadoop26-alpine 1.6.1-2.11-hadoop27-alpine 1.6.1-2.11-hadoop28-alpine )

MAVEN_REPO="http:\/\/central.maven.org\/maven2"

gen_dockerfile() {
  DOCKERFILE_TEMPLATE="Dockerfile.flink-storm-support.tpl"

  if [ -z "${HADOOP_VERSION}" ]; then
    HADOOP_VERSION="hadoopfree"
    FLINK_DOCKER_VERSION="${FLINK_VERSION}-scala_${SCALA_VERSION}-${OS_VERSION}"
  else
    FLINK_DOCKER_VERSION="${FLINK_VERSION}-${HADOOP_VERSION}-scala_${SCALA_VERSION}-${OS_VERSION}"
  fi

  DOCKERFILE_TARGET="${FLINK_VERSION}/scala_${SCALA_VERSION}/${HADOOP_VERSION}/Dockerfile"
  DOCKERFILE_TARGET_DIR="$(dirname ${DOCKERFILE_TARGET})"

  echo -en "Generating Dockerfile for ${FLINK_VERSION}-${HADOOP_VERSION}-scala_${SCALA_VERSION}.. "
  if [ ! -r ${DOCKERFILE_TEMPLATE} ]; then
    echo "failed"
    echo "Missing Dockerfile template ${DOCKERFILE_TEMPLATE}"
    exit 1
  fi

  # create target dockerfile dir
  if [ ! -e ${DOCKERFILE_TARGET_DIR} ]; then
    mkdir -p ${DOCKERFILE_TARGET_DIR}
  fi

  sed "s/%FLINK_DOCKER_VERSION%/${FLINK_DOCKER_VERSION}/g;
       s/%FLINK_VERSION%/${FLINK_VERSION}/g;
       s/%SCALA_VERSION%/${SCALA_VERSION}/g;
       s/%FLINK_VERSION%/${FLINK_VERSION}/g;
       s/%MAVEN_REPO%/${MAVEN_REPO}/g;" \
    ${DOCKERFILE_TEMPLATE} > ${DOCKERFILE_TARGET} && \
  echo "done" || \
  echo "failed"
}

for version in ${FLINK_VERSIONS[@]}; do
  FLINK_VERSION=$(echo $version | cut -d- -f1)
  SCALA_VERSION=$(echo $version | cut -d- -f2)
  HADOOP_VERSION=$(echo $version | cut -d- -f3)
  OS_VERSION=$(echo $version | cut -d- -f4)

  gen_dockerfile

done

echo -n "Generating symlinks for current versions.. "
latest=$(echo "${FLINK_VERSIONS[@]}" | tr ' ' '\n\' | cut -d- -f1 | uniq | sort -n | tail -n1)
[ -e current ] && rm current || true
ln -s ${latest} current
echo "done"
