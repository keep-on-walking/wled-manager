# WLED Manager

A web-based network management tool for Raspberry Pi 5 that simplifies configuration of USB-to-Ethernet adapters and WLED controller discovery.

## Features

- **USB Ethernet Adapter Management**: Automatic detection and configuration of USB-to-Ethernet adapters
- **WLED Controller Discovery**: Scan and discover WLED controllers on connected networks
- **IP Reservation**: MAC-based DHCP reservations for WLED controllers
- **Web Interface**: Easy-to-use browser-based configuration at port 8080
- **Network Isolation**: Separate network segments for iPads and WLED controllers

## Requirements

- Raspberry Pi 5
- Raspberry Pi OS (Full or Lite)
- Internet connection for initial setup
- USB-to-Ethernet adapters (as needed)

## Installation

### One-Command Install

```bash
curl -sSL https://raw.githubusercontent.com/keep-on-walking/wled-manager/main/install.sh | sudo bash
```

### Manual Install

```bash
git clone https://github.com/keep-on-walking/wled-manager.git
cd wled-manager
sudo ./install.sh
```

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
4. Apply configuration

### Discovering WLED Controllers

1. Navigate to the **WLED** page
2. Select which adapter to scan
3. Click **Scan for Devices**
4. Assign static IP reservations by MAC address

## Architecture

- **Backend**: Python 3 + Flask
- **Network Management**: NetworkManager (via nmcli)
- **DHCP**: dnsmasq
- **Device Discovery**: arp-scan, nmap, HTTP probing
- **Frontend**: HTML/CSS/JavaScript with Bootstrap

## Configuration

Configuration is stored in `/etc/wled-manager/config.yaml`

Service runs as systemd service: `wled-manager.service`

## Troubleshooting

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

## License

MIT License - See LICENSE file for details

## Contributing

This is currently a personal project. Feel free to fork and adapt for your own use.
