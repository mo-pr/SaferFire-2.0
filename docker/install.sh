#!/bin/sh

GITHUB_USER=$1
ACCESS_TOKEN=$2

echo $ACCESS_TOKEN | docker login ghcr.io --username $GITHUB_USER --password-stdin

docker-compose pull ghcr.io/mo-pr/SaferFire-Backend:latest
docker-compose run -d -p 3030:3030 --name SaferFire-2.0 SaferFire-Backend

exit