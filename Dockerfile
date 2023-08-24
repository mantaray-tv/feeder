FROM debian

LABEL org.opencontainers.image.source=https://github.com/mantaray-tv/feeder
RUN apt-get update -y
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN apt-get install -y vlc
RUN apt-get install vlc-plugin-bittorrent -y
RUN npm install -g local-cors-proxy
COPY ./run.sh /run.sh
COPY ./test.torrent /test.torrent
ENTRYPOINT ["/bin/bash", "/run.sh"]
