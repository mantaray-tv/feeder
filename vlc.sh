npm i -g peerflix && torsocks node peerflix /test.torrent --vlc -- -I dummy --sout "'#transcode{vcodec=h264,acodec=aac,soverlay,vb=6000,ab=320}:std{access=http,mux=ts,dst=:8000/stream.ts}'"
