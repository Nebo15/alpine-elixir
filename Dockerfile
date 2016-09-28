FROM nebo15/alpine-erlang:latest
MAINTAINER Nebo#15 support@nebo15.com

# Configure environment variables and other settings
ENV REFRESHED_AT=2016-09-28 \
    ELIXIR_VERSION=1.3.2-r0

# Install Elixir, Git, make, g++
RUN \
    echo "@edge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk --no-cache --update add elixir@edge=$ELIXIR_VERSION git make g++ && \
    mix local.hex --force && \
    mix local.rebar --force && \
    rm -rf /var/cache/apk/*
