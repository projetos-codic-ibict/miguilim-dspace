#!/usr/bin/env bash

docker rm -f dspace_miguilim
docker rmi -f $(docker images --filter=reference='mrgurgel/dspace:*' --format "{{.ID}}")
docker-compose -f ./docker-compose.yml up -d dspace
