#!/bin/sh

GITHUB_USER=$1
ACCESS_TOKEN=$2

echo $ACCESS_TOKEN | docker login ghcr.io --username $GITHUB_USER --password-stdin

docker-compose pull ghcr.io/mo-pr/saferfire
docker-compose up -d

exit