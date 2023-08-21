mkdir -p /root/.cache/vlc
sed -i 's/geteuid/getppid/' /usr/bin/vlc
vlc -I telnet /test.torrent --sout '#transcode{vcodec=H264,threads=1,acodec=aac,soverlay}:std{access=http,mux=ts,dst=:8080/stream.ts}' --avcodec-hw=none
