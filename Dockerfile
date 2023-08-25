FROM ubuntu

LABEL org.opencontainers.image.source=https://github.com/mantaray-tv/feeder

RUN apt update -y
RUN apt install -y software-properties-common
RUN add-apt-repository universe -y
RUN apt update -y
RUN apt install -y nodejs
RUN apt install -y npm
RUN apt install -y vlc
# RUN apt install vlc-plugin-bittorrent -y
RUN apt install ffmpeg -y
RUN apt install -y tor
RUN apt install -y torsocks
RUN apt install -y curl
RUN apt upgrade -y
# RUN npm install -g http-server
RUN npm install -g peerflix
RUN npm install -g local-cors-proxy
RUN mkdir /live
COPY ./index.html /live/index.html
COPY ./run.sh /run.sh
COPY ./test.torrent /test.torrent
COPY ./torrc /etc/tor/torrc
COPY ./torsocks.conf /etc/tor/torsocks.conf
ENTRYPOINT ["/bin/bash", "/run.sh"]
