echo "👉 Installing MesloLGS NF font..."

FONT_DIR="$HOME/.fonts/Meslo"
mkdir -p "$FONT_DIR"
cd /tmp

curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip -o Meslo.zip -d "$FONT_DIR"

echo "👉 Refreshing font cache..."
fc-cache -fv > /dev/null

if fc-list | grep -q "MesloLGS NF"; then
  echo "✅ MesloLGS NF installed successfully."
else
  echo "❌ Font install failed. You may need to reboot or install manually."
fi

