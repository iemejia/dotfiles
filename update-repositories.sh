#!/bin/sh
set -x

for d in ~/apache/*; do
	echo "$d"
	cd "$d"
	git fetch -p --all
	git pull
	cd || exit
done

for d in ~/microsoft/*; do
	echo "$d"
	cd "$d"
	git fetch -p --all
	git pull
	cd || exit
done

for d in ~/repositories/*; do
	echo "$d"
	cd "$d"
	git fetch -p --all
	git pull
	cd || exit
done

for d in ~/projects/*; do
	echo "$d"
	cd "$d"
	git fetch -p --all
	git pull
	cd || exit
done

for d in ~/svnprojects/*; do
	echo "$d"
	cd "$d"
	svn update
	cd || exit
done
