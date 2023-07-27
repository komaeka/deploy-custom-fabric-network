#!/bin/bash

# cryptogen or fabricCA
CRYPTO=$1

if [ -d "../organizations/peerOrganizations" ]; then
rm -Rf ../organizations/peerOrganizations && rm -Rf ../organizations/ordererOrganizations
fi

if [ "$CRYPTO" != "cryptogen" ] && [ "$CRYPTO" != "fabricCA" ]; then
  echo "please use cryptogen or fabricCA create crypto material"
  exit
fi

# 使用cryptogen生成证书
if [ "$CRYPTO" == "cryptogen" ]; then
  echo "Using ${CRYPTO} generate the crypto material"
  cryptogen generate --config=config/crypto-config.yaml --output="organizations"
  echo "Created Identities"
fi

# 使用fabricCA生成证书
if [ "$CRYPTO" == "fabricCA" ]; then
  exit
fi
