#!/bin/sh
. update.sh

docker images | grep -v talend | awk '{print $1":"$2}' | xargs -L1 docker pull
docker rm $(docker ps -qa --no-trunc --filter "status=exited")
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)

git -C ~/.oh-my-zsh pull
git -C ~/.bash_it pull

for d in ~/.vim/bundle/* ; do
  echo "$d"; cd "$d"; git fetch -p --all; git pull; cd
done

for d in ~/upstream/* ; do
  echo "$d"; cd "$d"; git fetch -p --all; git pull; cd
done

npm outdated -g --depth=0
npm update -g

