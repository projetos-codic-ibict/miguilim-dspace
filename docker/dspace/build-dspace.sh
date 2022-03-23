#!/usr/bin/env bash

docker rm -f dspace_miguilim
docker rmi -f mrgurgel/dspace_miguilim
docker-compose -f ./docker-compose.yml up -d dspace
