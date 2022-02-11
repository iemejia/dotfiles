#!/bin/sh

./update-env.sh
if [[ "$OSTYPE" == "darwin"* ]]; then
    ./update-mac.sh
else
    ./update-linux.sh
fi
./update-docker.sh
./update-repositories.sh

