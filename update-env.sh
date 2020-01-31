#!/bin/sh
set -x

git -C ~/.oh-my-zsh pull
git -C ~/.bash_it pull

for d in ~/.vim/bundle/* ; do
  echo "$d"; cd "$d"; git fetch -p --all; git pull; cd
done

. ~/.virtualenvs/python3/personal/bin/activate
pip install --upgrade pip setuptools wheel
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
deactivate

. ~/.virtualenvs/python3/work/bin/activate
pip install --upgrade pip setuptools wheel
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
deactivate

#npm outdated -g --depth=0
npm update -g

# this is now done via the deb package
#gcloud components update -q
