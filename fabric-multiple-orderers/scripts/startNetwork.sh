#!/bin/bash

DOCKER_SOCK="/var/run/docker.sock" docker compose -f ../config/docker-compose.yaml up -d