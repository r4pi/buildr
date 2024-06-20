#!/bin/bash

set -euo pipefail

source /etc/os-release
if [ "$VERSION_CODENAME" != "noble" ]; then
    echo "Error: wrong OS version. Check and try again"
    exit 100
fi

R_VERSION=${1:-default}
ITERATION=${2:-default}

function usage() {
    echo "Usage: $(basename $0) R_VERSION ITERATION"
    exit 1
}


if [ "${R_VERSION}" == "default" ]; then
    usage
fi

if [ "${ITERATION}" == "default" ]; then
    usage
fi

OUTPUT_PATH="/tmp/output/raspbian-$(source /etc/os-release && echo -n $VERSION_CODENAME)"
if [[ ! -d $OUTPUT_PATH ]]; then
  mkdir -p $OUTPUT_PATH
fi

./path-checks.py

fpm \
  -s dir \
  -t deb \
  -v ${R_VERSION} \
  --iteration ${ITERATION} \
  -n r-release \
  --vendor "r4pi.org" \
  --deb-priority "optional" \
  --deb-field 'Bugs: https://github.com/r4pi/buildr/issues' \
  --url "http://www.r-project.org/" \
  --description "GNU R statistical computation and graphics system" \
  --maintainer "r4pi.org https://r4pi.org" \
  --license "GPL-2" \
  --conflicts "r-base" \
  --conflicts "r-base-core" \
  -p $OUTPUT_PATH \
  -d g++ \
  -d gcc \
  -d gfortran \
  -d libbz2-dev \
  -d libblas-dev \
  -d libc6 \
  -d libcairo2 \
  -d libcurl4 \
  -d libglib2.0-0 \
  -d libgomp1 \
  -d libicu-dev \
  -d libjpeg-turbo8 \
  -d liblapack-dev \
  -d liblzma-dev \
  -d libopenblas0 \
  -d libpango-1.0-0 \
  -d libpangocairo-1.0-0 \
  -d libpaper-utils \
  -d libpcre2-dev \
  -d libpng16-16 \
  -d libreadline8 \
  -d libtcl8.6 \
  -d libtiff6 \
  -d libtk8.6 \
  -d libx11-6 \
  -d libxt6 \
  -d make \
  -d pandoc \
  -d ucf \
  -d unzip \
  -d zip \
  -d zlib1g-dev \
  ./src-release/=/
