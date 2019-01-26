#!/bin/sh
. update.sh
. update-docker.sh

git -C ~/.oh-my-zsh pull
git -C ~/.bash_it pull

for d in ~/.vim/bundle/* ; do
  echo "$d"; cd "$d"; git fetch -p --all; git pull; cd
done

for d in ~/upstream/* ; do
  echo "$d"; cd "$d"; git fetch -p --all; git pull; cd
done

. ~/.virtualenvs/python2/personal/bin/activate
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
deactivate

. ~/.virtualenvs/python2/work/bin/activate
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
deactivate

#npm outdated -g --depth=0
npm update -g

# this is now done via the deb package
#gcloud components update -q

