#!/bin/bash

# 删除旧的证书文件
rm -rf ../organizations/peerOrganizations/* ../organizations/ordererOrganizations/*
rm -rf ../organizations/fabric-ca/ordererOrg/* ../organizations/fabric-ca/org1/* ../organizations/fabric-ca/org2/*
sleep 1

#  启动Fabric CA
docker compose -f ../config/docker-compose-ca.yaml up -d

echo "Generating certificates using Fabric CA"

. registerEnroll.sh

# very important!!!
while :
do
  if [ ! -f "../organizations/fabric-ca/org1/tls-cert.pem" ]; then
    sleep 1
  else
    break
  fi
done

echo "Creating Org1 Identities"
createOrg1
echo "Creating Org2 Identities"
createOrg2
echo "Creating Orderer Org Identities"
createOrderer