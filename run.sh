#!/bin/bash

mount.davfs https://podaac-tools.jpl.nasa.gov/drive/files /mnt/podaac_drive
#cp -r /mnt/podaac_drive/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/ /data/mursst_netcdf
source activate netcdf_to_zarr
jupyter notebook --ip='*' --port=8888 --no-browser --allow-root

