FROM ubuntu

ARG WEBDAV_USER
ARG WEBDAV_PASS
ENV WEBDAV_USER=$WEBDAV_USER
ENV WEBDAV_PASS=$WEBDAV_PASS

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install davfs2 makedev fuse ca-certificates -y
RUN echo https://podaac-tools.jpl.nasa.gov/drive/files $WEBDAV_USER $WEBDAV_PASS > /etc/davfs2/secrets
RUN mkdir /mnt/podaac_drive

COPY run.sh run.sh
ENTRYPOINT ["/bin/bash", "./run.sh"]
