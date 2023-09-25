#base environment configuration
export FABRIC_CFG_PATH=${PWD}/config
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE1=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
# export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_TLS_ROOTCERT_FILE2=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export ORDERER_CA=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PACKAGE_ID

#set chaincode parameters
CC_NAME="basic"
CC_PATH="./chaincode-go"
CC_VERSION="1.0"
CC_SEQUENCE="1"
CC_INIT_FUNCTION="initLedger"
CC_RUNTIME_LANGUAGE="golang"
CHANNEL_NAME="mychannel"
PRIVATE_DATA_CONFIG=${PWD}/config/collections_config.json

setGlobalsForPeer0Org1(){
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE1}
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer0Org2(){
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE2}
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7053
}   

#If we run chaincode for the first time
presetup(){
    echo Vendoring GO dependencies...
    pushd ./chaincode-go/
    # GOPROXY=https://goproxy.cn,direct
    GO111MODULE=on 
    go mod vendor
    popd
    echo Finised vendoring Go dependencies
}

#Package chaincode
packageChaincode(){
    setGlobalsForPeer0Org1
    rm -rf ${CC_NAME}.tar.gz
    peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_PATH} --lang $CC_RUNTIME_LANGUAGE --label $CC_NAME
    echo "==================================== Chaincode is packaged on peer0.org1 ===================================="
}

installChaincode(){
    setGlobalsForPeer0Org1
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "==================================== Chaincode is installed on peer0.org1 ===================================="

    setGlobalsForPeer0Org2
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "==================================== Chaincode is installed on peer0.org2 ===================================="

}

queryInstalled(){
    setGlobalsForPeer0Org1
    peer lifecycle chaincode queryinstalled \ >&log.txt

    PACKAGE_ID=$(awk '/Package ID:/{sub("Package ID: ", ""); print}' log.txt | sed 's/, Label: basic//')
    echo PackageID is ${PACKAGE_ID}
    echo "==================================== Query installed successful on peer0.org1 on channel ===================================="
}

approveForMyOrg1() {
    setGlobalsForPeer0Org1
    set -x

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com --tls \
    --cafile $ORDERER_CA \
    --collections-config ${PRIVATE_DATA_CONFIG} \
    --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} --init-required --package-id ${PACKAGE_ID}
    echo "==================================== Chaincode approved from org 1 ===================================="
}

approveForMyOrg2() {
    setGlobalsForPeer0Org2
    set -x

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com --tls \
    --cafile $ORDERER_CA \
    --collections-config ${PRIVATE_DATA_CONFIG} \
    --channelID ${CHANNEL_NAME} --name ${CC_NAME} --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} --init-required --package-id ${PACKAGE_ID}
    echo "==================================== Chaincode approved from org 1 ===================================="
}

checkCommitReadyness(){
    setGlobalsForPeer0Org1

    peer lifecycle chaincode checkcommitreadiness \
    --ordererTLSHostnameOverride orderer.example.com --tls \
    --cafile $ORDERER_CA \
    --collections-config ${PRIVATE_DATA_CONFIG} \
    --channelID ${CHANNEL_NAME} --name ${CC_NAME} --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} --output json --init-required
    echo "==================================== checking commit readiness from org 1 ===================================="
}

commitChaincodeDefination(){
    setGlobalsForPeer0Org1
    
    peer lifecycle chaincode commit -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} \
    --collections-config $PRIVATE_DATA_CONFIG \
    --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE1 \
    --peerAddresses localhost:7053 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE2 \
    --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --init-required
}

queryCommitted() {
    setGlobalsForPeer0Org1
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}

chaincodeInvokeInit(){
    setGlobalsForPeer0Org1

    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${ORDERER_CA} \
    --peerAddresses localhost:7051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE1} \
    --peerAddresses localhost:7053 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE2} \
    --isInit -C '{"Args":["InitLedger"]}'
}

# presetup
packageChaincode
installChaincode
queryInstalled

# approveForMyOrg1
# approveForMyOrg2
checkCommitReadyness
commitChaincodeDefination
queryCommitted 
# chaincodeInvokeInit