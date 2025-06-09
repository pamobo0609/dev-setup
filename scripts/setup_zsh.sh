#!/bin/bash
set -e

echo "🎩 Installing and configuring Zsh..."

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🎩 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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
plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker docker-compose macos gradle)
source \$ZSH/oh-my-zsh.sh
. "\$HOME/.asdf/asdf.sh"
. "\$HOME/.asdf/completions/asdf.bash"
source \$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source \$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || true

# Install Powerline fonts (skip if
