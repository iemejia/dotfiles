#!/bin/sh

docker images | grep -v talend | awk '{print $1":"$2}' | xargs -L1 docker pull
docker rm $(docker ps -qa --no-trunc --filter "status=exited")
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
docker system prune -f

