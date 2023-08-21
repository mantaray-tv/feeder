FROM ubuntu

LABEL org.opencontainers.image.source=https://github.com/mantaray-tv/feeder
RUN apt update -y
RUN apt install -y nodejs
RUN apt install -y npm
RUN apt install -y vlc
RUN apt install vlc-plugin-bittorrent -y
COPY ./run.sh /run.sh
COPY ./test.torrent /test.torrent
ENTRYPOINT ["/bin/bash", "/run.sh"]
