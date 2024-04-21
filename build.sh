#!/usr/bin/env bash

## build.sh
#
# Builds Erlang, Elixir, and any NIFs for the Kobo architecture, and creates an Elixir release
# ready for copying to the Kobo.

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ERLANG_VERSION=26.2.3

# We want to build in a podman container with the appropriate cross compilation toolchain already
# set up, so that we don't need to require a cross compilation toolchain on every contributor's
# machine. The podman container must first be built:
mkdir -p "$ROOT_DIR"/tmp/
git clone --depth 1 https://github.com/koreader/koxtoolchain.git "$ROOT_DIR"/tmp/koxtoolchain
"$ROOT_DIR"/tmp/koxtoolchain/buildah-koxtoolchain.sh kobo

# Next we must compile Erlang using the toolchain we just built.
git clone --branch "OTP-$ERLANG_VERSION" --depth 1 https://github.com/erlang/otp.git "$ROOT_DIR"/tmp/erlang

ERL_TOP="$ROOT_DIR/tmp/erlang"
export ERL_TOP

# Start the container in detatched mode running sh which will wait for input, which never comes.
podman run \
    --name kobo_daily_notes_builder \
    --mount type=bind,source="$ERL_TOP",destination=/home/kox/build \
    --interactive \
    --tty \
    --detatch \
    koxtoolchain:kobo-latest \
    /bin/sh

# First we must build the Erlang bootstrap system. This is the minimal amount of Erlang required to
# cross compile Erlang for another platform.
podman exec \
    --interactive \
    --tty \
    --detatch \
    --working-directory /home/kox/build \
    kobo_daily_notes_builder \
    ./configure --enable-bootstrap-only

# Same args as the above, we'll just use the short version from now on.
podman exec -itd -w /home/kox/build \
    kobo_daily_notes_builder \
    make

# Now we can go about cross compiling for our Kobo
podman exec -itd -w /home/kox/build \
    kobo_daily_notes_builder \
    ./configure --host="arm-kobo-linux-gnueabihf" --build="$(./make/autoconf/config.guess)"

podman exec -itd -w /home/kox/build \
    kobo_daily_notes_builder \
    make

release_dir="otp-$ERLANG_VERSION-linux-arm"

podman exec -itd -w /home/kox/build \
    kobo_daily_notes_builder \
    make release RELEASE_ROOT="release/$release_dir"

podman exec -itd -w /home/kox/build/release/"$release_dir" \
    kobo_daily_notes_builder \
    ./Install -cross -minimal /mnt/onboard/.adds/kobo_daily_notes/erts/

podman exec -itd -w /home/kox/build/release \
    kobo_daily_notes_builder \
    tar -czvf "OTP-$ERLANG_VERSION".tar.gz "$release_dir"
