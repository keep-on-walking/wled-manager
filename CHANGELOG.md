# Changelog

All notable changes to WLED Manager will be documented in this file.

## [1.1.0] - 2026-02-10

### Added
- **WiFi Access Point Management**: Create wireless networks for iPad/device connectivity
  - Web interface for WiFi AP configuration
  - Configure SSID, password, channel, and IP settings
  - Enable/disable/restart WiFi AP controls
  - Real-time connected clients display
  - Automatic DHCP configuration for WiFi interface
- Optional WiFi AP installation during setup
- WiFi menu item in navigation

### Changed
- Updated base template with WiFi AP navigation
- Enhanced install script with WiFi AP option
- Updated documentation with WiFi AP usage instructions

### Technical
- New `wifi_ap_manager.py` module for hostapd management
- New `/api/wifi/*` API endpoints
- New `wifi_ap.html` template
- iOS/iPad compatibility improvements in DHCP configuration

## [1.0.0] - 2026-02-10

### Added
- Initial stable release
- USB Ethernet adapter detection and configuration
- Automatic DHCP configuration with iOS compatibility
- WLED controller discovery and scanning
- MAC-based IP reservations
- Web interface with Bootstrap UI
- Dashboard with system status
- RTL8153 USB adapter support
- Boot-time USB adapter initialization
- dnsmasq timing fixes for reliable boot

### Features
- Adapters page for USB Ethernet management
- WLED Devices page for controller discovery
- Automatic gateway and DNS DHCP options
- Real-time status updates
- NetworkManager integration

### Documentation
- Complete README with installation instructions
- Troubleshooting guide
- Hardware compatibility notes
- Technical architecture documentation

### Known Issues
- RTL8151 USB adapters have reliability issues (use RTL8153 instead)
- WiFi AP and WiFi client mode cannot run simultaneously
