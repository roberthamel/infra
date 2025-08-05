#!/usr/bin/env bash
set -eEuo pipefail

if ! command -v node_exporter &> /dev/null; then
  VERSION=1.8.2
  wget https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz
  tar xvf node_exporter-$VERSION.linux-amd64.tar.gz
  pushd node_exporter-$VERSION.linux-amd64 > /dev/null
  sudo cp node_exporter /usr/local/bin
  popd > /dev/null
  rm -rf node_exporter-$VERSION.linux-amd64 node_exporter-$VERSION.linux-amd64.tar.gz
  sudo useradd --no-create-home --shell /bin/false node_exporter
  sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
fi
if [ ! -s /etc/systemd/system/node_exporter.service ]; then
  sudo bash -c 'cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF'
fi
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
echo "Node Exporter installed and started"
exit 0

