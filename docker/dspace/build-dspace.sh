#!/usr/bin/env bash

sudo docker rm -f dspace_miguilim
sudo docker rmi -f $(docker images --filter=reference='mrgurgel/dspace:*' --format "{{.ID}}")
sudo docker-compose -f ./docker-compose.yml up -d dspace
