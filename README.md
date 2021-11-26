
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
- design improvement. is more solid

---
3D model
---
[here](https://www.thingiverse.com/thing:5147344)

---
HW parts
---
- 1k potentiometer [here](https://www.tme.eu/en/details/pc16bu-1k-lin/cond-plastic-single-turn-potentiometers/omeg/)
- 7x7mm switch [here](https://www.aliexpress.com/item/32704922363.html)
- 4" HDMI Waveshare LCD 800x400 [here](https://rlx.sk/sk/9-5-lcd-display/5454-4inch-hdmi-lcd-800480-ips-waveshare-4-touch-screen-lcd-hdmi-interface-ips-screen-designed-for-raspberry-pi-12030.html)
- HDMI connector DIY [here](https://rpishop.cz/redukce/2176-waveshare-mini-hdmi-adapter-pro-diy-hdmi-kabel.html)
- MINI HDMI connector DIY [here](https://rpishop.cz/redukce/1205-waveshare-hdmi-adapter-pro-diy-hdmi-kabel-pravouhy.html)
- HDMI cable DIY [here](https://rpishop.cz/hdmi/1209-waveshare-diy-hdmi-plochy-kabel-02m.html)
- speaker [here](https://rpishop.cz/reproduktory/1204-waveshare-8-5w-reproduktor.html)
- rpi zero [here](https://rpishop.cz/zero/632-raspberry-pi-zero.html)
- audio amplifier [here](https://rlx.sk/sk/audio-voice-boards-speech-recognition/3397-mono-25w-class-d-audio-amplifier-pam8302-adafruit-2130.html)
- capacitor 2.2uF/50V
- screw M3 4x
- switch 6x6mm 2x [here](https://www.tme.eu/en/details/tact-64k/microswitches-tact/ninigi/) **watch out for the length of the button**
- micro USB connector [here](https://www.aliexpress.com/item/32916571891.html?spm=a2g0o.productlist.0.0.284c68canDNCGE&algo_pvid=d8468b46-a429-405d-a448-26761076313c&algo_exp_id=d8468b46-a429-405d-a448-26761076313c-5&pdp_ext_f=%7B%22sku_id%22%3A%2266023288418%22%7D)
- PCB with micro USB connector [here](https://www.aliexpress.com/item/4000484202812.html?spm=a2g0o.productlist.0.0.52451297eW2VB6&algo_pvid=d8623308-0e8e-433a-b8c3-d0a98947ac72&aem_p4p_detail=202111260636579663439259216280013679493&algo_exp_id=d8623308-0e8e-433a-b8c3-d0a98947ac72-9&pdp_ext_f=%7B%22sku_id%22%3A%2210000002007513401%22%7D)
- magnet circle 6x2mm

---
HW construction
---
***TODO***

---
Instalation
---
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
17. **Update permission for script**
```
sudo chmod +x /home/pi/simpsonstv/dbuscontrol.sh
```
19. **Reboot system**
```
sudo reboot
```
