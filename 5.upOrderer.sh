export ORDERER_FILELEDGER_LOCATION=../ledger/
export FABRIC_LOGGING_SPEC=INFO
export FABRIC_CFG_PATH=./config
export ORDERER_GENERAL_LISTENADDRESS=127.0.0.1
export ORDERER_GENERAL_LOCALMSPID="OrdererMSP"

#Finding file config 
export ORDERER_GENERAL_BOOTSTRAPMETHOD=file
export ORDERER_GENERAL_BOOTSTRAPFILE=${PWD}/artifact/genesis.block
export CORE_PEER_MSPCONFIGPATH=/home/vakhim/Desktop/hyperledger3/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

#Enable TLS

export ORDERER_GENERAL_LOCALMSPDIR=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp
export ORDERER_GENERAL_TLS_PRIVATEKEY=/home/vakhim/Desktop/hyperledger3/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
export ORDERER_GENERAL_TLS_CERTIFICATE=/home/vakhim/Desktop/hyperledger3/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_GENERAL_TLS_ROOTCAS=/home/vakhim/Desktop/hyperledger3/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
export ORDERER_GENERAL_TLS_ENABLED=true


orderer
