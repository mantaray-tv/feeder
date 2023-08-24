mkdir -p /root/.cache/vlc
mkdir /live
cd /live
http-server -p 8443 --cors -c-1 &
sed -i 's/geteuid/getppid/' /usr/bin/vlc
vlc -I dummy /test.torrent vlc://quit --sout '#transcode{vcodec=h264,acodec=aac,scodec=dvbs,venc=x264{preset=ultrafast}}:http{mux=ts,dst=:8000/stream.ts}' &
while true; do ffmpeg -i http://localhost:8000/stream.ts -c copy -bsf:v h264_mp4toannexb -hls_time 10 -hls_list_size 10 -segment_wrap 10 -hls_flags delete_segments -hls_segment_filename "/live/output_%03d.ts" /live/stream.m3u8; done
