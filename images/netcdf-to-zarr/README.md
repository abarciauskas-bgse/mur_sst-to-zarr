# Mount PO.DAAC Drive

... and optionally copy files locally

## Build Base Image

```bash
export DOCKER_TAG=conda-zarr-base
docker build -t $DOCKER_TAG -f Dockerfile.base .
```

## Build Image

```bash
export DOCKER_TAG=eodc-netcdf-to-zarr
docker build \
  --build-arg WEBDAV_USER=$WEBDAV_USER \
  --build-arg WEBDAV_PASS=$WEBDAV_PASS \
  -t $DOCKER_TAG .
```

## Run Container
```bash
# Running locally
docker run -it -v /Volumes:/Volumes -v \
  /Users/aimeebarciauskas/DevSeed/mur_sst_to_zarr/eodc:/eodc $DOCKER_TAG \
  /Volumes/files/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1 \
  /eodc/mursst_zarr/2002 2002 152 1 5
```

## Push to AWS ECR

```bash
$(aws ecr get-login --no-include-email --region us-east-1)
aws ecr create-repository --repository-name $DOCKER_TAG

export AWS_ACCOUNT_ID=xxxxxxxxxxxx

docker tag ${DOCKER_TAG}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_TAG}:latest

docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_TAG}:latest
```


