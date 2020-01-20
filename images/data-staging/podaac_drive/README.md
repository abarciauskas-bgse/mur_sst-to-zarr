# Mount PO.DAAC Drive

... and optionally copy files locally

## Build Image

```bash
export DOCKER_TAG=eodc-mount-podaac-drive
export WEBDAV_USER=<ADD ME>
export WEBDAV_PASS=<ADD ME>
docker build \
  --build-arg WEBDAV_USER=$WEBDAV_USER \
  --build-arg WEBDAV_PASS=$WEBDAV_PASS \
  --build-arg AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  --build-arg AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -t $DOCKER_TAG .
```

## Run Container
```bash
docker run -it -v ~/s3fs:/s3fs --privileged --cap-add=SYS_ADMIN --device /dev/fuse $DOCKER_TAG <PODAAC DRIVE PATH> <LOCAL FS PATH>
# Example
docker run -it -v ~/s3fs:/s3fs --privileged --cap-add=SYS_ADMIN --device /dev/fuse $DOCKER_TAG allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/2006/002/ /s3fs/mursst_netcdf/2006/002/
```

## Push to AWS ECR

```bash
$(aws ecr get-login --no-include-email --region us-east-1)
aws ecr create-repository --repository-name $DOCKER_TAG

export AWS_ACCOUNT_ID=xxxxxxxxxxxx

docker tag ${DOCKER_TAG}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_TAG}:latest

docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_TAG}:latest
```


