#!/bin/bash

echo "Update system"
sudo apt-get update
sudo apt-get upgrade
sudo rpi-update
sudo apt-get upgrade

echo "Add LCD configuration to /boot/config.txt"
tee -a /boot/config.txt <<EOF
hdmi_group=2
hdmi_mode=87
hdmi_timings=480 0 40 10 80 800 0 13 3 32 0 0 0 60 0 32000000 3
dtoverlay=ads7846,cs=1,penirq=25,penirq_pull=2,speed=50000,keep_vref_on=0,swapxy=0,pmax=255,xohms=150,xmin=200,xmax=3900,ymin=200,ymax=3900
display_rotate=3
hdmi_drive=1
hdmi_force_hotplug=1
EOF

echo "Clone repository and install LCD driver"
git clone https://github.com/waveshare/LCD-show.git
cd LCD-show/
chmod +x LCD4-800x480-show
sudo ./LCD4-800x480-show

# EOF