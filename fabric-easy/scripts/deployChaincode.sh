#!/bin/bash

. switchOrganization.sh

# Set enviroment
export FABRIC_CFG_PATH=$PWD/../config/

echo "Vendoring Go dependencies at ../chaincode"
pushd ../chaincode || exit
GO111MODULE=on go mod vendor
popd || exit
echo "Finished vendoring Go dependencies"

# Package chaincode
chaincodePath="../config/basic.tar.gz"

setOrganization 1
peer lifecycle chaincode package $chaincodePath --path ../chaincode --lang golang --label basic_1.0
PACKAGE_ID=$(peer lifecycle chaincode calculatepackageid $chaincodePath)
echo "Chaincode is packaged"
echo "PACKAGE_ID is ${PACKAGE_ID}"

# Install chaincode
setOrganization 1
peer lifecycle chaincode install $chaincodePath
echo "Chaincode is installed on peer0.org1"
setOrganization 2
peer lifecycle chaincode install $chaincodePath
echo "Chaincode is installed on peer0.org2"

# Approve chaincode definition
ORDERER_CA=${PWD}/../organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
setOrganization 1
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name basic --version 1.0 --package-id $PACKAGE_ID --sequence 1 --tls --cafile $ORDERER_CA
echo "Chaincode definition approved on peer0.org1 on channel"
setOrganization 2
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name basic --version 1.0 --package-id $PACKAGE_ID --sequence 1 --tls --cafile $ORDERER_CA
echo "Chaincode definition approved on peer0.org1 on channel"

# Committing the chaincode definition to the channel
PEER1_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
PEER2_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name basic --version 1.0 --sequence 1 --tls --cafile $ORDERER_CA --peerAddresses localhost:7051 --tlsRootCertFiles $PEER1_TLS_ROOTCERT_FILE --peerAddresses localhost:9051 --tlsRootCertFiles $PEER2_TLS_ROOTCERT_FILE

# Test chaincode
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles $PEER1_TLS_ROOTCERT_FILE --peerAddresses localhost:9051 --tlsRootCertFiles $PEER2_TLS_ROOTCERT_FILE -c '{"function":"InitLedger","Args":[]}'
# peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'