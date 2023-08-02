# Deploy custom fabric network(advanced)

* 该目录为部署一个进阶版本的fabric网络实例，主要包含如下内容
  * 基于raft排序算法的三个排序节点
  * 两个组织，每个组织两个peer节点，锚节点都为peer0
  * fabric sample中的测试链码

## 生成各个组织的证书文件

1. 进入config目录，使用cryptogen CLI生成构建证书的配置文件：`cryptogen showtemplate > crypto-config.yaml`
2. 根据条件修改生成的crypto-config.yaml
3. 进入scripts目录，运行createOrganizations.sh创建证书文件：`./createOrganizations.sh`

## 启动fabric网络

1. 在config目录中创建构建fabric网络的docker-compose.yaml文件和负责peer节点配置的core.yaml文件
2. 根据条件编写docker-compose.yaml文件和core.yaml文件
3. 进入scripts目录，运行startNetwork.sh启动网络：`./startNetwork.sh`

## 创建通道

1. 在config目录中创建负责通道配置的configtx.yaml文件和负责orderer节点配置的orderer.yaml文件
2. 根据条件编写configtx.yaml文件和orderer.yaml文件
3. 进入scripts目录，运行createChannel.sh创建通道：`./createChannel.sh`

## 部署链码

