FROM ubuntu:23.04

LABEL org.opencontainers.image.source=https://github.com/mantaray-tv/feeder

RUN apt update -y
RUN apt install vlc-plugin-bittorrent -y
RUN apt install -y tor
# RUN apt install -y git
RUN apt install -y nodejs
RUN apt install -y npm
# RUN git clone https://github.com/mafintosh/peerflix.git
# RUN cd peerflix && npm install
# RUN cd ..
# RUN apt install -y git
# RUN git clone https://git.torproject.org/tor.git
# RUN apt install -y autoconf automake libtool gcc libevent-dev libssl-dev zlib1g-dev
# RUN cd tor && bash ./autogen.sh && ./configure --disable-asciidoc && make && make install
# RUN cd .. && rm -rf tor
RUN apt install -y torsocks
# RUN git clone https://gitlab.torproject.org/tpo/core/torsocks.git
# RUN cd torsocks && bash ./autogen.sh && ./configure && make && make install
# RUN cd .. && rm -rf torsocks
# RUN apt remove -y autoconf automake libtool gcc libevent-dev libssl-dev zlib1g-dev software-properties-common git build-essential
RUN apt install -y ffmpeg
RUN apt install -y curl
RUN apt install -y vlc
RUN npm install -g http-server
# RUN npm install -g peerflix
# RUN npm install -g local-cors-proxy
RUN mkdir /live
COPY ./index.html /live/index.html
COPY ./run.sh /run.sh
COPY ./test.torrent /test.torrent
COPY ./torrc /etc/tor/torrc
COPY ./torsocks.conf /etc/tor/torsocks.conf
ENTRYPOINT ["/bin/bash", "/run.sh", "/test.torrent"]
