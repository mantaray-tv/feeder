mkdir -p /root/.cache/vlc
iptables -A INPUT -p tcp --dport 6881:6889 -j DROP
sed -i 's/geteuid/getppid/' /usr/bin/vlc
vlc -I dummy /test.torrent --sout '#transcode{vcodec=VP80,vb=4000,acodec=vorb,soverlay}:std{access=http,mux=webm,dst=:8080/stream.webm}'
