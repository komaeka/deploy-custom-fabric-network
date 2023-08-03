#!/bin/bash

. switchOrganization.sh
export FABRIC_CFG_PATH=$PWD/../config

# Generate the genesis block
echo "Generating channel genesis block mychannel.block"
configtxgen -profile TwoOrgsApplicationGenesis -outputBlock ../config/mychannel.block -channelID mychannel

# Create channel: use the osnadmin CLI to add the orderer to the channel
export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

sleep 1
osnadmin channel join --channelID mychannel --config-block ../config/mychannel.block -o localhost:7053 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

# Join all the peers to the channel
BLOCKFILE=../config/mychannel.block
setOrganization 1
sleep 1
peer channel join -b $BLOCKFILE
setOrganization 2
sleep 1
peer channel join -b $BLOCKFILE

# Set the anchor peers for each org in the channel
docker exec cli ./scripts/setAnchorPeer.sh