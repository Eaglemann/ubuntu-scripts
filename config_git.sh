#!/bin/bash
set -e

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "👉 Installing Git..."
  sudo apt update && sudo apt install -y git
fi

# Ask for your name and email
read -p "📛 Enter your full name for Git commits: " git_name
read -p "📧 Enter your email for Git commits: " git_email

echo "👉 Configuring Git user..."
git config --global user.name "$git_name"
git config --global user.email "$git_email"

echo "👉 Setting common Git defaults..."
git config --global core.editor "nano"
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global core.autocrlf input
git config --global pull.rebase false

echo "👉 Generating SSH key..."
ssh_key="$HOME/.ssh/id_ed25519"
if [ ! -f "$ssh_key" ]; then
  ssh-keygen -t ed25519 -C "$git_email" -f "$ssh_key" -N ""
  eval "$(ssh-agent -s)"
  ssh-add "$ssh_key"
else
  echo "✅ SSH key already exists: $ssh_key"
fi

echo "🔑 Your public SSH key:"
cat "$ssh_key.pub"

echo ""
echo "🛠  Add the above SSH key to your GitHub/GitLab account."
echo "🔗 GitHub: https://github.com/settings/keys"
echo "🔗 GitLab: https://gitlab.com/-/profile/keys"
echo "✅ Git is now configured."

