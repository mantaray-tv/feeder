mkdir -p /root/.cache/vlc
sed -i 's/geteuid/getppid/' /usr/bin/vlc
lcp --proxyUrl http://localhost:8000/ &
vlc -I dummy /test.torrent vlc://quit --sout '#transcode{vcodec=h264,venc=x264{preset=ultrafast},acodec=mp3,soverlay}:std{access=http,mux=ts,dst=:8000/stream.ts}'  --avcodec-hw=none --no-audio
