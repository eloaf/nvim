sudo apt -y update
sudo apt install -y npm nodejs ack curl htop fzf fuse
sudo npm install -g pyright
pip install black isort

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim.appimage
echo "TERM=ansi-256color nvim.appimage" > nvim
chmod u+x nvim
sudo mv nvim /usr/local/bin/nvim

# Optional?
rm -r ~/.config/nvim
git clone https://github.com/eloaf/nvim.git ~/.config/nvim
