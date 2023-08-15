# 部署自定义fabric网络（production）
* 本工程将部署一个基础的fabric网络，主要包含如下内容
  * 三个排序节点
  * 三个组织，每个组织包含两个peer节点
    * 每个组织的peer0节点为锚节点
    * 动态选举leader节点
  * 使用Fabric CA生成证书文件
  * 使用CouchDB作为状态数据库

> 以下所有脚本均需要在scirpts目录下运行

## 生成各个组织的证书文件
* 运行createOrganizations.sh创建证书文件：`./createOrganizations.sh`

## 启动fabric网络
* 运行startNetwork.sh启动网络：`./startNetwork.sh`

## 创建通道
* 运行createChannel.sh创建通道：`./createChannel.sh`

## 部署链码
* 运行deployChaincode.sh部署链码：`./deployChaincode.sh`

## 调用链码
1. 设置FABRIC_CFG_PATH指向config中的core.yaml文件：`export FABRIC_CFG_PATH=$PWD/../config/`
2. 要使用peer CLI，需要设置peer节点的环境变量，这将决定以谁的身份操作peer CLI
    ```shell
    # 启用TLS
    export CORE_PEER_TLS_ENABLED=true

    # 以Org1管理员用户身份操作peer CLI
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=$PWD/../organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    
    # 以Org2管理员用户身份操作peer CLI
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=$PWD/../organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    ```
3. 切换到以Org1管理员用户身份操作peer CLI
4. 创建一组初始资产：`peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'`
5. 获取资产列表：`peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'`
6. 调用资产转移链码来更改资产的所有者：`peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"TransferAsset","Args":["asset6","Christopher"]}'`
7. 切换到以Org2管理员用户身份操作peer CLI
8. 查询转移后的资产：`peer chaincode query -C mychannel -n basic -c '{"Args":["ReadAsset","asset6"]}'`

## 关闭fabric网络
* 运行closeNetwork.sh关闭网络：`./closeNetwork.sh`