#!/bin/bash

source activate netcdf_to_zarr
# python netcdf-to-zarr.py $1 $2 $3 $4 $5 $6
jupyter notebook --ip='*' --port=8888 --no-browser --allow-root

