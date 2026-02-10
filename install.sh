#!/bin/bash

# WLED Manager Installation Script
# For Raspberry Pi 5 running Raspberry Pi OS

set -e  # Exit on any error

echo "========================================="
echo "WLED Manager Installation"
echo "========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "ERROR: Please run as root (use sudo)"
    exit 1
fi

# Check if running on Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo; then
    echo "WARNING: This script is designed for Raspberry Pi"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "Step 1: Updating system packages..."
apt update
apt upgrade -y

echo ""
echo "Step 2: Installing dependencies..."
apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    dnsmasq \
    arp-scan \
    nmap \
    git \
    network-manager \
    usb-modeswitch \
    usb-modeswitch-data

echo ""
echo "Step 3: Configuring USB Ethernet adapter support..."
# Fix for Realtek adapters that appear as CD-ROM
echo 'ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="8151", RUN+="/bin/sh -c \"echo 0bda 8151 > /sys/bus/usb/drivers/r8152/new_id\""' > /etc/udev/rules.d/50-usb-realtek-net.rules
udevadm control --reload-rules
echo "USB adapter support configured"

# Fix dnsmasq timing issue - make it wait for NetworkManager
mkdir -p /etc/systemd/system/dnsmasq.service.d
cat > /etc/systemd/system/dnsmasq.service.d/wait-for-network.conf << 'EOF'
[Unit]
After=NetworkManager.service network-online.target
Wants=network-online.target
EOF
echo "dnsmasq timing fix applied"

echo ""
echo "Step 4: Creating installation directory..."
INSTALL_DIR="/opt/wled-manager"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# If running from a git clone, copy files
if [ -f "$(dirname "$0")/src/app.py" ]; then
    echo "Copying files from current directory..."
    cp -r "$(dirname "$0")"/* "$INSTALL_DIR/"
else
    # Otherwise clone from GitHub
    echo "Cloning from GitHub..."
    git clone https://github.com/keep-on-walking/wled-manager.git temp_clone
    cp -r temp_clone/* "$INSTALL_DIR/"
    rm -rf temp_clone
fi

echo ""
echo "Step 5: Setting up Python virtual environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo ""
echo "Step 6: Creating configuration directory..."
mkdir -p /etc/wled-manager
if [ ! -f /etc/wled-manager/config.yaml ]; then
    cp config/config.yaml /etc/wled-manager/config.yaml
fi

echo ""
echo "Step 7: Installing systemd service..."
cp systemd/wled-manager.service /etc/systemd/system/
cp systemd/usb-adapter-init.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable wled-manager
systemctl enable usb-adapter-init
systemctl start wled-manager
echo "Boot-time USB adapter initialization enabled"

echo ""
echo "Step 8: Configuring firewall (if active)..."
if systemctl is-active --quiet ufw; then
    ufw allow 8080/tcp
    echo "Firewall configured to allow port 8080"
fi

echo ""
echo "Step 9: WiFi Access Point (optional)..."
echo "Would you like to install WiFi Access Point support?"
echo "This allows iPads to connect wirelessly instead of via Ethernet."

# Check if running in a pipe (non-interactive)
if [ -t 0 ]; then
    read -p "Install WiFi AP? (y/n) " -n 1 -r
    echo
else
    echo "Non-interactive mode detected. Installing WiFi AP by default..."
    REPLY="y"
fi

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing WiFi AP support..."
    apt install -y hostapd
    
    # Unmask hostapd
    systemctl unmask hostapd
    
    # Create hostapd directory
    mkdir -p /etc/hostapd
    
    echo "WiFi AP support installed!"
    echo "Configure it via the web interface at: http://$(hostname -I | awk '{print $1}'):8080/wifi"
else
    echo "Skipping WiFi AP installation"
    echo "You can install it later by running:"
    echo "  sudo apt install -y hostapd"
fi

echo ""
echo "========================================="
echo "Installation Complete!"
echo "========================================="
echo ""
echo "Access WLED Manager at:"
echo "  http://$(hostname).local:8080"
echo "  or"
echo "  http://$(hostname -I | awk '{print $1}'):8080"
echo ""
echo "Service status:"
systemctl status wled-manager --no-pager -l
echo ""
echo "To view logs: sudo journalctl -u wled-manager -f"
echo "To restart: sudo systemctl restart wled-manager"
echo ""
