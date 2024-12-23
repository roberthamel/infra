#!/usr/bin/env bash
set -eEuo pipefail

curl -L https://coder.com/install.sh | sh
sudo systemctl enable --now coder
echo "$ journalctl -u coder.service -b to view logs"
echo "# or just run the server directly"
echo"$ coder server"
echo
echo "connect to a coder deployment:"
echo "  $ coder login <deployment url>"
echo "coder environment variables are stored in /etc/coder.d/coder.env"
