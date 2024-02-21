import os
import random
import time
from subprocess import PIPE, Popen, STDOUT

directory = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'videos')
last_played_file_name = "LastPlayed.txt"

def getVideos():
    videos = [os.path.join(directory, file) for file in sorted(os.listdir(directory)) if file.lower().endswith('.mp4')]
    return videos

def saveLastPlayed(video):
    with open(last_played_file_name, 'w') as file:
        file.write(video)

def getLastPlayed():
    if not os.path.exists(last_played_file_name):
        return ''
    with open(last_played_file_name, 'r') as file:
        return file.read()

def playVideos():
    videos = getVideos()
    if not videos:
        print('No videos found')
        time.sleep(5)
        return
    last_played = getLastPlayed()
    start_index = 0
    if last_played in videos:
        start_index = videos.index(last_played)
    for video in videos[start_index:]:
        saveLastPlayed(video)
        print("Current video: " + video)
        playProcess = Popen(['omxplayer', '--no-osd', '--win', '00,00,750,480', video])
        playProcess.wait()

while (True):
    playVideos()
