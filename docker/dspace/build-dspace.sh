#!/usr/bin/env bash

docker rm -f dspace
docker rmi -f $(docker images --filter=reference='mrgurgel/dspace:*' --format "{{.ID}}")
docker build --build-arg PROJECT_NAME=dspace6-treinamento  -t mrgurgel/dspace /Users/mrgurgel/git/docker-dspace/dspace/
docker run -d --name dspace --network nw-dspace mrgurgel/dspace

