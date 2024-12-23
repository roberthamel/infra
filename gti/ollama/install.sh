#!/usr/bin/env/bash
set -eEuo pipefail

echo "Installing Ollama"
curl -fsSL https://ollama.com/install.sh | sh

# add environment variables to ollama.service file
# [Unit]
# Description=Ollama Service
# After=network-online.target

# [Service]
# Environment="OLLAMA_HOST=0.0.0.0"
# Environment="OLLAMA_INTEL_GPU=1"
# Environment="OLLAMA_NUM_GPU=2"
# ExecStart=/usr/local/bin/ollama serve
# User=ollama
# Group=ollama
# Restart=always
# RestartSec=3
# Environment="PATH=/home/rh/.vscode-server/cli/servers/Stable-fabdb6a30b49f79a7aba0f2ad9df9b399473380f/server/bin/remote-cli:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/rh/.vscode-server/data/User/globalStorage/github.copilot-chat/debugCommand"

# [Install]
# WantedBy=default.target
