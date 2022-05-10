#!/bin/sh

GITHUB_USER=$1
ACCESS_TOKEN=$2

echo $ACCESS_TOKEN | docker login ghcr.io --username $GITHUB_USER --password-stdin

docker-compose pull
docker-compose run -d --name SaferFire-Backend saferfire-backend

exit