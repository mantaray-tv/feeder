cd /live
mkdir -p /root/.cache/vlc
http-server -p 8443 --cors -c-1 > /dev/null &
sed -i 's/geteuid/getppid/' /usr/bin/vlc
cpulimit -m -l 10 -- vlc -I dummy /test.torrent vlc://quit --sout '#http{mux=ts,dst=:8000/stream.ts}' &
while true; do ffmpeg -i http://localhost:8000/stream.ts -c copy -bsf:v h264_mp4toannexb -hls_time 10 -hls_list_size 10 -segment_wrap 10 -hls_flags delete_segments -hls_segment_filename "/live/output_%03d.ts" /live/stream.m3u8; done
