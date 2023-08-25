cd /live
mkdir -p /root/.cache/vlc
http-server -p 8443 --cors -c-1 &
tor &
while true; do
    echo "Waiting for tor to start"
    curl --socks5-hostname localhost:9050 -s https://check.torproject.org/ | grep -m 1 Congratulations
    if [ $? -eq 0 ]; then
        break
    fi
done
sed -i 's/geteuid/getppid/' /usr/bin/vlc
torsocks vlc -I dummy /test.torrent vlc://quit --sout '#transcode{vcodec=h264,scale=Auto,acodec=aac,scodec=dvbs}:std{access=http,mux=ts,dst=:8000/stream.ts}' &
while true; do
    echo "Waiting for stream"
    ffmpeg -i http://127.0.0.1:8000/stream.ts -c copy -bsf:v h264_mp4toannexb -hls_time 10 -hls_list_size 10 -segment_wrap 10 -hls_flags delete_segments -hls_segment_filename "/live/output_%03d.ts" /live/stream.m3u8
    if [ $? -eq 0 ]; then
        break
    fi
done
