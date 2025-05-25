#!/bin/bash
set -e

echo "👉 Installing base packages..."
sudo apt update && sudo apt install -y \
  zsh curl git tmux btop fzf unzip lsd python3-pip

echo "👉 Installing lazygit..."
LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz

echo "👉 Setting Zsh as default shell..."
chsh -s "$(which zsh)"

echo "👉 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  export RUNZSH=no
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "👉 Installing Powerlevel10k..."
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

echo "👉 Installing Zsh plugins..."
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "👉 Updating ~/.zshrc..."
cat > ~/.zshrc <<'EOF'
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git docker python node aws kubectl postgres zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias ls='lsd'
alias ll='ls -l'
alias la='ls -a'
alias lg='lazygit'
alias bt='btop'
alias mux='tmux'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -Uz compinit
zstyle ':completion:*' menu select
compinit

[[ $(command -v kubectl) ]] && source <(kubectl completion zsh)
[[ -f /usr/share/bash-completion/completions/docker ]] && source /usr/share/bash-completion/completions/docker
[[ -x $(command -v aws_completer) ]] && complete -C "$(which aws_completer)" aws
EOF

echo "✅ Done. Run 'zsh' or restart your terminal."

