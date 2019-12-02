#!/bin/bash

mount.davfs https://podaac-tools.jpl.nasa.gov/drive/files /mnt/podaac_drive
source activate netcdf_to_zarr
/opt/conda/bin/jupyter notebook --ip='*' --port=8888 --no-browser

