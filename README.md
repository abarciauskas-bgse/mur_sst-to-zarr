# MUR SST to Zarr

Steps and scripts for generating zarr from MUR SST netcdf.

## High-Level Steps

1. Mount PO.DAAC drive as a local filesystem
2. Run [Create Zarr Stores.ipynb](https://github.com/abarciauskas-bgse/mur_sst-to-zarr/blob/master/images/netcdf-to-zarr/Create-Append-Test-Zarr.ipynb)
3. Sync zarr store to S3

You can do this both on a local machine or a remote server.

Docker images for each of these steps are stored in [/images](https://github.com/abarciauskas-bgse/mur_sst-to-zarr/tree/master/images).

In practice, I used [AWS FSx](https://aws.amazon.com/fsx/) and S3 repository integration to sync both NetCDF files and Zarr store.

## 1. Mount PO.DAAC drive to the local filesystem

Requires WebDAV credentials.

Note there is also a docker image to do this: [podaac_drive](https://github.com/abarciauskas-bgse/mur_sst-to-zarr/tree/master/images/data-staging/podaac_drive).

#### MacOSX

Follow these instructions [How to mount PO.DAAC Drive on your local computer via OS X](https://podaac.jpl.nasa.gov/forum/viewtopic.php?f=75&t=1020)

#### Amazon Linux

1. Launch an AWS EC2 using amzn2-ami-ecs-hvm-2.0.20191114-x86_64-ebs (ami-097e3d1cdb541f43)
    * Ensure enough storage
    * Ensure security group with access on ports 22 (ssh), 8888 (jupyter) and 8787 (dask)
    * Lauch with an EC2 keypair you are the owner of
2. Login via SSH and install docker and git `sudo yum install git docker -y`
3. Build and run docker container:

```sh
git clone https://github.com/abarciauskas-bgse/mur_sst-to-zarr
cd mur_sst-to-zarr
export WEBDAV_USER=<ADD ME>
export WEBDAV_PASS=<ADD ME>
docker build --no-cache --build-arg WEBDAV_USER=$WEBDAV_USER --build-arg WEBDAV_PASS=$WEBDAV_PASS -t mursst_to_zarr .
docker run -it -v /data/mursst_netcdf:/data/mursst_netcdf --privileged --cap-add=SYS_ADMIN --device /dev/fuse mursst_to_zarr
```

In practice, opening a set of 5 files using xr.open_mfdataset took over 3 minutes using this method, so it's probably not better than using a developer's machine with a HD attached.

## 2. Running the Notebook

### Use Conda and virtualenv

```bash
~/miniconda3/bin/conda create -f environment.yml
source ~/miniconda3/bin/activate netcdf_to_zarr
jupyter notebook
```

### Use docker

[netcdf-to-zarr](https://github.com/abarciauskas-bgse/mur_sst-to-zarr/tree/master/images/netcdf-to-zarr)

## 3. Sync to S3

[s3_sync](https://github.com/abarciauskas-bgse/mur_sst-to-zarr/tree/master/images/data-staging/s3_sync)

