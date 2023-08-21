mkdir -p /root/.cache/vlc
iptables -A INPUT -p tcp --dport 6881:6889 -j DROP
sed -i 's/geteuid/getppid/' /usr/bin/vlc
vlc -I dummy /test.torrent --sout '#transcode{vcodec=theo,vb=5000,acodec=vorbis,soverlay}:std{access=http,mux=ogg,dst=:8080/stream.ogg}'
