#!/bin/sh
set -x
sudo apt update
sudo apt -y full-upgrade
sudo apt autoclean
sudo apt autoremove

. update-projects.sh
