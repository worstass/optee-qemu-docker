FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive
ENV OPTEE_VERSION 3.4.0
WORKDIR /opt
RUN apt update && \
 apt install -y --no-install-recommends \
  adb \
  acpica-tools \
  autoconf \
  automake \
  bc \
  bison \
  build-essential \
  ccache \
  cscope \
  curl \
  device-tree-compiler \
  e2tools \
  expect \
  fastboot \
  flex \
  ftp-upload \
  gdisk \
  libattr1-dev \
  libcap-dev \
  libfdt-dev \
  libftdi-dev \
  libglib2.0-dev \
  libgmp3-dev \
  libhidapi-dev \
  libmpc-dev \
  libncurses5-dev \
  libpixman-1-dev \
  libslirp-dev \
  libssl-dev \
  libtool \
  libusb-1.0-0-dev \
  make \
  mtools \
  netcat \
  ninja-build \
  python3-cryptography \
  python3-pip \
  python3-pyelftools \
  python3-serial \
  python-is-python3 \
  rsync \
  swig \
  unzip \
  uuid-dev \
  xdg-utils \
  xterm \
  xz-utils \
  zlib1g-dev && \
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo
RUN echo EOF > cleanup.sh
#!/bin/sh

EOF

RUN mkdir repo && \
    cd repo && \
    repo init -u https://github.com/OP-TEE/manifest.git -m qemu_v8.xml -b ${OPTEE_VERSION} && \
    repo sync -j`nproc` && \
    rm -rf .repo && \
    cd build && \
    make toolchains -j `nproc` && \
    CFG_TEE_TA_LOG_LEVEL=3 make -j `nproc` 
    
RUN mkdir logs
RUN mkdir shared
