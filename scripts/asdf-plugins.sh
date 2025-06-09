#!/bin/bash
set -e

# Ensure asdf is initialized
. "$HOME/.asdf/asdf.sh"

# Add required plugins
plugins=(java python ruby nodejs)

for plugin in "${plugins[@]}"; do
  asdf plugin add "$plugin" || true
done
