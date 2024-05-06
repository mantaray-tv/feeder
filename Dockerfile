FROM ubuntu:23.04

LABEL org.opencontainers.image.source=https://github.com/mantaray-tv/feeder

RUN apt update -y
RUN apt install -y git
RUN apt install -y nodejs
RUN apt install -y npm
RUN apt install -y autoconf automake libtool make libvlc-dev libvlccore-dev libtorrent-rasterbar-dev g++ autoconf-archive
RUN git clone https://github.com/mantaray-tv/vlc-bittorrent.git vlc-bittorrent
RUN mkdir /vlc
RUN cd vlc-bittorrent && autoreconf -i && ./configure --prefix=/vlc && make && make install
RUN apt remove -y autoconf automake libtool make g++ autoconf-archive
RUN rm -rf vlc-bittorrent
RUN apt install -y ffmpeg
RUN apt install -y curl
RUN apt install -y vlc
RUN npm install -g http-server
RUN mkdir /live
COPY ./index.html /live/index.html
COPY ./run.sh /run.sh
COPY ./test.torrent /test.torrent
ENTRYPOINT ["/bin/bash", "/run.sh"]
