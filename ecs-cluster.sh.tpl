#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo ECS_IMAGE_PULL_BEHAVIOR=always >> /etc/ecs/ecs.config
echo 'DOCKER_STORAGE_OPTIONS="$DOCKER_STORAGE_OPTIONS --storage-opt dm.basesize=200G"' >> /etc/sysconfig/docker-storage
