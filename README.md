
The original project was created by the user buba447. Manual is [here](https://withrow.io/simpsons-tv-build-guide) and source is [here](https://github.com/buba447/simpsonstv). Original 3D model is [here](https://www.thingiverse.com/thing:4943159)

Second user created new 3D model for 4" Waveshare HDMI displa. Original 3D model is [here](https://www.thingiverse.com/thing:5019648)

***MY MANUAL IS CURRENTLY INCOMPLETED. I WORKING ON IT***

My changes, all otested on the RPI ZERO:
- added pause video, when is button not pulled.
- added mudde audio amplifier if is button not pulled
- minor improvements to 3D models
- added button to 3D model VCR
- used different speaker
- used 4" HDMI waveshare LCD [here](https://www.waveshare.com/wiki/4inch_HDMI_LCD)
  
---
Instalation

1. created file **wpa_supplicant.conf** in **boot** partition before insert microSD card and added to file
```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="NETWORK NAME"
    psk="NETWORK PASSWORD"
}
```
2. Created empty file **ssh** in **boot** partition before insert microSD card
3. Now you can insert microSD card to RPI and power on. After booting is raspberry-pi automaticly connected to WI-FI
4. **Update OS**
```
sudo apt-get update
sudo apt-get upgrade
rpi-update
```
5. **LCD driver**. go to **/boot/config.txt** and add next lines for enable LCD drivers. Save, and reboot RPI. Manual for instalation manual is [here](https://www.waveshare.com/wiki/4inch_HDMI_LCD)
```
hdmi_group=2
hdmi_mode=87
hdmi_timings=480 0 40 10 80 800 0 13 3 32 0 0 0 60 0 32000000 3
dtoverlay=ads7846,cs=1,penirq=25,penirq_pull=2,speed=50000,keep_vref_on=0,swapxy=0,pmax=255,xohms=150,xmin=200,xmax=3900,ymin=200,ymax=3900
display_rotate=3
hdmi_drive=1
hdmi_force_hotplug=1
```
6. **LCD driver.** Install drivers for LCD
```
git clone https://github.com/waveshare/LCD-show.git
cd LCD-show/
chmod +x LCD4-800x480-show
./LCD4-800x480-show
```
7. **Enable audio.** added to file **/boot/config.txt**
```
dtparam=audio=on
dtoverlay=audremap,enable_jack,pins_18_19
```
8. **Enable audio.** Update file **/etc/rc.local**
```
raspi-gpio set 18 op dl
raspi-gpio set 19 op a5 
raspi-gpio set 8 a2
raspi-gpio set 7 a2
```
9. Update **/boot/cmdline.txt**
```
console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait quiet splash fbcon=map:10 fbcon=font:ProFont6x11
```
10. **Install package to OS**
```
sudo apt-get install omxplayer git mc screen
```
11. **Clone repository**
```
cd ~
git clone https://github.com/johnyHV/simpsonstv
```
12. Now we need convert video to **mp4** video format. For this exist python script encode.py stored in **~/simpsonstv/video/**. Video file you can convert on RPI (but it's very tedious and slow) or on the your computer
```
~/simpsonstv/video/
sudo python encode.py
```
13. **Copy video to RPI**. For example, you can use **scp** or **winscp**, for copy files via ssfp to RPI. Directory for video
```
~/simpsonstv/videos
```
14. **Service**. Service for management buttons
```
sudo nano /etc/systemd/system/tvbutton.service
```
and insert to file
```
[Unit]
Description=tvbutton
After=network.target

[Service]
WorkingDirectory=/home/pi/simpsonstv/
ExecStart=/usr/bin/python /home/pi/simpsonstv/buttons.py
Restart=always

[Install]
WantedBy=multi-user.target
```
15. **Service**. Service for management video player
```
sudo nano /etc/systemd/system/tvplayer.service
```
and insert to file
```
[Unit]
Description=tvplayer
After=network.target

[Service]
WorkingDirectory=/home/pi/simpsonstv/
ExecStart=/usr/bin/python /home/pi/simpsonstv/player.py
Restart=always

[Install]
WantedBy=multi-user.target
```
16. **Service**. Enable services
```
sudo systemctl enable tvbutton.service
sudo systemctl enable tvplayer.service
```
17. **Reboot system**
```
sudo reboot
```
