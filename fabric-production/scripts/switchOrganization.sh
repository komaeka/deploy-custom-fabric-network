#!/bin/bash

export CORE_PEER_TLS_ENABLED=true

setOrganization(){
    local USING_ORG=$1
    if [ $USING_ORG -eq 1 ]; then
        export CORE_PEER_LOCALMSPID="Org1MSP"
        export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
        export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
        export CORE_PEER_ADDRESS=localhost:7051
    elif [ $USING_ORG -eq 2 ]; then
        export CORE_PEER_LOCALMSPID="Org2MSP"
        export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
        export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
        export CORE_PEER_ADDRESS=localhost:9051
    else
        errorln "ORG Unknown"
    fi
}