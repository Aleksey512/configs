# ==========================
# Powerlevel10k Instant Prompt (закомментировано)
# ==========================
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# ==========================
# Pyenv
# ==========================
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# ==========================
# NVM (Node Version Manager)
# ==========================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# ==========================
# Oh-My-Zsh
# ==========================
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Плагины для Oh-My-Zsh
plugins=(
  git
  docker-compose
  jsontools
  z
  docker
  fzf
  thefuck
  extract
  zsh-autosuggestions
  zsh-syntax-highlighting
  history
  poetry
)

source $ZSH/oh-my-zsh.sh

# ==========================
# Go
# ==========================
export GOPATH="$HOME/go"
export GOROOT="/usr/local/opt/go/libexec"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

# ==========================
# OpenJDK
# ==========================
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# ==========================
# Основные пути
# ==========================
export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$PATH"
export PATH="$HOME/bin:$PATH"

# ==========================
# Пользовательские алиасы
# ==========================
alias acpoet="source \"\$(poetry env info --path)/bin/activate\""
alias n="nvim"
alias cat="bat"
alias ls="lsd"
alias cls="clear"
alias fzf="fzf --preview 'bat --style=numbers --color=always --line-range=:100 {}'"

# ==========================
# FZF
# ==========================
eval "$(fzf --zsh)"

# ==========================
# Oh My Posh (альтернативный промпт)
# ==========================
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/space.omp.json)"

# ==========================
# Powerlevel9k (если вдруг используется)
# ==========================
# POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# ==========================
# Дополнительные настройки
# ==========================
. /usr/share/staff/profile 2>/dev/null
