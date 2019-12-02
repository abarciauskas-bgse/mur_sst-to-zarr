FROM continuumio/anaconda3

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install davfs2 -y
RUN echo 'https://podaac-tools.jpl.nasa.gov/drive/files $WEBDAV_USER $WEBDAV_PASS' > /etc/davfs2/secrets
RUN mkdir /mnt/podaac_drive
RUN mount.davfs https://podaac-tools.jpl.nasa.gov/drive/files /mnt/podaac_drive

RUN git clone https://github.com/abarciauskas-bgse/mur_sst-to-zarr
RUN cd mur_sst-to-zarr
RUN conda env create -f environment.yml
RUN source activate netcdf_to_zarr

