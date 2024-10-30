set -e

sudo apt -y update
sudo apt install -y ack curl htop fzf fuse ripgrep universal-ctags 'g++' git-lfs shellcheck
pip install black isort pynvim

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Load nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install node
npm install -g pyright
npm install -g bash-language-server

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim.appimage

# echo "TERM=ansi-256color nvim.appimage" > nvim
# chmod u+x nvim
# sudo mv nvim /usr/local/bin/nvim

echo -e '#!/bin/sh\nTERM=ansi-256color /usr/local/bin/nvim.appimage "$@"' > nvim
chmod u+x nvim
sudo mv nvim /usr/local/bin/nvim

# Optional?
rm -rf ~/.config/nvim
git clone https://github.com/eloaf/nvim.git ~/.config/nvim
