FROM conda-zarr-base:latest

ARG WEBDAV_USER
ARG WEBDAV_PASS
ENV WEBDAV_USER=$WEBDAV_USER
ENV WEBDAV_PASS=$WEBDAV_PASS

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install rsync davfs2 makedev s3fs fuse ca-certificates -y
RUN echo https://podaac-tools.jpl.nasa.gov/drive/files $WEBDAV_USER $WEBDAV_PASS > /etc/davfs2/secrets
RUN mkdir /mnt/podaac_drive

COPY run.sh run.sh
COPY netcdf-to-zarr.py netcdf-to-zarr.py
COPY create.ipynb create.ipynb
ENTRYPOINT ["/bin/bash", "./run.sh"]
