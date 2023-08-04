#!/bin/bash

export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
CHANNEL=mychannel

# For organization1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

## Fetch channel config
HOST="peer0.org1.example.com"
PORT=7051
peer channel fetch config config_block.pb -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL --tls --cafile $ORDERER_CA
configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json
jq .data.data[0].payload.data.config config_block.json > ${CORE_PEER_LOCALMSPID}config.json
jq '.channel_group.groups.Application.groups.'${CORE_PEER_LOCALMSPID}'.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "'$HOST'","port": '$PORT'}]},"version": "0"}}' ${CORE_PEER_LOCALMSPID}config.json > ${CORE_PEER_LOCALMSPID}modified_config.json

## Update channel config
configtxlator proto_encode --input ${CORE_PEER_LOCALMSPID}config.json --type common.Config --output original_config.pb
configtxlator proto_encode --input ${CORE_PEER_LOCALMSPID}modified_config.json --type common.Config --output modified_config.pb
configtxlator compute_update --channel_id "${CHANNEL}" --original original_config.pb --updated modified_config.pb --output config_update.pb
configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate --output config_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL'", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json
configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output ${CORE_PEER_LOCALMSPID}anchors.tx

## Update anchor peer
peer channel update -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL -f ${CORE_PEER_LOCALMSPID}anchors.tx --tls --cafile $ORDERER_CA


# For organization2
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

## Fetch channel config
HOST="peer0.org2.example.com"
PORT=9051
peer channel fetch config config_block.pb -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL --tls --cafile $ORDERER_CA
configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json
jq .data.data[0].payload.data.config config_block.json > ${CORE_PEER_LOCALMSPID}config.json
jq '.channel_group.groups.Application.groups.'${CORE_PEER_LOCALMSPID}'.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "'$HOST'","port": '$PORT'}]},"version": "0"}}' ${CORE_PEER_LOCALMSPID}config.json > ${CORE_PEER_LOCALMSPID}modified_config.json

## Update channel config
configtxlator proto_encode --input ${CORE_PEER_LOCALMSPID}config.json --type common.Config --output original_config.pb
configtxlator proto_encode --input ${CORE_PEER_LOCALMSPID}modified_config.json --type common.Config --output modified_config.pb
configtxlator compute_update --channel_id "${CHANNEL}" --original original_config.pb --updated modified_config.pb --output config_update.pb
configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate --output config_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL'", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json
configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output ${CORE_PEER_LOCALMSPID}anchors.tx

## Update anchor peer
peer channel update -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL -f ${CORE_PEER_LOCALMSPID}anchors.tx --tls --cafile $ORDERER_CA