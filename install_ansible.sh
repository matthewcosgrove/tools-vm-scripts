#!/bin/bash
set -euo pipefail

sudo apt-get update
sudo apt-get install python python3 python3-pip -y
echo "Installing Ansible based on official docs https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-with-pip"
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py --user
python -m pip install --user ansible
ls /usr/bin/python*
python --version
python3 --version
pip3 --version
