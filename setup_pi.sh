#!/bin/bash

#Script to steup raspberrypi
# Example how to run with 2 args for location name changes:
# sudo . setup_pi.sh lyr LYR

# Update and upgrade system
apt-get update
apt-get upgrade

# Install libraries
apt install git
apt install gpsd gpsd-clients
apt install --fix-missing gpsd gpsd-clients
apt install ntp
apt install ufw
apt install python3-setuptools
apt install sshpass

# Installing PIGPIO
wget https://github.com/joan2937/pigpio/archive/master.zip
unzip master.zip
cd pigpio-master
make
make install
cd

# Edit config file to setup pps signal on gpio pin 18
echo "# the next three lines are for the GPS PPS signal" >> /boot/config.txt
echo "dtoverlay=pps-gpio,gpiopin=18" >> /boot/config.txt
echo "enable_uart=1" >> /boot/config.txt
echo "init_uart_baud=9600" >> /boot/config.txt
echo "pps-gpio" >> /etc/modules

# Making ULF directory and installing codes
mkdir ULF
git clone https://github.com/cgauthier-unh/MIRL_ULF
mv MIRL_ULF/* ULF/
rm -r MIRL_ULF
cd ULF
sed -i "s/pi-unh-daq/pi-$1-daq/g" *
sed -i "s/UNH/$2/g" *
mkdir Data_Files

# Make shell scripts executable and compile main_acq
chmod 755 *.sh
make

# Moving files from ULF to proper locations
mv pigs_output.txt ../
mv ntp.conf /etc/
mv rc.local /etc/

# Authenticating MIRL server host
sshpass -p "mirlmirl" mirl-ulf@132.177.207.87

# Setup Firewall
ufw allow from 132.177.207.87
