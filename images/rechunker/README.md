# Rechunking the MUR SST Zarr store

This image runs a jupyter notebook environment. The existing notebook creates a
local cluster and rechunks the Zarr store into and S3 bucket. At the moment, the destination bucket is in the Development Seed AWS account so assumes the EC2
instance has permission to write to that bucket.

## Build the image

Note the image already exists in us-east-1

```bash
export DOCKER_TAG=zarr_rechunker
docker build -t $DOCKER_TAG .
```

## Push to AWS ECR

```bash
export AWS_ACCOUNT_ID=XXX
$(aws ecr get-login --no-include-email --region us-west-2)
# Only necessary if you are creating the image in a new AWS account or AWS
region
# aws ecr create-repository --repository-name $DOCKER_TAG

docker tag ${DOCKER_TAG}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/${DOCKER_TAG}:latest

docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_TAG}:latest
```

