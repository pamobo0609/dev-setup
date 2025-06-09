#!/bin/bash
set -e
. "$HOME/.asdf/asdf.sh"

echo "📦 Installing tool versions from .tool-versions"
asdf install
