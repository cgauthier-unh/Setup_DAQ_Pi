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
sed -i "s/pi-unh-hdmi/pi-$1-hdmi/g" *
sed -i "s/pi-unh-hdmi/pi-$1-hdmi/g" *.py
sed -i "s/UNH/$2/g" *
sed -i "s/UNH/$2/g" *.py

mkdir Data_Files
mv ULF-UNH*.txt Data_Files/

# Make shell scripts executable and compile main_acq
chmod 755 *.sh
make

# Moving files from ULF to proper locations
# sudo mv rc.local /etc/

# Installing python libraries
pip3 install matplotlib
pip3 install -U numpy
sudo apt-get install libatlas-base-dev


echo "Testing Python Codes"

python3 make_spec_and_time_xy.py pph ULF-UNH-20230105_2000.txt
