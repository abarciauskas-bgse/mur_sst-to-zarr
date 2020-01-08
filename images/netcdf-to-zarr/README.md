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
docker build -t $DOCKER_TAG .
```

## Run Container
```bash
docker run -it -v /data:/data $DOCKER_TAG
```

## Push to AWS ECR

```bash
$(aws ecr get-login --no-include-email --region us-east-1)
aws ecr create-repository --repository-name $DOCKER_TAG

export AWS_ACCOUNT_ID=xxxxxxxxxxxx

docker tag ${DOCKER_TAG}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_TAG}:latest

docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_TAG}:latest
```


