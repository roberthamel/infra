#!/usr/bin/env bash
set -eEo pipefail

dofiles_repo=https://github.com/roberthamel/dotfiles-macos.git
file_marker="$HOME/.local/macos-configured"

mas_apps=(
  "Display Menu"
  "Draw Things: AI Generation"
  "PopClip"
  "SnippetsLab"
  "SSH Config Editor"
  "Tailscale"
)

cask_apps=(
  "1password"
  "1password-cli"
  "alfred"
  "balenaetcher"
  "docker"
  "iterm2"
  "obsidian"
  "rectangle"
  "the-unarchiver"
  "visual-studio-code"
)

brew_apps=(
  "ansible"
  "argocd"
  "bash"
  "bandcamp-dl"
  "bat"
  "buf"
  "bun"
  "chezmoi"
  "cloudflared"
  "ctop"
  "deno"
  "devcontainer"
  "direnv"
  "ffmpeg"
  "fzf"
  "gh"
  "git-crypt"
  "git-lfs"
  "git"
  "go"
  "helm"
  "htop"
  "jq"
  "k3d"
  "k9s"
  "kubectx"
  "kubernetes-cli"
  "lsd"
  "mas"
  "mkcert"
  "ncdu"
  "nmap"
  "node"
  "operator-sdk"
  "protobuf"
  "python@3.10"
  "ripgrep"
  "sqlite"
  "starship"
  "tea"
  "tmux"
  "tree"
  "watch"
  "wget"
  "yt-dlp"
  "yq"
  "zsh"
  "zsh-autosuggestions"
  "zsh-syntax-highlighting"
  "zsh-fast-syntax-highlighting"
  "zsh-autocomplete"
  "zsh-autopair"
)

main() {
  did_install_dotfiles=false
  echo "::: Homebrew"
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null
    echo "✅ Installed Homebrew"
  else
    echo "Skipping Homebrew installation"
  fi

  echo "::: Tap homebrew/cask-fonts"
  if ! brew tap | grep -q 'homebrew/cask-fonts' > /dev/null; then
    brew tap homebrew/cask-fonts > /dev/null
    echo "✅ Tapped homebrew/cask-fonts"
    brew install homebrew/cask-fonts/font-meslo-lg-nerd-font > /dev/null
  else
    echo "Skipping homebrew/cask-fonts tap"
  fi
  # brew install homebrew/cask-fonts/font-meslo-lg-nerd-font

  echo "::: Homebrew casks"
  for app in "${cask_apps[@]}"; do
    if ! brew list --casks --versions "$app" > /dev/null; then
      brew install --force --cask "$app" > /dev/null
      echo "✅ Installed $app"
    else
      echo "Skipping $app installation"
    fi
  done

  echo "::: Homebrew packages"
  for app in "${brew_apps[@]}"; do
    if ! brew list --versions "$app" > /dev/null; then
      brew install --force --overwrite "$app" > /dev/null
      echo "✅ Installed $app"
    else
      echo "Skipping $app installation"
    fi
  done

  echo "::: rust"
  if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null
    echo "✅ Installed rust"
  else
    echo "Skipping rust installation"
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
    chezmoi init --apply $dotfiles_repo > /dev/null
    did_install_dotfiles=true
    echo "✅ Configured dotfiles"
  else
    echo "Skipping dotfiles configuration"
  fi

  echo "::: App Store apps"
  for app in "${mas_apps[@]}"; do
    if ! mas list | grep -q "$app"; then
      mas lucky "$app" > /dev/null
      echo "✅ Installed $app"
    else
      echo "Skipping $app installation"
    fi
  done

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
  set -x
  mkdir -p $HOME/workspace
  set +x > /dev/null
}
start_time=$(date +%s)
main
end_time=$(date +%s)
elapsed_time=$(($end_time - $start_time))
minutes=$(($elapsed_time / 60))
seconds=$(($elapsed_time % 60))
echo "Elapsed time: $minutes minute(s) $seconds second(s)"
echo "exit $?"
