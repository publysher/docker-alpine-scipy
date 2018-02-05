#!/usr/bin/env bash

set -u
set -e

IMAGE_ROOT=publysher/alpine-numpy
IMAGE_NAME=publysher/alpine-scipy

function build() {
    version=$1
    base_image=$2

    dir=dockerfiles/${version}/${base_image}/

    image_version=${version}-numpy${base_image}
    image=${IMAGE_NAME}:${image_version}

    mkdir -p ${dir}

    cat <<EOF > ${dir}/Dockerfile
FROM ${IMAGE_ROOT}:${base_image}

RUN apk --no-cache add lapack \
    && apk --no-cache add --virtual .builddeps g++ gcc gfortran musl-dev lapack-dev \
    && pip install scipy==${version} \
    && apk del .builddeps \
    && rm -rf /root/.cache
EOF

    echo "/${dir}\t${image}" >> build-settings.txt

    docker build -t ${image} ${dir}

    cp ${dir}/Dockerfile Dockerfile     # overwrite root Dockerfile, which is used for `latest`
}

build 1.0.0 1.14.0-python3.6-alpine3.6
build 1.0.0 1.14.0-python3.6-alpine3.7

docker build -t ${IMAGE_NAME}:latest .
