#!/bin/bash

echo "Enable audio"
tee -a /boot/config.txt <<EOF
dtparam=audio=on
dtoverlay=audremap,enable_jack,pins_18_19
EOF

tee -a /boot/config.txt <<EOF
raspi-gpio set 18 op dl
raspi-gpio set 19 op a5 
raspi-gpio set 8 a2
raspi-gpio set 7 a2
EOF

echo "Install package"
sudo apt-get install omxplayer git mc screen rsync

echo "Copy services"
sudo cp simpsonstv/services/tvbutton.service /etc/systemd/system/tvbutton.service
sudo cp simpsonstv/services/tvplayer.service /etc/systemd/system/tvplayer.service
sudo chmod +x /home/pi/simpsonstv/dbuscontrol.sh
sudo cp simpsonstv/services/tvautocopy.service /etc/systemd/system/tvautocopy.service
sudo chmod +x /home/pi/simpsonstv/autocopy.sh

echo "Enable services"
sudo systemctl enable tvbutton.service
sudo systemctl enable tvplayer.service
sudo systemctl enable tvautocopy.service

echo "Done. Please reboot OS"

# EOF