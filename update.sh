#!/bin/sh
set -x
sudo apt update
sudo apt full-upgrade
sudo apt autoclean
sudo apt autoremove

