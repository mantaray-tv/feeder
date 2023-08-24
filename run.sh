cd /live
mkdir -p /root/.cache/vlc
http-server -p 8443 --cors -c-1 &
until $(curl --output /dev/null --silent --max-filesize 1024 --fail http://localhost:8443); do
    printf '.'
    sleep 1
done
sed -i 's/geteuid/getppid/' /usr/bin/vlc
cpulimit -m -l 10 -- vlc -I dummy /test.torrent vlc://quit --sout '#transcode{vcodec=h264,acodec=aac,scodec=dvbs,venc=x264{preset=ultrafast}}:http{mux=ts,dst=:8000/stream.ts}' &
until $(curl --output /dev/null --silent --max-filesize 1024 --fail http://localhost:8000/stream.ts); do
    printf '.'
    sleep 1
done
cpulimit -m -l 5 -- ffmpeg -i http://localhost:8000/stream.ts -c copy -bsf:v h264_mp4toannexb -hls_time 10 -hls_list_size 10 -segment_wrap 10 -hls_flags delete_segments -hls_segment_filename "/live/output_%03d.ts" /live/stream.m3u8 &
