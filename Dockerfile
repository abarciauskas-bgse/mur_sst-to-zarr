FROM continuumio/anaconda3

ARG WEBDAV_USER
ARG WEBDAV_PASS
ENV WEBDAV_USER=$WEBDAV_USER
ENV WEBDAV_PASS=$WEBDAV_PASS

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install davfs2 makedev fuse -y
RUN echo https://podaac-tools.jpl.nasa.gov/drive/files $WEBDAV_USER $WEBDAV_PASS > /etc/davfs2/secrets
RUN mkdir /mnt/podaac_drive

RUN git clone https://github.com/abarciauskas-bgse/mur_sst-to-zarr
WORKDIR /mur_sst-to-zarr
RUN cat environment.yml
RUN conda env create -f environment.yml

ENTRYPOINT ['./run.sh']
