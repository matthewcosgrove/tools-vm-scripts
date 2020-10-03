#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
apt_repo_name="docker"
#if ! grep -q "${apt_repo_name}" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-get update
    sudo apt-get -y install \
                 apt-transport-https \
                 ca-certificates \
                 curl \
                 gnupg-agent \
                 software-properties-common
    echo "Adding PPA ${apt_repo_name}"
    wget -q -O - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#fi

package="docker-ce"
if ! hash "${package}" >/dev/null 2>&1; then
    echo "Installing ${package}..."
    sudo apt-get update
    apt-cache policy docker-ce
    sudo apt install "${package}" -y
    sudo apt install docker-ce-cli containerd.io -y
    sudo systemctl unmask docker.service
    sudo systemctl unmask docker.socket
    sudo systemctl start docker.service
    #sudo systemctl is-active --quiet docker && echo Service is running
    sudo systemctl is-active docker && echo Service is running
    sudo usermod -aG docker ${USER}
    echo "Your current groups are.."
    id -nG
    echo "Please run the following command or logout/login to become part of the docker group"
    echo "exec sudo su -l $USER"
else
    echo "${package} already installed, skipping.."
fi
