#!/usr/bin/env bash

# Pull latest version of all tagged images
docker images --format '{{.Repository}}:{{.Tag}}' | grep -v '<none>' | sort -u | xargs -L1 docker pull

# Remove exited containers
docker ps -qa --no-trunc --filter "status=exited" | xargs -r docker rm

# Remove dangling images
docker images --filter "dangling=true" -q --no-trunc | xargs -r docker rmi

# Clean up remaining build cache, networks, etc.
docker system prune -f
