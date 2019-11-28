## MUR SST to Zarr

Scripts for generating zarr from MUR SST netcdf 


### Create and load python virtual environment

```bash
~/miniconda3/bin/conda create -f environment.yml
source ~/miniconda3/bin/activate netcdf_to_zarr
jupyter notebook
```

### Mount PO.DAAC drive as a local filesystem

Requires WebDAV credentials.

Follow these instructions [How to mount PO.DAAC Drive on your local computer via OS X](https://podaac.jpl.nasa.gov/forum/viewtopic.php?f=75&t=1020)

## Tests

### Creating Zarr files

#### Attached PO.DAAC Drive, Local Cluster

* Using attached PO.DAAC drive
* Chunking 500x500x5
* 2 batches of 5 days took 46 minutes
* Assuming a linear relationship, this is 5 minutes per day or ~31 hours for a year


#### HD, Local Cluster

* Using attached HD
* Chunking 500x500x5
* 2 batches of 1 days took 8 minutes
* Assuming a linear relationship, this is 4 minutes per day or ~24 hours for a year




