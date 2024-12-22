#!/usr/bin/env bash
set -eEuo pipefail

. .envrc

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Running on macOS. Checking for Xcode Command Line Tools..."
  if ! xcode-select -p &>/dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    echo "Please follow the prompts to complete the installation."
    exit 1
  else
    echo "Xcode Command Line Tools are already installed."
  fi
fi

if [[ ! -d "$HOME/workspace" || ! -d "$HOME/workspace/infra" ]]; then
  echo "Creating workspace directory..."
  mkdir -p $HOME/workspace
  echo "Cloning infra repository..."
  git clone https://github.com/roberthamel/infra.git $HOME/workspace/infra
fi

cd $HOME/workspace/infra
read -p "Please enter the hostname: " hostname
echo "Initializing $hostname"
cd $hostname
exec ./install.sh
