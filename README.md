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

#### MacOSX

Follow these instructions [How to mount PO.DAAC Drive on your local computer via OS X](https://podaac.jpl.nasa.gov/forum/viewtopic.php?f=75&t=1020)

#### Amazon Linux

1. Launch an AWS EC2 using amzn2-ami-ecs-hvm-2.0.20191114-x86_64-ebs (ami-097e3d1cdb541f43)
2. Login and install git `sudo yum install git -y`
3. Build and run docker container:

```sh
git clone https://github.com/abarciauskas-bgse/mur_sst-to-zarr
cd mur_sst-to-zarr
export WEBDAV_USER=<ADD ME>
export WEBDAV_PASS=<ADD ME>
docker build --no-cache --build-arg WEBDAV_USER=$WEBDAV_USER --build-arg WEBDAV_PASS=$WEBDAV_PASS -t mursst_to_zarr .
docker run -it -p 8888:8888 -p 8787:8787 --privileged --cap-add=SYS_ADMIN --device /dev/fuse mursst_to_zarr
```

In practice, opening a set of 5 files using xr.open_mfdataset took over 3 minutes using this method, so it's probably not better than using a developer's machine with a HD attached.

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




