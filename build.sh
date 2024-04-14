#!/usr/bin/env bash

# Build script for Elixir/Erlang for the Kobo architecture.
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# First we must build an image containing the toolchain we need to build.
mkdir -p "$ROOT_DIR"/tmp/
git clone --depth 1 https://github.com/koreader/koxtoolchain.git "$ROOT_DIR"/tmp/koxtoolchain

# Next we must compile Erlang using the toolchain we just built.
mkdir -p tmp/erl_top
git clone --branch OTP-26.2.3 --depth 1 https://github.com/erlang/otp.git tmp/erl_top
cd tmp/erl_top

ERL_TOP=$(pwd)
export ERL_TOP

# We want to build in a docker container with the appropriate cross compilation toolchain already set up,
# so that we don't need to require a cross compilation toolchain on every contributor's machine.
docker pull ghcr.io/koreader/koxtoolchain:kobo-latest

# Start the container in detatched mode running sh which will wait for input, which never comes.
docker run \
    --name kobo_daily_notes_builder \
    --mount type=bind,source="$ERL_TOP",target=/home/kox/build \
    --interactive \
    --tty \
    --detatch \
    koxtoolchain:kobo-latest \
    /bin/sh

# ./configure --host="arm-unknown-linux" --build="$(./make/autoconf/config.guess)"
# make
# make release RELEASE_ROOT=release
# cd release
# ./Install -cross -minimal /mnt/onboard/.adds/kobo_daily_notes/erts/
