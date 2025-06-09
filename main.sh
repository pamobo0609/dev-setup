#!/bin/bash
set -e

echo "🚀 Starting full macOS dev setup..."

# Load shell env for Homebrew (for M1/M2 Macs)
eval "$(/opt/homebrew/bin/brew shellenv)"

# 1. Install Homebrew if missing
if ! command -v brew >/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Install Homebrew packages via Brewfile
echo "📦 Installing Brew packages..."
brew bundle --file=Brewfile

# 3. Install asdf if missing
if [ ! -d "$HOME/.asdf" ]; then
  echo "🧩 Installing asdf version manager..."
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
fi

# Source asdf for this session
. "$HOME/.asdf/asdf.sh"

# 4. Add asdf plugins
echo "🔌 Adding asdf plugins..."
./scripts/asdf-plugins.sh

# 5. Install tool versions
echo "🔢 Installing versions from .tool-versions..."
cp .tool-versions ~/
./scripts/setup_asdf.sh

# 6. Set up Oh My Zsh and plugins
echo "🎨 Setting up Zsh with Oh My Zsh and plugins..."
./scripts/setup_zsh.sh

# 7. Apply global Git config from Gist
echo "⚙️ Downloading global Git config from Gist..."
curl -fsSL https://gist.githubusercontent.com/rafasolcr/e9540aa8942a4104ef40aa1c32ee3a68/raw/58d13572331528094338b1e0cd57002a26e51676/.gitconfig -o ~/.gitconfig
echo "✅ Git config applied from Gist"

echo "✅ All done! Please restart your terminal or run: source ~/.zshrc"
