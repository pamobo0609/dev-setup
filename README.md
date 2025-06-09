# 🍎 mac-dev-setup

Automated setup script for macOS development environment using:

- [Homebrew](https://brew.sh)
- [asdf](https://asdf-vm.com)
- [oh-my-zsh](https://ohmyz.sh)
- Common dev tools: VS Code, Docker, Postman, Android Studio, etc.

## ⚙️ What It Installs

- GUI apps (via Homebrew Casks)
- CLI tools (via Homebrew)
- Java, Python, Ruby, Node (via asdf)
- iTerm2 + Zsh + Plugins

## ⚙️ Prerequisites
- Xcode Command Line Tools: `xcode-select --install`

## 📦 Installation

```bash
git clone https://github.com/yourusername/mac-dev-setup.git
cd mac-dev-setup
chmod +x main.sh scripts/*.sh
./main.sh
