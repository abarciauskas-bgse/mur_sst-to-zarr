#!/bin/bash

source activate netcdf_to_zarr
# python netcdf-to-zarr.py
jupyter notebook --ip='*' --port=8888 --no-browser --allow-root

