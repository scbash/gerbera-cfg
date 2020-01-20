FROM scb/gerbera:1.4.0-416fix

# Add transcoding tools
RUN apt-get update && \
    apt-get install -y flac vorbis-tools ffmpeg && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    mkdir -p /gerbera/data

# /gerbera/config should be mapped from the outside world
# It should include the config file and the parsing scripts
ENTRYPOINT [ "gerbera", "-p", "49152" , "--config", "/gerbera/config/config.xml" ]

