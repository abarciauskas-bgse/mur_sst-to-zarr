[
  {
    "name": "eodc-netcdf-to-zarr-task-def",
    "image":
    "${aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/zarr-rechunker",
    "memory": 256000,
    "portMappings": [{
      "hostPort": 8888,
      "protocol": "tcp",
      "containerPort": 8888
    }, {
      "hostPort": 8787,
      "protocol": "tcp",
      "containerPort": 8787
    }],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/zarr-rechunker",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
