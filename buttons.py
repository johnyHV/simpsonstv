import RPi.GPIO as GPIO
import time
import os

os.system('raspi-gpio set 19 ip')
GPIO.setmode(GPIO.BCM)
GPIO.setup(26, GPIO.IN, pull_up_down=GPIO.PUD_UP) # button
GPIO.setup(18, GPIO.OUT)  # screen (not use with waveshare display)
GPIO.setup(13, GPIO.OUT)  # audio amplifier
GPIO.setup(6, GPIO.IN, pull_up_down=GPIO.PUD_UP) # button next video
GPIO.setup(5, GPIO.IN, pull_up_down=GPIO.PUD_UP) # power off


def turnOnScreen():
    os.system('raspi-gpio set 19 op a5')
    GPIO.output(18, GPIO.HIGH)
    os.system('/home/pi/simpsonstv/dbuscontrol.sh pause')
    GPIO.output(13, GPIO.HIGH) # unmute audio amplifier

def turnOffScreen():
    os.system('raspi-gpio set 19 ip')
    GPIO.output(18, GPIO.LOW)
    os.system('/home/pi/simpsonstv/dbuscontrol.sh pause')
    GPIO.output(13, GPIO.LOW) # mute audio amplifier

def playNextVideo():
    os.system('ps -aux | grep omxplayer | grep -v grep | awk \'{ print $2 }\' | xargs kill -9')

turnOffScreen()
screen_on = False
next_video = False

while (True):
    # If you are having and issue with the button doing the opposite of what you want
    # IE Turns on when it should be off, change this line to:
    # input = not GPIO.input(26)
    input = not GPIO.input(26)
    if input != screen_on:
        screen_on = input
        if screen_on:
            turnOnScreen()
        else:
            turnOffScreen()
    time.sleep(0.3)
    input_video = GPIO.input(6)
    if input_video != next_video:
        next_video = input_video
        if next_video:
            playNextVideo()

