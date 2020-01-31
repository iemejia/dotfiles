#!/bin/sh
set -x

for d in ~/upstream/* ; do
  echo "$d"; cd "$d"; git fetch -p --all; git pull; cd
done

for d in ~/upstream-talend/* ; do
  echo "$d"; cd "$d"; git fetch -p --all; git pull; cd
done
