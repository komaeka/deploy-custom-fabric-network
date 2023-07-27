#!/bin/bash

if [ -d "../organizations/peerOrganizations" ]; then
rm -Rf ../organizations/peerOrganizations && rm -Rf ../organizations/ordererOrganizations
fi
