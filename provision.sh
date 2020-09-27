#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONFIG_DIR="${SCRIPT_DIR}/dotfiles"

"${SCRIPT_DIR}"/install_vim.sh
"${SCRIPT_DIR}"/install_fzf.sh

echo "Installing fundamental packages"
sudo apt install bash-completion shellcheck tree gnupg wget nmap -y

echo "Cloning BUCC wrapper project"
git clone --recurse-submodules https://github.com/matthewcosgrove/lab-ops.git /home/ubuntu/lab-ops || true

ln -nsf "${CONFIG_DIR}"/.bash_aliases /home/ubuntu/.bash_aliases
ln -nsf "${CONFIG_DIR}"/.functions /home/ubuntu/.functions
ln -nsf "${CONFIG_DIR}"/.vimrc /home/ubuntu/.vimrc
