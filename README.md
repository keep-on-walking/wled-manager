# WLED Manager

A web-based network management tool for Raspberry Pi 5 that simplifies configuration of USB-to-Ethernet adapters and WLED controller discovery.

## Features

- **USB Ethernet Adapter Management**: Automatic detection and configuration of USB-to-Ethernet adapters
- **Automatic DHCP Setup**: Configures dnsmasq automatically when you set up an adapter - no manual configuration needed
- **WiFi Access Point**: Create a wireless network for iPad connectivity (v1.1.0+)
- **WLED Controller Discovery**: Scan and discover WLED controllers on connected networks
- **IP Reservation**: MAC-based DHCP reservations for WLED controllers
- **Web Interface**: Easy-to-use browser-based configuration at port 8080
- **Network Isolation**: Separate network segments for iPads and WLED controllers
- **Realtek USB Adapter Support**: Automatic handling of Realtek adapters that appear as CD-ROMs

## Requirements

- Raspberry Pi 5
- Raspberry Pi OS (Full or Lite)
- Internet connection for initial setup
- USB-to-Ethernet adapters (as needed)

## Known Compatibility

**USB Ethernet Adapters:**
- ✅ **Realtek RTL8153** (Recommended) - Reliable, plug-and-play, no issues
- ⚠️ Realtek RTL8151 - Known issues (appears as CD-ROM, requires manual intervention)
- ✅ Most standard USB-to-Ethernet adapters work well

**Recommended Adapter:** Look for adapters with **RTL8153** chipset for best reliability.

**iOS/iPad Compatibility:**
- DHCP includes gateway and DNS options for iOS compatibility
- Tested with Lightning-to-Ethernet adapters
- Works with PoE-to-Lightning setups

## Installation

### Latest Version (v1.1.0) - With WiFi Access Point

```bash
curl -sSL https://raw.githubusercontent.com/keep-on-walking/wled-manager/feature/wifi-ap/install.sh | sudo bash
```

### Stable Version (v1.0.0) - USB Ethernet Only

```bash
curl -sSL https://raw.githubusercontent.com/keep-on-walking/wled-manager/v1.0.0/install.sh | sudo bash
```

### From Main Branch (Latest Stable)

```bash
curl -sSL https://raw.githubusercontent.com/keep-on-walking/wled-manager/main/install.sh | sudo bash
```

### Manual Install

```bash
git clone https://github.com/keep-on-walking/wled-manager.git
cd wled-manager
sudo ./install.sh
```

## What Gets Installed

The installation script automatically:
1. Installs required packages (Python, dnsmasq, arp-scan, nmap, usb-modeswitch)
2. Configures udev rules for Realtek USB adapters
3. Fixes dnsmasq timing issues on boot
4. Sets up the Python environment and web service
5. Enables the systemd service for auto-start
6. **Optionally** installs WiFi Access Point support (hostapd)

## Usage

After installation, access the web interface:

```
http://raspberrypi.local:8080
```

Or using the Pi's IP address:

```
http://[PI_IP_ADDRESS]:8080
```

### Managing USB Ethernet Adapters

1. Navigate to the **Adapters** page
2. View detected USB Ethernet adapters
3. Configure subnet and IP address for each adapter
4. Apply configuration - **DHCP is configured automatically!**

### Discovering WLED Controllers

1. Navigate to the **WLED** page
2. Select which adapter to scan
3. Click **Scan for Devices**
4. Assign static IP reservations by MAC address

### Managing WiFi Access Point (v1.1.0+)

The WiFi Access Point feature allows iPads and other devices to connect wirelessly instead of requiring physical Ethernet connections.

1. Navigate to the **WiFi AP** page
2. Configure network settings:
   - **SSID**: Network name (e.g., "WLED-Manager-AP")
   - **Password**: WPA2 password (minimum 8 characters)
   - **Channel**: WiFi channel (recommended: 1, 6, or 11)
   - **IP Address**: Gateway IP (e.g., 10.0.2.1)
3. Click **Configure WiFi AP**
4. Click **Enable** to start the access point
5. Connect devices to the WiFi network
6. View connected clients in real-time

**Note:** The Pi's WiFi can either be an Access Point OR connect to an external WiFi network, but not both simultaneously. For internet access, use eth0 (Ethernet cable to router).

## Architecture

- **Backend**: Python 3 + Flask
- **Network Management**: NetworkManager (via nmcli)
- **DHCP**: dnsmasq (automatically configured)
- **Device Discovery**: arp-scan, nmap, HTTP probing
- **Frontend**: HTML/CSS/JavaScript with Bootstrap

## Configuration

Configuration is stored in `/etc/wled-manager/config.yaml`

Service runs as systemd service: `wled-manager.service`

## Troubleshooting

### USB Adapter Not Detected

If your USB Ethernet adapter doesn't appear:

1. Check if it's detected by USB:
```bash
lsusb
```

2. Check network interfaces:
```bash
ip link show
```

3. For Realtek adapters appearing as CD-ROM, the udev rule should fix this automatically. If not, try unplugging and replugging the adapter.

### dnsmasq Not Running

If dnsmasq shows as inactive:

```bash
# Check status
sudo systemctl status dnsmasq

# View logs
sudo journalctl -u dnsmasq -n 50

# Restart service
sudo systemctl restart dnsmasq
```

Common cause: USB adapter not ready when dnsmasq starts. The installation includes a fix for this.

### Check Service Status
```bash
sudo systemctl status wled-manager
```

### View Logs
```bash
sudo journalctl -u wled-manager -f
```

### Restart Service
```bash
sudo systemctl restart wled-manager
```

## Technical Notes

### Automatic DHCP Configuration

When you configure a USB adapter through the web interface, the system automatically:
1. Sets the static IP on the interface
2. Calculates a DHCP range (e.g., if IP is 10.0.0.1, DHCP range becomes 10.0.0.10-10.0.0.50)
3. Updates `/etc/dnsmasq.conf` with the new interface configuration
4. Restarts dnsmasq to apply changes

No manual dnsmasq configuration is required!

### Realtek USB Adapter Fix

Some Realtek USB Ethernet adapters (particularly RTL8151) initially appear as CD-ROM devices with Windows drivers. The installation script automatically:
- Installs `usb-modeswitch` to handle device mode switching
- Creates a udev rule to force the adapter into network mode
- Ensures the adapter is recognized as a network interface on every boot

### Boot Timing Fix

The installation includes a systemd override for dnsmasq to ensure it starts after NetworkManager has brought up all network interfaces. This prevents "unknown interface" errors on boot.

## Use Case

This system enables:
1. **Built-in Ethernet (eth0)** → Router for internet access and remote management
2. **USB Ethernet Adapter #1 (eth1)** → iPad via Lightning-to-Ethernet for Node-RED dashboard access
3. **USB Ethernet Adapter #2 (eth2)** → WLED controller with reserved IP for lighting control

Each network segment is isolated with its own subnet and DHCP server.

## License

MIT License - See LICENSE file for details

## Contributing

This is currently a personal project. Feel free to fork and adapt for your own use.
