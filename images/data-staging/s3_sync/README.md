# S3 Sync

## Build Image

```bash
export AWS_ACCOUNT_ID=xxxxxxxxxxxx
export DOCKER_TAG=s3_sync
docker build -t $DOCKER_TAG .
```

## Run Container
```bash
docker run -it -v /fsx:/fsx $DOCKER_TAG <INPUT URI> <OUTPUT URI>
# example input: /fsx/eodc/mursst_zarr/backups/2002-2003
# example output: s3://ds-data-projects/eodc/mursst_zarr/backups/2002-2003
```

## Push to AWS ECR

```bash
$(aws ecr get-login --no-include-email --region us-west-2)
aws ecr create-repository --repository-name $DOCKER_TAG

docker tag ${DOCKER_TAG}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/${DOCKER_TAG}:latest

docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/${DOCKER_TAG}:latest
```


