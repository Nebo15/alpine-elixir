FROM nebo15/alpine-erlang:25.3

# Important! Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2023-04-04

# List of available builds SHA256 could be found at: 
# https://github.com/hexpm/bob/blob/master/README.md#elixir-builds
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    # Set this so that CTRL+G works properly
    TERM=xterm \
    HOME=/opt/app/ \
    ELIXIR_VERSION=1.14.4 \
    ELIXIR_DOWNLOAD_SHA256=1a620e15b8ee5870a9b32b5d1fc10670dc9dafffd922ab1e08b656390a3d67ec

WORKDIR /tmp/elixir-build

# Install Elixir
RUN set -xe; \
    OTP_MAJOR_VERSION=${OTP_VERSION%%\.*} && \
    ELIXIR_DOWNLOAD_URL="https://repo.hex.pm/builds/elixir/v${ELIXIR_VERSION#*@}-otp-${OTP_MAJOR_VERSION#*@}.zip" && \
    # Install Elixir build deps
    apk add --no-cache --update --virtual .elixir-build \
      unzip \
      curl \
      ca-certificates && \
    # Download and validate Elixir checksum
    curl -fSL -o elixir-precompiled.zip "${ELIXIR_DOWNLOAD_URL}" && \
    # sha256sum elixir-precompiled.zip && exit 1 && \
    echo "${ELIXIR_DOWNLOAD_SHA256}  elixir-precompiled.zip" | sha256sum -c - && \
    unzip -d /usr/local elixir-precompiled.zip && \
    rm elixir-precompiled.zip && \
    # Install Hex and Rebar
    mix local.hex --force && \
    mix local.rebar --force && \
    cd /tmp && \
    rm -rf /tmp/elixir-build && \
    # Delete Elixir build deps
    apk del .elixir-build

# Install git (common for dependencies fetching) and make (common for dependencies building)
RUN apk add --no-cache --update git make

WORKDIR ${HOME}

CMD ["iex"]
