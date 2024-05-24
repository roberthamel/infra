#!/usr/bin/env bash
set -Eeuo pipefail

_log() {
  local msg="${1}"
  echo -e "🟢 \033[1;33m${msg}\033[0m"
}

export is_root=false
if [[ $EUID == 0 ]]; then
  is_root=true
  _log "Detected root user and assuming proxmox environment"
  _log "Checking environment variables..."
  set +u
  vm_password=${PROXMOX_USER_PASSWORD:?PROXMOX_USER_PASSWORD must be set}
  pk=${PROXMOX_PUBLIC_KEY:?PROXMOX_PUBLIC_KEY must be set}
  set -u
else
  _log "Detected non-root user and assuming vm environment"
fi

install_omz() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    # https://github.com/ohmyzsh/ohmyzsh#unattended-install
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    cat <<EOF >~/.zshrc
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(docker direnv git git-commit gitignore wd)
source \$ZSH/oh-my-zsh.sh
export PROMPT='%{\$fg_bold[green]%}%p%(?:%{%}➜ :%{%}➜ ) %(!.%{%F{yellow}%}.)\$USER@%{\$fg[white]%}%M %{\$fg[cyan]%}%c%{\$reset_color%} \$(git_prompt_info)'
EOF
  else
    _log "oh-my-zsh already installed"
  fi
}

install_tailscale() {
  if ! command -v tailscale &>/dev/null; then
    _log "Installing tailscale"
    curl -fsSL https://tailscale.com/install.sh | sh
  else
    _log "tailscale already installed"
  fi
}

install_docker() {
  if ! command -v docker &>/dev/null; then
    curl -fsSL https://get.docker.com | sudo sh
    if [[ ! $is_root ]]; then
      _log "Adding user to docker group"
      sudo usermod -aG docker $USER
      newgrp docker
    fi
  else
    _log "docker already installed"
  fi
}

install_apt() {
  if [[ ! -f ~/.apt_installed ]]; then
    _log "Installing apt packages"
    local maybe_sudo=""
    if [[ $is_root == false ]]; then
      sudo apt update && sudo apt install -y curl git zsh vim direnv qemu-guest-agent
    else
      apt update && sudo apt install -y curl git zsh vim direnv
    fi
    touch ~/.apt_installed
  else
    _log "apt packages already installed"
  fi
}

maybe_install_k3s() {
  if [[ $is_root == false && ! -f ~/.k3s_installed  ]]; then
    _log "Installing k3s"
    curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode=644 --docker --disable=traefik
    touch ~/.k3s_installed
  else
    _log "k3s already installed"
  fi
}

# Function to check if a file was modified in the last 24 hours or doesn't exist
_should_download_image() {
  local file="$1"
  # If file doesn't exist, return true (i.e., should download)
  [[ ! -f "$file" ]] && return 0
  local current_time=$(date +%s)
  local file_mod_time=$(stat --format="%Y" "$file")
  local difference=$((current_time - file_mod_time))
  # If older than 24 hours, return true
  ((difference >= 86400))
}

maybe_create_proxmox_template() {
  if [[ $is_root == true ]]; then
    VM_ID=9000
    UBUNTU_VERSION="noble"
    IMAGE_PATH_DIRNAME="/root/cloud-images"
    mkdir -p "${IMAGE_PATH_DIRNAME}"
    DISK_IMAGE="${UBUNTU_VERSION}-server-cloudimg-amd64.img"
    ABSOLUTE_IMAGE_PATH="${IMAGE_PATH_DIRNAME}/${DISK_IMAGE}"
    IMAGE_URL="https://cloud-images.ubuntu.com/${UBUNTU_VERSION}/current/${DISK_IMAGE}"

    # Download the disk image if it doesn't exist or if it was modified more than 24 hours ago
    _log "Checking if disk image needs to be downloaded..."
    if _should_download_image "${DISK_IMAGE}"; then
      rm -f "${ABSOLUTE_IMAGE_PATH}"
      wget -O ${ABSOLUTE_IMAGE_PATH} ${IMAGE_URL}
    fi

    _log "Creating authorized_keys file..."
    echo "${pk}" >/tmp/authorized_keys

    _log "Creating VM..."
    qm create $VM_ID \
      --name "${UBUNTU_VERSION}-server" \
      --memory 2048 \
      --balloon 0 \
      --net0 virtio,bridge=vmbr0 \
      --cores 2 \
      --sockets 2 \
      --cpu cputype=host \
      --net0 virtio,bridge=vmbr0,firewall=1 \
      --serial0 socket \
      --vga serial0 \
      --agent enabled=1 \
      --ciuser rh \
      --cipassword $vm_password \
      --sshkeys /tmp/authorized_keys \
      --ipconfig0 ip=dhcp,ip6=dhcp

    _log "Importing disk image..."
    qm importdisk $VM_ID $ABSOLUTE_IMAGE_PATH local-lvm

    _log "Setting VM properties..."
    qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$VM_ID-disk-0,size=36352M,ssd=1
    qm set $VM_ID --boot c --bootdisk scsi0
    qm set $VM_ID --ide2 local-lvm:cloudinit
    qm set $VM_ID --autostart 1

    _log "Creating VM template..."
    qm template $VM_ID
  else
    _log "Skipping proxmox template creation"
  fi
}

main() {
  install_apt
  install_docker
  install_tailscale
  install_omz
  maybe_install_k3s
  maybe_create_proxmox_template
}

start_time=$(date +%s)
main
end_time=$(date +%s)
elapsed_time=$(($end_time - $start_time))
minutes=$(($elapsed_time / 60))
seconds=$(($elapsed_time % 60))
echo "Elapsed time: $minutes minute(s) $seconds second(s)"
echo "exit $?"
