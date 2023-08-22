mkdir -p /root/.cache/vlc
sed -i 's/geteuid/getppid/' /usr/bin/vlc
lcp --proxyUrl http://localhost:8000/
vlc -I dummy /test.torrent vlc://quit --sout '#transcode{vcodec=h264,acodec=aac,soverlay,threads=1}:std{access=http,mux=ts,dst=:8000/stream.ts}'
