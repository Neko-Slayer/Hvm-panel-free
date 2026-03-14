#!/bin/bash

# ===========================================
# HVM Panel Auto Installer
# ===========================================
# Made by NekoSlayer_
# ===========================================

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Clear screen
clear

# Banner
echo -e "${CYAN}"
echo '  _    _ _   _ __  __    _   _ _   _ _____   _____ _           _ '
echo ' | |  | | | | |  \/  |  | \ | | \ | |  __ \ / ____| |         | |'
echo ' | |__| | | | | \  / |  |  \| |  \| | |  | | |  __| | ___  ___| |'
echo ' |  __  | | | | |\/| |  | . ` | . ` | |  | | | |_ | |/ _ \/ _ \ |'
echo ' | |  | | |_| | |  | |  | |\  | |\  | |__| | |__| | |  __/  __/ |'
echo ' |_|  |_|\___/|_|  |_|  |_| \_|_| \_|_____/ \_____|_|\___|\___|_|'
echo -e "${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${WHITE}              📦 HVM Panel Auto Installer${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}                Made by NekoSlayer_${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}\n"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[✘] This script must be run as root!${NC}"
   echo -e "${YELLOW}Usage: sudo bash $0${NC}\n"
   exit 1
fi

# Step 1: Update system
echo -e "${BLUE}[1/9] 📦 Updating system packages...${NC}"
apt update -y && apt upgrade -y
echo -e "${GREEN}[✓] System updated${NC}\n"

# Step 2: Install git
echo -e "${BLUE}[2/9] 🔧 Installing git...${NC}"
apt install git -y
echo -e "${GREEN}[✓] Git installed${NC}\n"

# Step 3: Clone repository
echo -e "${BLUE}[3/9] 📥 Cloning HVM Panel repository...${NC}"
git clone https://github.com/Neko-Slayer/Hvm-panel-free.git
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✓] Repository cloned successfully${NC}"
else
    echo -e "${RED}[✘] Failed to clone repository${NC}"
    exit 1
fi
echo ""

# Step 4: Change directory
echo -e "${BLUE}[4/9] 📂 Changing to Hvm-panel-free directory...${NC}"
cd Hvm-panel-free || { echo -e "${RED}[✘] Directory not found${NC}"; exit 1; }
echo -e "${GREEN}[✓] Current directory: $(pwd)${NC}\n"

# Step 5: Install unzip
echo -e "${BLUE}[5/9] 📦 Installing unzip...${NC}"
apt install unzip -y
echo -e "${GREEN}[✓] Unzip installed${NC}\n"

# Step 6: Unzip file
echo -e "${BLUE}[6/9] 📂 Extracting hvm_by_neko.zip...${NC}"
if [ -f "hvm_by_neko.zip" ]; then
    unzip -o hvm_by_neko.zip
    echo -e "${GREEN}[✓] File extracted successfully${NC}"
else
    echo -e "${RED}[✘] hvm_by_neko.zip not found!${NC}"
    exit 1
fi
echo ""

# Step 7: Change to hvm directory
echo -e "${BLUE}[7/9] 📂 Changing to hvm directory...${NC}"
cd hvm || { echo -e "${RED}[✘] hvm directory not found${NC}"; exit 1; }
echo -e "${GREEN}[✓] Current directory: $(pwd)${NC}\n"

# Step 8: Install Python3 and pip
echo -e "${BLUE}[8/9] 🐍 Installing Python3 and pip...${NC}"
apt install python3 python3-pip -y
echo -e "${GREEN}[✓] Python3 and pip installed${NC}\n"

# Step 9: Install requirements
echo -e "${BLUE}[9/9] 📦 Installing Python requirements...${NC}"
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
    echo -e "${GREEN}[✓] Requirements installed successfully${NC}"
else
    echo -e "${YELLOW}[!] requirements.txt not found, skipping...${NC}"
fi
echo ""

# Create systemd service
echo -e "${BLUE}[+] Creating systemd service for HVM Panel...${NC}"

cat > /etc/systemd/system/hvm.service << 'EOF'
[Unit]
Description=HVM Panel (Discord Bot)
After=network.target

