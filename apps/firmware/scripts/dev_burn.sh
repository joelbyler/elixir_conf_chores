#!/bin/bash
set -e

# export MIX_ENV=prod
export MIX_TARGET=rpi3_ap
export MIX_ENV=prod

mix deps.clean --all
mix deps.get
mix firmware
mix firmware.burn
