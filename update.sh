#!/bin/sh
set -x
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get autoclean
sudo apt-get autoremove

