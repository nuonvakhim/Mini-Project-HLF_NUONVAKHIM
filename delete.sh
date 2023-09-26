sudo rm -R ./artifact
sudo rm -R ./ledger1
sudo rm -R ./ledger2
sudo rm -R ./crypto-config
docker rm -f  $(docker ps -aq)
docker volume prune
sudo rm -R ./basic.tar.gz
sudo rm -R ./log.txt
