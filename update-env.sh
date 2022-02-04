#!/usr/bin/env bash
set -x

git -C ~/.oh-my-zsh pull
#git -C ~/.bash_it pull

for d in ~/.vim/bundle/*; do
	echo "$d"
	cd "$d" || exit
	git fetch -p --all
	git pull
	cd || exit
done

for d in ~/.virtualenvs/*; do
	. "$d/bin/activate"
	pip install --upgrade pip setuptools wheel
	pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
	#pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
	deactivate
done

#npm outdated -g --depth=0
npm update -g

# this is now done via the deb package
#gcloud components update -q
