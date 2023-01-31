#!/bin/bash

#Script to setup raspberrypi
# Example how to run with 2 args for location name changes:
# . setup_pi.sh lyr LYR

# Update and upgrade system
sudo apt-get update
sudo apt-get upgrade

# Making ULF directory and installing codes
mkdir ULF
git clone https://github.com/cgauthier-unh/MIRL_HDMI
mv MIRL_HDMI/* ULF/
sudo rm -r MIRL_HDMI
cd ULF
sed -i "s/pi-unh-daq/pi-$1-daq/g" *
sed -i "s/UNH/$2/g" *
mkdir Data_Files

# Make shell scripts executable and compile main_acq
chmod 755 *.sh
make

# Moving files from ULF to proper locations
# sudo mv rc.local /etc/

