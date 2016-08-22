#!/bin/sh

# path to nerves_system_rpi3_ap build directory
# see https://github.com/joelbyler/nerves_system_rpi3_ap
export NERVES_SYSTEM=~/workspaces/nerves_system_rpi3_ap/build/

# MAC address of admin connection (security feature)
export ADMIN_MAC=aa:bb:cc:dd:ee:ff

mix deps.get
mix firmware

# If necessary, copy .fw file to another place where it can be burned using fwup
# example: fwup -a -i nerves_net.fw -t complete
cp _images/rpi3/firmware.fw /media/sf_nerves_systems/nerves_net.fw

# otherwise mix firmware.burn from this directory
