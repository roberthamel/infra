#!/usr/bin/env bash
set -eEo pipefail

dofiles_repo=https://github.com/roberthamel/dotfiles-macos.git
file_marker="$HOME/.local/macos-configured"

main() {
  did_install_dotfiles=false

  echo "::: Homebrew"
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null
    brew install mas
    echo "✅ Installed Homebrew"
  else
    echo "Skipping Homebrew installation"
  fi

  echo "::: Create Brewfile"
  cat <<EOF > $HOME/.Brewfile
brew "zsh"
brew "bash"
brew "bat"
brew "chezmoi"
brew "cloudflared"
brew "ctop"
brew "devcontainer"
brew "direnv"
brew "fzf"
brew "git-crypt"
brew "git-lfs"
brew "git"
brew "jq"
brew "k9s"
brew "kubectx"
brew "kubernetes-cli"
brew "lsd"
brew "mkcert"
brew "ncdu"
brew "nmap"
brew "ripgrep"
brew "sqlite"
brew "tea"
brew "tmux"
brew "tree"
brew "watch"
brew "wget"
brew "yq"

cask "1password"
cask "1password-cli"
cask "alfred"
cask "balenaetcher"
cask "docker"
cask "iterm2"
cask "obsidian"
cask "rectangle"
cask "the-unarchiver"
cask "visual-studio-code"

mas "Display Menu", id: 549_083_868
mas "Draw Things: AI Generation", id: 6_444_050_820
mas "PopClip", id: 445_189_367
mas "SnippetsLab", id: 1_006_087_419
mas "SSH Config Editor", id: 1_109_319_285
mas "Tailscale", id: 1_475_387_142
EOF

  echo "::: devbox"
  if ! command -v devbox &> /dev/null; then
    curl -fsSL https://get.jetify.com/devbox | bash
    echo "✅ Installed devbox"
  else
    echo "Skipping devbox installation"
  fi

  echo "::: oh-my-zsh"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    export SHELL=/bin/zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null
    echo "✅ Installed oh-my-zsh"
  else
    echo "Skipping oh-my-zsh installation"
  fi

  echo "::: dotfiles"
  if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $dotfiles_repo
    did_install_dotfiles=true
    echo "✅ Configured dotfiles"
  else
    echo "Skipping dotfiles configuration"
  fi

  echo "::: Install from Brewfile"
  pushd $HOME > /dev/null
    if ! command -v mas &> /dev/null; then
      echo "Installing mas"
      brew install mas
    fi
    brew bundle --global --no-lock --force

  popd > /dev/null

  echo "::: MacOS"
  if [ ! -d "$file_marker" ]; then
    # Disable the sound effects on boot
    sudo nvram SystemAudioVolume=" "
    # Increase window resize speed for Cocoa applications
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
    # Finder: disable window animations and Get Info animations
    defaults write com.apple.finder DisableAllAnimations -bool true
    # Finder: show path bar
    defaults write com.apple.finder ShowPathbar -bool true
    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    # Show the ~/Library folder
    chflags nohidden $HOME/Library
    # Wipe all (default) app icons from the Dock
    # This is only really useful when setting up a new Mac, or if you don’t use
    # the Dock to launch apps.
    defaults write com.apple.dock persistent-apps -array
    # Show only open applications in the Dock
    defaults write com.apple.dock static-only -bool true
    # Remove the auto-hiding Dock delay
    defaults write com.apple.dock autohide-delay -float 0
    # Remove the animation when hiding/showing the Dock
    defaults write com.apple.dock autohide-time-modifier -float 0
    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true
    # Only use UTF-8 in Terminal.app
    defaults write com.apple.terminal StringEncodings -array 4
    # Don’t display the annoying prompt when quitting iterm
    defaults write com.googlecode.iterm2 PromptOnQuit -bool false

    # Save a file to mark that this process has been completed successfully at least once
    touch $file_marker
  fi

  echo "::: directories"
  mkdir -p $HOME/workspace
  echo "✅ Created directories"
}
start_time=$(date +%s)
main
end_time=$(date +%s)
elapsed_time=$(($end_time - $start_time))
minutes=$(($elapsed_time / 60))
seconds=$(($elapsed_time % 60))
echo "Elapsed time: $minutes minute(s) $seconds second(s)"
echo "exit $?"
