cd /live
mkdir -p /root/.cache/vlc
# http-server -p 8443 --cors -c-1 &
~/.global-npm/bin/lcp --proxyUrl http://localhost:8000/ --port 8443 &
tor &
while true; do
    echo "Waiting for tor to start"
    curl --socks5-hostname localhost:9050 -s https://check.torproject.org/ | grep -m 1 Congratulations
    if [ $? -eq 0 ]; then
        break
    fi
done
sed -i 's/geteuid/getppid/' /usr/bin/vlc
torsocks ~/.global-npm/bin/peerflix /test.torrent --vlc -- -I dummy vlc://quit --sout "'#transcode{vcodec=VP80,acodec=vorb,soverlay}:std{access=http,mux=webm,dst=:8000/stream.webm}'" &
# torsocks peerflix /test.torrent vlc -I dummy vlc://quit --sout '#std{access=http,mux=ts,dst=:8000/stream.ts}' &
# while true; do
#     echo "Waiting for stream"
#     ffmpeg -i http://127.0.0.1:8000/stream.ts -c copy -c:v libx264 -hls_time 10 -hls_list_size 10 -segment_wrap 10 -hls_flags delete_segments -hls_segment_filename "/live/output_%03d.ts" /live/stream.m3u8
#     if [ $? -eq 0 ]; then
#         break
#     fi
# done
