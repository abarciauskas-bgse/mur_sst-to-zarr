FROM ubuntu

ARG WEBDAV_USER
ARG WEBDAV_PASS
ENV WEBDAV_USER=$WEBDAV_USER
ENV WEBDAV_PASS=$WEBDAV_PASS

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
RUN echo $AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY > ${HOME}/.passwd-s3fs
RUN chmod 600 ${HOME}/.passwd-s3fs

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install rsync davfs2 makedev s3fs fuse ca-certificates -y
RUN echo https://podaac-tools.jpl.nasa.gov/drive/files $WEBDAV_USER $WEBDAV_PASS > /etc/davfs2/secrets
RUN mkdir /mnt/podaac_drive

COPY run.sh run.sh
ENTRYPOINT ["/bin/bash", "./run.sh"]