[Service]
User=root
WorkingDirectory=/root/Hvm-panel-free/hvm
ExecStart=/usr/bin/python3 /root/Hvm-panel-free/hvm/hvm.py
Restart=always
RestartSec=5
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

echo -e "${GREEN}[✓] Service file created at /etc/systemd/system/hvm.service${NC}\n"

# Reload systemd and start service
echo -e "${BLUE}[+] Reloading systemd daemon...${NC}"
systemctl daemon-reload
echo -e "${GREEN}[✓] Systemd reloaded${NC}\n"

echo -e "${BLUE}[+] Enabling HVM service to start on boot...${NC}"
systemctl enable hvm.service
echo -e "${GREEN}[✓] Service enabled${NC}\n"

echo -e "${BLUE}[+] Starting HVM service...${NC}"
systemctl start hvm.service
echo -e "${GREEN}[✓] Service started${NC}\n"

# Check service status
echo -e "${BLUE}[+] Checking service status...${NC}"
sleep 2
systemctl status hvm.service --no-pager -l
echo ""

# Final message
clear

# Final banner
echo -e "${CYAN}"
echo '  _    _ _   _ __  __    _   _ _   _ _____   _____ _           _ '
echo ' | |  | | | | |  \/  |  | \ | | \ | |  __ \ / ____| |         | |'
echo ' | |__| | | | | \  / |  |  \| |  \| | |  | | |  __| | ___  ___| |'
echo ' |  __  | | | | |\/| |  | . ` | . ` | |  | | | |_ | |/ _ \/ _ \ |'
echo ' | |  | | |_| | |  | |  | |\  | |\  | |__| | |__| | |  __/  __/ |'
echo ' |_|  |_|\___/|_|  |_|  |_| \_|_| \_|_____/ \_____|_|\___|\___|_|'
echo -e "${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}          ✅ HVM Panel Installation Complete!${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${WHITE}                Made by NekoSlayer_${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}\n"

# Installation summary
echo -e "${YELLOW}📌 INSTALLATION SUMMARY:${NC}"
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${GREEN}✓${NC} Git installed"
echo -e " ${GREEN}✓${NC} Repository cloned"
echo -e " ${GREEN}✓${NC} Unzip installed"
echo -e " ${GREEN}✓${NC} Files extracted"
echo -e " ${GREEN}✓${NC} Python3 & pip installed"
echo -e " ${GREEN}✓${NC} Requirements installed"
echo -e " ${GREEN}✓${NC} Systemd service created"
echo -e " ${GREEN}✓${NC} Service enabled & started"
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Useful commands
echo -e "${GREEN}📋 USEFUL COMMANDS:${NC}"
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${YELLOW}→${NC} Check status: ${CYAN}systemctl status hvm${NC}"
echo -e " ${YELLOW}→${NC} Start service: ${CYAN}systemctl start hvm${NC}"
echo -e " ${YELLOW}→${NC} Stop service: ${CYAN}systemctl stop hvm${NC}"
echo -e " ${YELLOW}→${NC} Restart service: ${CYAN}systemctl restart hvm${NC}"
echo -e " ${YELLOW}→${NC} View logs: ${CYAN}journalctl -u hvm -f${NC}"
echo -e " ${YELLOW}→${NC} Manual run: ${CYAN}cd /root/Hvm-panel-free/hvm && python3 hvm.py${NC}"
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Location info
echo -e "${GREEN}📂 INSTALLATION LOCATION:${NC}"
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${WHITE}•${NC} Panel directory: ${CYAN}/root/Hvm-panel-free/hvm${NC}"
echo -e " ${WHITE}•${NC} Service file: ${CYAN}/etc/systemd/system/hvm.service${NC}"
echo -e " ${WHITE}•${NC} Requirements: ${CYAN}/root/Hvm-panel-free/hvm/requirements.txt${NC}"
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Final message
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}           🚀 HVM Panel is now running! 🚀${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${WHITE}           Check logs: journalctl -u hvm -f${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}\n"

# Optional: Run manually
read -p "Abhi manually run karna chahte ho? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${BLUE}[+] Running hvm.py manually...${NC}\n"
    cd /root/Hvm-panel-free/hvm
    python3 hvm.py
fi
