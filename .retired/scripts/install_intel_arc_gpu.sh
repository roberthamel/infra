#!/usr/bin/env bash
set -eEuo pipefail

# https://dgpu-docs.intel.com/driver/client/overview.html

# sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo add-apt-repository -y ppa:kobuk-team/intel-graphics
# sudo apt install -y libze-intel-gpu1 libze1 intel-ocloc intel-opencl-icd clinfo #igsc
# sudo apt install -y intel-media-va-driver-non-free libmfx1 libmfx-gen1 libvpl2 libvpl-tools libva-glx2 va-driver-all vainfo
# wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | \
#   sudo gpg --yes --dearmor --output /usr/share/keyrings/intel-graphics.gpg
# echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu noble client" | \
#   sudo tee /etc/apt/sources.list.d/intel-gpu-noble.list
sudo apt update && sudo apt install -y libze1 intel-level-zero-gpu intel-opencl-icd clinfo igsc libze-dev intel-ocloc
echo "Verifying install"
clinfo | grep "Device Name"
