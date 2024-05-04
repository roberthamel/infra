# Scripts and configurations to manage my homelab

- commands can be run locally using curl
- uses terraform to manage deploying kubernetes clusters
  - k3d
  - k3s
- scripts to deploy new VM's to proxmox
- separate configurations for each server - this repo acts as current state

## Capabilities

### General MacOS

Configure a freshly formatted MacOS machine with an install script. Reboot the machine after the script completes.

```bash
curl -fsSL https://raw.githubusercontent.com/roberthamel/infra/main/scripts/macos/install.sh | sh
```
