[
  {
    "name": "s3-sync",
    "image": "${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/eodc-s3_sync",
    "cpu": 10,
    "memory": 24000,
    "essential": true,
    "privileged": true,
    "mountPoints": [{
      "sourceVolume": "service-storage",
      "containerPath": "/s3fsx"
    }],
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
