# MUR SST to Zarr

Steps and scripts for generating zarr from MUR SST netcdf.

## Deployment

This repo uses terraform to deploy an ECS cluster and task definitions to AWS.
See `eodc.tf` for details of the deployment. Depending on what you are trying
to do, different `task_definitions` and ECS instance type and region should be included in your deployment. 

**TODO** Add descriptions of different tasks (images) here.

Pre-requisites:

* docker
* terraform

```bash
# export your AWS_PROFILE or otherwise set your environment to the appropriate
AWS account credentials.
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

## Accessing and running the notebooks

To access the jupyter notebook interface you need to:
* Navigate to the ECS console and find your cluster. Start tasks corresponding
  to your task (creating a zarr store or rechunking a zarr store)
* Make sure the security group has granted your IP inbound permissions to ports
  8888 (jupyter) and 8787 (dask dashboard)
* Open the IP:8888 of the instance in you ECS cluster. You should see the
  default jupyter notebook log in page asking you for a token.
* Navigate to Cloudwatch Logs and find your log group. The most recent logs
  should have the access token in them. Use this access token in the jupyter
  interface.
* Open the notebook of interest and get chunking!

## High-Level Steps for generating Zarr store from NetCDF files from PO.DAAC/

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
git clone git@github.com:abarciauskas-bgse/mur_sst-to-zarr.git
cd mur_sst-to-zarr
~/miniconda3/bin/conda create -f images/netcdf-to-zarr/environment.yml
source ~/miniconda3/bin/activate netcdf_to_zarr
jupyter notebook
```

### Use docker

[netcdf-to-zarr](https://github.com/abarciauskas-bgse/mur_sst-to-zarr/tree/master/images/netcdf-to-zarr)

## 3. Sync to S3

[s3_sync](https://github.com/abarciauskas-bgse/mur_sst-to-zarr/tree/master/images/data-staging/s3_sync)

## Rechunking Zarr store

An additional image for rechunking an existing zarr store is located in
`images/rechunker`. See the README.md in that directory for more details.

