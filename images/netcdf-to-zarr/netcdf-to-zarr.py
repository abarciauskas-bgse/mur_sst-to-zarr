import numpy as np
import xarray as xr
import pandas as pd
import numcodecs
from dask.distributed import Client, progress, LocalCluster
import zarr
import glob

def generate_file_list(start_doy, end_doy):   
    """
    Given a start day and end end day, generate a list of file locations.
    Assumes a 'prefix' and 'year' variables have already been defined.
    'Prefix' should be a local directory or http url and path.
    'Year' should be a 4 digit year.
    """
    days_of_year = list(range(start_doy, end_doy))
    fileObjs = []
    for doy in days_of_year:
        if doy < 10:
            doy = f"00{doy}"
        elif doy >= 10 and doy < 100:
            doy = f"0{doy}"            
        file = glob.glob(f"{prefix}/{doy}/*.nc")[0]
        fileObjs.append(file)
    return fileObjs

# Invariants - but should be made configurable
year = 2002
prefix = f"/fsx/eodc/mursst_netcdf/{year}"
chunks = {'time': 5, 'lat': 1000, 'lon': 1000}
path = 'x'.join(map(str, chunks.values()))
store_dir = f"/fsx/eodc/mursst_zarr/{path}"
numcodecs.blosc.use_threads = False
print(f"zarr store directory: {store_dir}")

if __name__ == '__main__':
    cluster = LocalCluster(n_workers=4)
    client = Client(cluster)
    print(f"Dask client {client}")

    # Loop and append
    start_doy = 152
    end_doy = start_doy
    number_batches_to_append = 1
    batch_size = 5
    final_end_doy = start_doy + (number_batches_to_append * batch_size)

    while start_doy < final_end_doy:
        end_doy = start_doy + batch_size
        end_doy = min(366, end_doy)
        fileObjs = generate_file_list(start_doy, end_doy)
        print(f"start doy: {start_doy}, file: {fileObjs[0].split('/')[-1]}")
        print(f"end doy: {end_doy}, file: {fileObjs[-1].split('/')[-1]}")          
        ds = xr.open_mfdataset(fileObjs, parallel=True, combine='by_coords')
        ds_rechunk = ds.chunk(chunks=chunks)
        args = {'consolidated': True}
        if start_doy == 152 and year == 2002:
            args['mode'] = 'w'
        else:
            args['mode'] = 'a'
            args['append_dim'] = 'time'
        ds_rechunk.to_zarr(store_dir, **args)
        start_doy = end_doy
        print(f"Done with this batch")
        print()

