FROM continuumio/anaconda3

COPY run.sh run.sh
COPY environment.yml environment.yml
COPY netcdf-to-zarr.py netcdf-to-zarr.py
RUN conda env create -f environment.yml

ENTRYPOINT ["/bin/bash", "./run.sh"]
