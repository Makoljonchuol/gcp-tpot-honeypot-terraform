#!/bin/bash
apt-get update && apt-get install -y git curl
git clone https://github.com/telekom-security/tpotce.git
cd tpotce/iso/installer/
chmod +x install.sh
# Install full T-Pot package (includes ELK)
./install.sh --type=auto
