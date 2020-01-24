#!/bin/bash

mount.davfs https://podaac-tools.jpl.nasa.gov/drive/files /mnt/podaac_drive
source activate netcdf_to_zarr
export NETCDF_DIR=$1
if [[ -z "${NETCDF_DIR}" ]]; then
  jupyter notebook --ip='*' --port=8888 --no-browser --allow-root
else
  python netcdf-to-zarr.py $NETCDF_DIR $2 $3 $4 $5 $6
fi

