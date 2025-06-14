FROM ubuntu:18.04

RUN \
  apt update && apt upgrade -y && \
  apt install -y \
  build-essential \
  git \
  gcc-mips-linux-gnu \
  autoconf \
  pkg-config \
  libtool \
  ftp-upload \
  wget \
  unzip \
  cmake && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /root
