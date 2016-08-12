#!/bin/sh
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get autoclean
sudo apt-get autoremove

docker images | grep -v talend | awk '{print $1":"$2}' | xargs -L1 docker pull

git -C ~/.oh-my-zsh pull
git -C ~/.bash_it pull

for d in ~/.vim/bundle/ ; do
  echo "$d"; cd "$d"; git fetch -p --all; git pull upstream; cd ..
done

for d in ~/upstream/ ; do
  echo "$d"; cd "$d"; git fetch -p --all; git pull upstream; cd ..
done

