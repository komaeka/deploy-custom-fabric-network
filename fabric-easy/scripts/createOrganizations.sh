#!/bin/bash

# cryptogen or Fabric CA
if [ "$1" == -ca ]; then
    CRYPTO="Certificate Authorities"
else
    CRYPTO="cryptogen"
fi

# 使用cryptogen生成证书
if [ "$CRYPTO" == "cryptogen" ]; then
  echo "Using cryptogen generate the crypto material"
  cryptogen generate --config=../config/crypto-config.yaml --output="../organizations"
  echo "Created Identities"
fi

# 使用fabricCA生成证书
if [ "$CRYPTO" == "Certificate Authorities" ]; then
  echo "Using Fabric CA generate the crypto material"
fi
