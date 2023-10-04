FROM bjing/haskell-dev-container:ghc-8.10.7 as system_deps

USER root
WORKDIR /tmp

# system_deps args
ARG IOHK_LIBSODIUM_GIT_REV=66f017f16633f2060db25e17c170c2afa0f2a8a1
ARG IOKH_LIBSECP251_GIT_REV=ac83be33d0956faf6b7f61a60ab524ef7d6a473a

# development dependencies
RUN apt-get update -y && apt-get install -y \
  wget \
  xz-utils \
  automake \
  build-essential \
  g++\
  libicu-dev \
  libffi-dev \
  libgmp-dev \
  libncursesw6 \
  libpq-dev \
  libssl-dev \
  libsystemd-dev \
  libtinfo-dev \
  libtool \
  make \
  pkg-config \
  zlib1g-dev libreadline-dev llvm libnuma-dev \
  && rm -rf /var/lib/apt/lists/*

# install secp2561k library with prefix '/'
RUN git clone https://github.com/bitcoin-core/secp256k1 &&\
  cd secp256k1 \
  && git fetch --all --tags &&\
  git checkout ${IOKH_LIBSECP251_GIT_REV} \
  && ./autogen.sh && \
  ./configure --prefix=/usr --enable-module-schnorrsig --enable-experimental && \
  make && \
  make install && cd .. 

# install libsodium from sources with prefix '/'
RUN git clone https://github.com/input-output-hk/libsodium.git &&\
  cd libsodium \
  && git fetch --all --tags &&\
  git checkout ${IOHK_LIBSODIUM_GIT_REV} \
  && ./autogen.sh && \
  ./configure --prefix=/usr && \
  make && \
  make install  && cd .. && rm -rf ./libsodium

FROM system_deps as cardano_cli

# install cardano-cli (we use a different docker container for the actual node)
# (These have to be the same version as the cardano-node image specified at `docker-compose.yml`)
RUN wget https://github.com/rober-m/cardano-node/releases/download/1.35.5/$(arch)-linux-cardano-cli
RUN chmod +x $(arch)-linux-cardano-cli
RUN mv $(arch)-linux-cardano-cli /usr/bin/cardano-cli

USER code
WORKDIR /home/code/app

CMD sleep infinity