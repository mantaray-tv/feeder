cd /live
mkdir -p /root/.cache/vlc
sed -i 's/geteuid/getppid/' /usr/bin/vlc
VLC_PLUGIN_PATH=/vlc/lib vlc --no-plugins-cache /test.torrent -I dummy --sout '#transcode{vcodec=h264,acodec=aac,soverlay,vb=6000,ab=320}:std{access=http,mux=ts,dst=:8000/stream.ts}' &
http-server -p 8443 --cors -c-1 &
while true; do
    echo "Waiting for stream"
    ffmpeg -i http://127.0.0.1:8000/stream.ts -c:v copy -c:a copy -hls_time 0.5 -hls_list_size 10 -segment_wrap 10 -hls_flags delete_segments -hls_segment_filename "/live/output_%03d.ts" /live/stream.m3u8
    if [ $? -eq 0 ]; then
        break
    fi
    sleep 0.5
done
