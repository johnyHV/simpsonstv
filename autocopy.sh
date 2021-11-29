#!/bin/bash

loop_refresh_time="2"
dest_path="/home/pi/simpsonstv/videos"
usb_path="/simpsonstv/"
LED_PIN="27"
log_file_name="simpsontv_log.txt"

echo ${LED_PIN} > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio${LED_PIN}/direction
echo "0" > /sys/class/gpio/gpio${LED_PIN}/value

while true
do
	sleep ${loop_refresh_time}
	path=`lsblk | grep sd | awk 'NR==2{print $7}'` # check mounted sdX devices with mount path

	if [ -z "${path}" ]
	then
		echo "USB not found"
	else
		echo "Found USB drive ${path}"
		echo "1" > /sys/class/gpio/gpio${LED_PIN}/value

		if [ -d "${path}${usb_path}" ]
		then
			echo "Folder exist"
			echo "copy file from ${path}${usb_path}* to ${dest_path}"
			rsync -vah --delete-before "${path}${usb_path}" "${dest_path}" > "${path}/${log_file_name}"
		else
			echo "Folder doesn't exist"
		fi
		umount ${path}
		echo "0" > /sys/class/gpio/gpio${LED_PIN}/value
	fi
done
