mkdir -p /root/.cache/vlc
iptables -A INPUT -p tcp --dport 6881:6889 -j DROP
sed -i 's/geteuid/getppid/' /usr/bin/vlc
vlc -I dummy /test.torrent --sout '#transcode{vcodec=H264,threads=1,acodec=aac,soverlay}:std{access=http,mux=ts,dst=:8080/stream.m2ts}'
