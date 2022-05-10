#!/bin/sh

GITHUB_USER=$1
ACCESS_TOKEN=$2

echo $ACCESS_TOKEN | docker login ghcr.io --username $GITHUB_USER --password-stdin

docker-compose pull
docker-compose run -d -p 3030:3030 --name SaferFire saferfire-backend
docker exec -it SaferFire bash
pm2 start ./dist/main.js
pm2 startup
pm2 save 

exit