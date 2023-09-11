#!/bin/bash

DOCKER_SOCK="/var/run/docker.sock" docker compose -f ../config/docker-compose-node.yaml -f ../config/docker-compose-database.yaml up -d