#!/bin/bash

#Script to steup raspberrypi
# Example how to run with 2 args for location name changes:
# . setup_pi.sh lyr LYR

# Update and upgrade system
#sudo apt-get update
#sudo apt-get upgrade

# Install libraries
sudo apt install gpsd gpsd-clients
sudo apt install --fix-missing gpsd gpsd-clients
sudo apt install ntp pps-tools
sudo apt install ufw network-manager
sudo apt install python3-setuptools
sudo apt install sshpass ntpdate

# Installing PIGPIO
wget https://github.com/joan2937/pigpio/archive/master.zip
unzip master.zip
cd pigpio-master
make
sudo make install
cd

# Install HDMI display tools
git clone https://github.com/waveshare/LCD-show.git

# Edit config file to setup pps signal on gpio pin 18
echo "# the next three lines are for the GPS PPS signal" | sudo tee --append /boot/config.txt
echo "dtoverlay=pps-gpio,gpiopin=18" | sudo tee --append  /boot/config.txt
echo "enable_uart=1" | sudo tee --append  /boot/config.txt
echo "init_uart_baud=9600" | sudo tee --append  /boot/config.txt
echo "pps-gpio" | sudo tee --append  /etc/modules

# Making ULF directory and installing codes
mkdir ULF
cd ULF
scp mirl-ulf@mirl-ulf.unh.edu:'~/ULF/DAQ_ACQ_copy/*' ./
sed -i "s/pi-unh-daq/pi-$1-daq/g" *
sed -i "s/UNH/$2/g" *
mkdir Data_Files

# Make shell scripts executable and compile main_acq
sudo chmod 755 *.sh
sudo make

# Moving files from ULF to proper locations
sudo mv ntp.conf /etc/

# Setup Firewall
sudo ufw allow from 132.177.207.87
