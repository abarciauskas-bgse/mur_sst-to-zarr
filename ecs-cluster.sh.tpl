#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo ECS_IMAGE_PULL_BEHAVIOR=always >> /etc/ecs/ecs.config
