[
  {
    "name": "s3-sync",
    "image": "${aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/eodc-s3_sync",
    "cpu": 10,
    "memory": 24000,
    "privileged": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/eodc-s3_sync",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
