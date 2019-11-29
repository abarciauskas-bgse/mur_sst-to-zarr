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

Using caffe_python3_cpu-171216-ubuntu-16.04-95768314-1460-4c0e-a521-65743f73f245-ami-d6c6b4ac.4

```
sudo dpkg --configure -a
sudo apt-get install davfs2
sudo mkdir /mnt/podaac_drive
sudo mount.davfs https://podaac-tools.jpl.nasa.gov/drive/files /mnt/podaac_drive
```

Install conda ([reference](https://www.digitalocean.com/community/tutorials/how-to-install-anaconda-on-ubuntu-18-04-quickstart)):
```
cd /tmp
curl -O https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh

# verify data integrity
sha256sum Anaconda3-2019.03-Linux-x86_64.sh
# should be
# 45c851b7497cc14d5ca060064394569f724b67d9b5f98a926ed49b834a6bb73a  Anaconda3-2019.03-Linux-x86_64.sh

# Run the installer
bash Anaconda3-2019.03-Linux-x86_64.sh 
```


```
git clone https://github.com/abarciauskas-bgse/mur_sst-to-zarr
cd mur_sst-to-zarr
conda env create -f environment.yml
source activate netcdf_to_zarr
```

Configure jupyter as a remote server. Specifically:

```
jupyter notebook --generate-config
```

And then edit `jupyter_notebook_config.py`:

```
c.NotebookApp.ip = '*'
```

[For reference: Running a Notebook Server](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html)

Follow these instructions [How to mount PO.DAAC Drive on your local computer via Linux](https://podaac.jpl.nasa.gov/forum/viewtopic.php?f=75&t=1026)

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




