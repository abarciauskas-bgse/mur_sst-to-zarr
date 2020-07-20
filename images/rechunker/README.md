## Push to AWS ECR

```bash
export AWS_ACCOUNT_ID=XXX
export DOCKER_TAG=zarr_rechunker
$(aws ecr get-login --no-include-email --region us-east-1)
aws ecr create-repository --repository-name $DOCKER_TAG

docker tag ${DOCKER_TAG}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_TAG}:latest

docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_TAG}:latest
```

