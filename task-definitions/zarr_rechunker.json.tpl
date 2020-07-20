[
  {
    "name": "eodc-netcdf-to-zarr-task-def",
    "image":
    "${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/zarr-rechunker",
    "cpu": 30,
    "memory": 100000,
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
