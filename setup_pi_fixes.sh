#!/bin/bash

#Script to steup raspberrypi
# Example how to run with 2 args for location name changes:
# . setup_pi.sh lyr LYR


# Making ULF directory and installing codes
git clone https://github.com/cgauthier-unh/MIRL_ULF
mv MIRL_ULF/* ULF/
sudo rm -r MIRL_ULF
cd ULF
sed -i "s/pi-unh-daq/pi-$1-daq/g" *
sed -i "s/UNH/$2/g" *


# Make shell scripts executable and compile main_acq
chmod 755 *.sh
make
