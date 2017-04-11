FROM nebo15/alpine-erlang:19.1.0-r0-3.5
MAINTAINER Nebo#15 support@nebo15.com

# Configure environment variables and other settings
ENV REFRESHED_AT=2017-04-11 \
    ELIXIR_VERSION=1.4.2-r0

# Install Elixir and git
RUN \
    echo "@edge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk --no-cache --update add elixir@edge=$ELIXIR_VERSION git && \
    mix local.hex --force && \
    mix local.rebar --force && \
    rm -rf /var/cache/apk/*
