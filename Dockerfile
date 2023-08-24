FROM ubuntu

LABEL org.opencontainers.image.source=https://github.com/mantaray-tv/feeder
RUN apt-get update -y
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN apt-get install -y vlc
RUN apt-get install vlc-plugin-bittorrent -y
RUN apt-get install ffmpeg -y
RUN npm install -g http-server
COPY ./run.sh /run.sh
COPY ./test.torrent /test.torrent
ENTRYPOINT ["/bin/bash", "/run.sh"]
