#!/bin/bash

# Скрипт установки всех зависимостей из .zshrc для macOS и Linux (apt/pacman)
# Запуск: bash install_deps.sh

set -e  # Выход при ошибке

# Определение ОС и пакетного менеджера
OS=$(uname -s)
PKG_MANAGER=""
PKG_INSTALL=""
DISTRO=""

if [[ "$OS" == "Linux" ]]; then
    if [[ -f /etc/os-release ]]; then
        DISTRO=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
    fi

    # Определение пакетного менеджера
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        PKG_INSTALL="sudo apt-get install -y"
        sudo apt-get update
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        PKG_INSTALL="sudo pacman -S --noconfirm"
        sudo pacman -Sy
    else
        echo "Неизвестный пакетный менеджер. Поддерживаются только apt и pacman."
        exit 1
    fi
fi

# Установка Homebrew (если нет)
install_brew() {
    if ! command -v brew &> /dev/null; then
        echo "Установка Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ "$OS" == "Linux" ]]; then
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
            source ~/.bashrc
        else
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
            source ~/.zshrc
        fi
    fi
}

# Установка Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        echo "Установка Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
}

# Установка плагинов Zsh
install_zsh_plugins() {
    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    mkdir -p "$plugins_dir"
    
    # Список плагинов и их репозиториев
    local plugins=(
        "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
        "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "z https://github.com/agkozak/zsh-z"
    )

    for plugin in "${plugins[@]}"; do
        local name=$(echo "$plugin" | awk '{print $1}')
        local url=$(echo "$plugin" | awk '{print $2}')
        if [[ ! -d "$plugins_dir/$name" ]]; then
            echo "Установка плагина $name..."
            git clone "$url" "$plugins_dir/$name"
        fi
    done
}

# Установка pyenv
install_pyenv() {
    if ! command -v pyenv &> /dev/null; then
        echo "Установка pyenv..."
        curl https://pyenv.run | bash
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
    fi
}

# Установка NVM
install_nvm() {
    if [[ ! -d "$HOME/.nvm" ]]; then
        echo "Установка NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi
}

# Установка Go
install_go() {
    if ! command -v go &> /dev/null; then
        echo "Установка Go..."
        if [[ "$OS" == "Darwin" ]]; then
            brew install go
        elif [[ "$PKG_MANAGER" == "apt" ]]; then
            $PKG_INSTALL golang
        elif [[ "$PKG_MANAGER" == "pacman" ]]; then
            $PKG_INSTALL go
        fi
        mkdir -p "$HOME/go"
    fi
}

# Установка OpenJDK
install_openjdk() {
    if ! command -v javac &> /dev/null; then
        echo "Установка OpenJDK..."
        if [[ "$OS" == "Darwin" ]]; then
            brew install openjdk
        elif [[ "$PKG_MANAGER" == "apt" ]]; then
            $PKG_INSTALL openjdk-17-jdk
        elif [[ "$PKG_MANAGER" == "pacman" ]]; then
            $PKG_INSTALL jdk-openjdk
        fi
    fi
}

# Установка инструментов (bat, lsd, fzf, etc.)
install_tools() {
    echo "Установка инструментов..."
    
    if [[ "$OS" == "Darwin" ]]; then
        # Установка для macOS
        brew install bat lsd fzf thefuck neovim poetry
        
    elif [[ "$PKG_MANAGER" == "apt" ]]; then
        # Установка для apt (Ubuntu/Debian)
        sudo apt-get install -y bat lsd fzf thefuck neovim python3-poetry
        sudo ln -s /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true
        
    elif [[ "$PKG_MANAGER" == "pacman" ]]; then
        # Установка для pacman (Arch Linux)
        sudo pacman -S --noconfirm bat lsd fzf thefuck neovim python-poetry
    fi

    # Установка Oh My Posh
    if ! command -v oh-my-posh &> /dev/null; then
        echo "Установка Oh My Posh..."
        if [[ "$OS" == "Darwin" ]]; then
            brew install jandedobbeleer/oh-my-posh/oh-my-posh
        else
            sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-$(uname -m) -O /usr/local/bin/oh-my-posh
            sudo chmod +x /usr/local/bin/oh-my-posh
        fi
        mkdir -p ~/.config/ohmyposh
        curl -s https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/space.omp.json -o ~/.config/ohmyposh/space.omp.json
    fi
}

# Основной процесс установки
main() {
    install_brew
    install_oh_my_zsh
    install_zsh_plugins
    install_pyenv
    install_nvm
    install_go
    install_openjdk
    install_tools
    
    echo -e "\n\033[1;32mУстановка завершена!\033[0m"
    echo "Перезагрузите терминал или выполните:"
    echo "exec zsh"
}

main
