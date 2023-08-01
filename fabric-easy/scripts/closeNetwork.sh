#!/bin/bash

# 删除docker容器
DOCKER_SOCK="/var/run/docker.sock" docker compose -f ../config/docker-compose.yaml down --volumes --remove-orphans
docker image rm -f $(docker images -aq --filter reference='dev-peer*')

# 删除链码包和通道创世区块
if [ -f "../config/basic.tar.gz" ]; then
rm ../config/basic.tar.gz
fi
if [ -f "../config/mychannel.block" ]; then
rm ../config/mychannel.block
fi

# 删除旧的证书文件
if [ -d "../organizations/peerOrganizations" ]; then
rm -Rf ../organizations/peerOrganizations && rm -Rf ../organizations/ordererOrganizations
fi