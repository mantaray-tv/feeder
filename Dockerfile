FROM ubuntu

LABEL org.opencontainers.image.source=https://github.com/mantaray-tv/feeder
RUN apt update -y
RUN apt install -y nodejs npm vlc
