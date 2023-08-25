FROM ubuntu

LABEL org.opencontainers.image.source=https://github.com/mantaray-tv/feeder
RUN apt update -y
RUN apt install -y nodejs
RUN apt install -y npm
RUN apt install -y vlc
RUN apt install vlc-plugin-bittorrent -y
RUN apt install ffmpeg -y
RUN npm install -g http-server
RUN npm install -g peerflix
RUN mkdir /live
COPY ./index.html /live/index.html
COPY ./run.sh /run.sh
COPY ./test.torrent /test.torrent
ENTRYPOINT ["/bin/bash", "/run.sh"]
