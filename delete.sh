rm -R ./artifact
rm -R ./ledger
rm -R ./ledger2
rm -R ./crypto-config
docker rm -f  $(docker ps -aq)
docker volume prune
