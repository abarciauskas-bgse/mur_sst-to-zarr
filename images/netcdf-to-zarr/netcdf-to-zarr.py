import numpy as np
import xarray as xr
import pandas as pd
import numcodecs
from dask.distributed import Client, progress, LocalCluster
import zarr
import glob
from datetime import datetime
import time
import sys

def generate_file_list(netcdf_prefix, start_doy, end_doy, year):
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
        print(f"{netcdf_prefix}/{year}/{doy}/*.nc")
        file = glob.glob(f"{netcdf_prefix}/{year}/{doy}/*.nc")[0]
        fileObjs.append(file)
    return fileObjs

def create_or_append_zarr(netcdf_prefix, zarr_store, year, start_doy, number_batches_to_append, batch_size):
    end_doy = start_doy
    final_end_doy = start_doy + (number_batches_to_append * batch_size)

    while start_doy < final_end_doy:
        end_doy = start_doy + batch_size
        end_doy = min(367, end_doy)
        fileObjs = generate_file_list(netcdf_prefix, start_doy, end_doy, year)
        first_file = fileObjs[0].split('/')[-1]
        last_file = fileObjs[-1].split('/')[-1]
        print(f"start doy: {start_doy}, starting file: {first_file}")
        print(f"end doy: {end_doy}, ending file: {last_file}")
        args = {'consolidated': True}
        # Either append or initiate store
        if start_doy == 152 and year == 2002:
            ds = xr.open_mfdataset(fileObjs, parallel=True, combine='by_coords', mask_and_scale=False)
            ds = ds.chunk(chunks)
            args['mode'] = 'w'
        else:
            # Check here that the next day we will append is the next day in the year
            current_ds = xr.open_zarr(zarr_store, consolidated=True)
            next_day = current_ds.time[-1].values + np.timedelta64(1, 'D')
            next_day_str = str(next_day)[0:10].replace('-', '')
            if not (first_file[0:8] == next_day_str):
                raise Exception("starting file is not the next day of the year")
                break
            ds = xr.open_mfdataset(fileObjs, parallel=True, combine='by_coords')
            ds = ds.chunk(chunks)
            args['mode'] = 'a'
            args['append_dim'] = 'time'
        ds.to_zarr(zarr_store, **args)
        start_doy = end_doy
        print(f"Done with this batch")
        print()

# python netcdf-to-zarr.py /fsx/eodc/mursst_netcdf /fsx/edoc/mursst_zarr/2002-2004 2005 1 1 5
# python netcdf-to-zarr.py /Volumes/files/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1 eodc/mursst_zarr/2002 2002 1 1 5
if __name__ == "__main__":
    # Invariants - but could be made configurable
    chunks = {'time': 5, 'lat': 1799, 'lon': 3600}
    numcodecs.blosc.use_threads = False
    print(sys.argv)
    _, netcdf_prefix, zarr_store, year, start_day, number_batches_to_append, batch_size = sys.argv
    year, start_day, number_batches_to_append, batch_size = int(year), int(start_day), int(number_batches_to_append), int(batch_size)
    print(f"zarr store directory: {zarr_store}")

    # Initialize Dask
    cluster = LocalCluster(n_workers=4)
    client = Client(cluster)
    print(f"Dask client {client}")
    create_or_append_zarr(netcdf_prefix, zarr_store, year, start_day, number_batches_to_append, batch_size)
