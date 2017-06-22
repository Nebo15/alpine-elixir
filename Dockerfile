FROM nebo15/alpine-erlang:20.0
MAINTAINER Nebo#15 support@nebo15.com

# Configure environment variables and other settings
ENV REFRESHED_AT=2017-06-10 \
    LANG=en_US.UTF-8 \
    HOME=/opt/app/ \
    # Set this so that CTRL+G works properly
    TERM=xterm \
    ELIXIR_VERSION=1.4.5

WORKDIR /tmp/elixir-build

# Install Elixir
RUN set -xe; \
    ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip" && \
    # Install Elixir build deps
    apk add --no-cache --update --virtual .elixir-build \
      unzip \
      curl \
      ca-certificates && \
    # Download and validate Elixir checksum
    curl -fSL -o elixir-precompiled.zip "${ELIXIR_DOWNLOAD_URL}" && \
    unzip -d /usr/local elixir-precompiled.zip && \
    rm elixir-precompiled.zip && \
    # Install Hex and Rebar
    mix local.hex --force && \
    mix local.rebar --force && \
    cd /tmp && \
    rm -rf /tmp/elixir-build && \
    # Delete Elixir build deps
    apk del .elixir-build

WORKDIR ${HOME}

CMD ["iex"]
