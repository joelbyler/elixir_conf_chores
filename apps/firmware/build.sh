#!/bin/sh

#export NERVES_SYSTEM=~/Workspaces/nerves_systems/nerves_system_rpi3_ap
export NERVES_SYSTEM=/home/joel/workspaces/nerves_system_rpi3_ap/build/
#. ~/workspaces/nerves_system_rpi3_ap/build/nerves-env.sh
echo $NERVES_SYSTEM

export ADMIN_MAC=ac:bc:32:ad:01:41

mix deps.get
mix compile
mix firmware
# mix firmware.burn

cp _images/rpi3/firmware.fw /media/sf_nerves_systems/nerves_net.fw
