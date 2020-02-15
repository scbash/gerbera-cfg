FROM scb/gerbera:1.4.0-416fix

# Specify user ID to run as
# Synology uses somewhat complicated ACLs for shares, so I created a Synology user,
# granted them read-only access to the media, and then use that same UID for Gerbera server.
# Override this when building the container: docker build --build-arg user_id=xxxx ...
ARG user_id=1029

# Create user to run server
# Note this assumes the users group exists (which it does in Gerbera's current base image, ubuntu:18.04)
# Note 2: build args don't work correcly for Synology's Docker 18.09.8 build 2c0a67b,
#         so specify the default _again_.
RUN useradd -r -u "${user_id:-1029}" -g users gerbera

# Add transcoding tools
RUN apt-get update && \
    apt-get install -y flac vorbis-tools ffmpeg && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    mkdir -p /gerbera/data && \
    chown gerbera:users /gerbera/data

USER gerbera:users

# /gerbera/config should be mapped from the outside world
# It should include the config file and the parsing scripts
ENTRYPOINT [ "gerbera", "-p", "49152" , "--config", "/gerbera/config/config.xml" ]

