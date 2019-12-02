#!/bin/bash

mount.davfs https://podaac-tools.jpl.nasa.gov/drive/files /mnt/podaac_drive
source activate netcdf_to_zarr
jupyter notebook --ip='*' --port=8888 --no-browser --allow-root

