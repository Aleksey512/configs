## Installation
```sh
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

- Execute the commands to install:

```sh
sudo pacman -S git npm  # Arch
sudo apt install git npm  # Debian
brew install git npm  # MacOS
```

```sh
mkdir -p ~/.config/nvim
git clone https://github.com/Aleksey512/configs.git
mv ./configs/neovim/* ~/.config/nvim/
nvim -c "MasonInstall pyright ruff-lsp mypy gopls"
```
