export FABRIC_CFG_PATH=./config

configtxgen -outputCreateChannelTx ./artifact/mychannel.tx -profile TwoOrgsApplicationGenesis -channelID mychannel  