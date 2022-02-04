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
