#!/bin/bash

# Update system and install prerequisites
sudo apt-get update
sudo apt-get install -y git curl

# Clone the official T-Pot Community Edition repository
git clone https://github.com/telekom-security/tpotce.git

# Change to the T-Pot directory
cd tpotce

# Start the interactive installer (do NOT use sudo here)
./install.sh
