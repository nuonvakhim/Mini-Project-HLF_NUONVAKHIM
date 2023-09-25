docker container stop couchdb1
docker container rm -f couchdb1

docker container stop couchdb2
docker container rm -f couchdb2


docker run -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=password --name=couchdb1 -p 5895:5984 -d couchdb:3.1.1 --restart unless-stopped
docker run -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=password --name=couchdb2 -p 5896:5984 -d couchdb:3.1.1 --restart unless-stopped


sleep 3s

curl localhost:5895
curl localhost:5896
 