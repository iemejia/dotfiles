#!/bin/sh
set -x
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y autoclean
sudo apt-get -y autoremove

