su ok -c 'find /mnt2/Users/ok/Music/ -iname "*.mp3" | shuf | head > /tmp/playlist ; mplayer -playlist /tmp/playlist'
