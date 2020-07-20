#!/bin/bash
source activate zarr_rechunker
# pip install ipykernel
python -m ipykernel install --user --name=zarr_rechunker
jupyter notebook --allow-root --ip 0.0.0.0

