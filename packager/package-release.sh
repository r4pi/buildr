#!/bin/bash

if [[ ! -d /tmp/output/raspbian-bullseye ]]; then
  mkdir -p /tmp/output/raspbian-bullseye
fi

# R 3.x requires PCRE1
pcre_lib='libpcre2-dev'
if [[ "${R_VERSION}" =~ ^3 ]]; then
  pcre_lib='libpcre3-dev'
fi

fpm \
  -s dir \
  -t deb \
  -v ${R_VERSION} \
  --iteration 2 \
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
  -p /tmp/output/raspbian-bullseye/ \
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
  -d libjpeg62-turbo \
  -d liblapack-dev \
  -d liblzma-dev \
  -d libopenblas-base \
  -d libpango-1.0-0 \
  -d libpangocairo-1.0-0 \
  -d libpaper-utils \
  -d ${pcre_lib} \
  -d libpng16-16 \
  -d libreadline8 \
  -d libtcl8.6 \
  -d libtiff5 \
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
