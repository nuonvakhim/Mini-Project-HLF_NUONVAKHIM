export FABRIC_CFG_PATH=./config
configtxgen -outputBlock ./artifact/genesis.block  -channelID genesis  -profile TwoOrgsApplicationGenesis