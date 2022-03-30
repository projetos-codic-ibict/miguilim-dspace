#!/usr/bin/env bash

docker rm -f bd_miguilim dspace_miguilim
docker rmi -f mrgurgel/postgres_miguilim mrgurgel/dspace_miguilim
docker-compose up -d