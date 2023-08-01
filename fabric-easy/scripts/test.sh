#!/bin/bash


if [ "$1" == -ca ]; then
    CRYPTO="Certificate Authorities"
else
    CRYPTO="cryptogen"
fi
# echo "=== $CRYPTO ==="

if [ "$CRYPTO" == "cryptogen" ]; then
    echo "=== $CRYPTO ==="
fi

# 使用fabricCA生成证书
if [ "$CRYPTO" == "Certificate Authorities" ]; then
  echo "=== $CRYPTO ==="
fi