FROM conda-zarr-base:latest

COPY run.sh run.sh
COPY netcdf-to-zarr.py netcdf-to-zarr.py

ENTRYPOINT ["/bin/bash", "./run.sh"]
