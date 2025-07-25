#!/bin/bash
set -e

echo "🎩 Installing and configuring Zsh..."

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
 echo "🎩 Installing Oh My Zsh..."
 sh -c "$(curl -fsSL https://nam10.safelinks.protection.outlook.com/?url=https%3A%2F%2Fraw.githubusercontent.com%2Fohmyzsh%2Fohmyzsh%2Fmaster%2Ftools%2Finstall.sh&data=05%7C02%7Cjmonge%40rvohealth.com%7Ce8f21892a7204eb81b5808ddcb133c93%7C00e1df3d9626410c898c16aaa8c2afc9%7C0%7C0%7C638890006151406207%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C80000%7C%7C%7C&sdata=YtVoAZrpKlXZQaDCH6VrrpA4ZZK%2BlMsqxh%2FMZsSxPfw%3D&reserved=0)" "" --unattended
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
ZSHRC="$HOME/.zshrc"

# Check if .zshrc exists
if [ ! -f "$ZSHRC" ]; then
 echo "📄 Creating .zshrc from scratch..."
 OVERWRITE=true
else
 echo "⚠️  A .zshrc file already exists at $ZSHRC."
 read -p "❓ Do you want to overwrite it? (y/N): " -r
 if [[ $REPLY =~ ^[Yy]$ ]]; then
   echo "🧹 Overwriting existing .zshrc..."
   OVERWRITE=true
 else
   echo "🛠 Skipping overwrite. Will try to update existing .zshrc safely."
   OVERWRITE=false
 fi
fi

if [ "$OVERWRITE" = true ]; then
 cat <<EOF > "$ZSHRC"
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
prompt_context() {}
plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker osx gradle)
source \$ZSH/oh-my-zsh.sh
. "\$HOME/.asdf/asdf.sh"
. "\$HOME/.asdf/completions/asdf.bash"
source \$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source \$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
PROMPT="%~ > "
zstyle ':omz:update' mode auto
EOF
else
 echo "🛠 Updating existing .zshrc..."

 # Replace or add theme
 if grep -q "^ZSH_THEME=" "$ZSHRC"; then
   sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$ZSHRC"
 else
   echo 'ZSH_THEME="agnoster"' >> "$ZSHRC"
 fi

 # Add prompt_context override before plugins line if not present
 if ! grep -q 'prompt_context()' "$ZSHRC"; then
   sed -i '' '/^plugins=/i\
prompt_context() {}
' "$ZSHRC"
 fi

 # Ensure correct plugins line
 sed -i '' '/^plugins=/d' "$ZSHRC"
 echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker docker-compose macos gradle)' >> "$ZSHRC"

 # Ensure OMZ sourcing
 if ! grep -q 'oh-my-zsh.sh' "$ZSHRC"; then
   echo 'source $ZSH/oh-my-zsh.sh' >> "$ZSHRC"
 fi

 # Ensure asdf is sourced
 if ! grep -q 'asdf.sh' "$ZSHRC"; then
   echo -e "\n# asdf version manager\n. \"\$HOME/.asdf/asdf.sh\"\n. \"\$HOME/.asdf/completions/asdf.bash\"" >> "$ZSHRC"
 fi

 # Ensure plugin source lines
 for plugin_file in \
   "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
   "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; do
   if ! grep -q "$plugin_file" "$ZSHRC"; then
     echo "source $plugin_file" >> "$ZSHRC"
   fi
 done

 # Ensure auto-update setting
 if ! grep -q "zstyle ':omz:update'" "$ZSHRC"; then
   echo "zstyle ':omz:update' mode auto" >> "$ZSHRC"
 fi
fi

# Install plugins if missing
echo "🔌 Installing Zsh plugins..."
git clone https://nam10.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fzsh-users%2Fzsh-autosuggestions&data=05%7C02%7Cjmonge%40rvohealth.com%7Ce8f21892a7204eb81b5808ddcb133c93%7C00e1df3d9626410c898c16aaa8c2afc9%7C0%7C0%7C638890006151437910%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C80000%7C%7C%7C&sdata=j3BgTurChqwDD6dPkfkZMMziiXyHg1Ei0ShfJrwTqew%3D&reserved=0 "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || true
git clone https://nam10.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fzsh-users%2Fzsh-syntax-highlighting.git&data=05%7C02%7Cjmonge%40rvohealth.com%7Ce8f21892a7204eb81b5808ddcb133c93%7C00e1df3d9626410c898c16aaa8c2afc9%7C0%7C0%7C638890006151453484%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C80000%7C%7C%7C&sdata=4blEzVgE5U%2B5ZJvPQFqUGsLs%2BbFe%2FPUqrFnCTLh0Axc%3D&reserved=0 "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || true

# Install Powerline fonts (skip if already installed)
POWERLINE_INSTALLED=$(find "$HOME/Library/Fonts" "$HOME/.local/share/fonts" -type f -iname "*Powerline*.ttf" 2>/dev/null | wc -l)

if [ "$POWERLINE_INSTALLED" -eq 0 ]; then
 echo "🔠 Installing Powerline fonts..."
 git clone https://nam10.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fpowerline%2Ffonts.git&data=05%7C02%7Cjmonge%40rvohealth.com%7Ce8f21892a7204eb81b5808ddcb133c93%7C00e1df3d9626410c898c16aaa8c2afc9%7C0%7C0%7C638890006151466514%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C80000%7C%7C%7C&sdata=lMIN7sHe%2BQ8oocsMMg6x%2BjmTJR1HTNJVOk4JZ2SXHSk%3D&reserved=0 --depth=1 /tmp/powerline-fonts
 /tmp/powerline-fonts/install.sh
 rm -rf /tmp/powerline-fonts
else
 echo "🔠 Powerline fonts already installed."
fi

echo "✅ Zsh setup complete. Please restart your terminal or run: source ~/.zshrc"
