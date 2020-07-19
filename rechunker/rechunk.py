import s3fs
import zarr

s3 = s3fs.S3FileSystem(anon=True, client_kwargs=dict(region_name='us-west-2'))
s3_store = s3fs.S3Map(root='mur-sst/zarr', s3=s3, check=False)
ds_zarr = zarr.open_consolidated(s3_store, mode='r') #, mask_and_scale=False) - Do we want mask_and_scale here?

ds_subset = ds_zarr['analysed_sst']

# Toy example
subset = ds_zarr['analysed_sst'].get_orthogonal_selection((slice(0,100), slice(0,100), slice(0,100)))
store = zarr.DirectoryStore('data/example.zarr')
root = zarr.group(store1, overwrite=True)
root.create_dataset('analysed_sst', data=subset, chunks=(2,2,2))
source_array = root['analysed_sst']
target_chunks = (10,10,10)
max_mem = '1MB'


target_store = 'rechunked.zarr'
temp_store = 'rechunked-tmp.zarr'

array_plan = rechunk(source_array, target_chunks, max_mem, target_store, temp_store)
array_plan
result = array_plan.execute()
result.chunks
