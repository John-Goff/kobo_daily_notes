#!/usr/bin/env sh

# Build script for Elixir/Erlang for the Kobo architecture.

mkdir -p tmp/erl_top
git clone --branch OTP-26.2.3 --depth 1 https://github.com/erlang/otp.git tmp/erl_top
cd tmp/erl_top

ERL_TOP=$(pwd)
export ERL_TOP

./configure --host="arm-unknown-linux" --build="$(./make/autoconf/config.guess)"
make
make release RELEASE_ROOT=release
cd release
./Install -cross -minimal /mnt/onboard/.adds/kobo_daily_notes/erts/
