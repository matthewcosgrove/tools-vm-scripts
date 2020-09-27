#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
apt_repo_name="jonathonf/vim"
if ! grep -q "${apt_repo_name}" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding PPA ${apt_repo_name}"
    sudo add-apt-repository ppa:"${apt_repo_name}" -y
fi

package="vim"
vim_version=$(vim --version | head -1 | cut -d ' ' -f 5)
echo "Detected Vim currently installed is version ${vim_version}"
sudo apt install bc -y
if [ $(echo "$vim_version < 8.0" | bc -l) -eq 1 ]; then
    echo "Installing ${package}..."
    sudo apt-get update
    sudo apt install "${package}" -y
else
    echo "vim version is ${vim_version}, skipping install.."
fi
echo "Installing vim plugins"
urls=( https://github.com/luan/vim-concourse \
https://github.com/hashivim/vim-hashicorp-tools.git \
https://github.com/pearofducks/ansible-vim.git \
)

for url in "${urls[@]}"
do
   suffix_gone=${url%".git"}
   repo_name=${suffix_gone##h*/} # Remove prefix with wildcard for http****/thisisthenameoftherepo.git where .git was already removed in previous line
   dir="/home/ubuntu/.vim/pack/$repo_name/start/$repo_name/"
   echo "${dir}"
   if [[ ! -d "${dir}" ]];then
     mkdir -p "${dir}"
     pushd "${dir}"
     git clone "${url}" || true
     popd
   else
     echo "${repo_name} exists, skipping..."
   fi
done
