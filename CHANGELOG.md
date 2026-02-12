# Changelog

All notable changes to WLED Manager will be documented in this file.

## [1.1.5] - 2026-02-12

### Fixed
- **wlan0-ip Service Timing**: Fixed wlan0-ip.service to wait for wlan0 interface to exist before assigning IP
- Service now waits up to 30 seconds for wlan0 to be ready on boot
- Added proper systemd dependencies to ensure network interface is available
- WiFi AP now reliably comes up after reboot without manual intervention

### Technical
- Added `After=sys-subsystem-net-devices-wlan0.device` to service dependencies
- Added `ExecStartPre` wait loop to ensure wlan0 exists before IP assignment
- Changed `WantedBy` from `sysinit.target` to `multi-user.target` for better ordering

## [1.1.4] - 2026-02-12

### Fixed
- **WiFi AP Persistence**: WiFi AP now properly persists across reboots when enabled
- Enable function now starts wlan0-ip service to ensure IP is assigned on boot
- Enable function now enables dnsmasq service for persistent DHCP
- Disable function now properly disables wlan0-ip service

### Changed
- When you click "Enable" in the web interface, WiFi AP is now configured to start automatically on every boot
- When you click "Disable", all WiFi AP services are stopped and disabled from auto-start

## [1.1.3] - 2026-02-12

### Fixed
- **Installation Script**: Fixed non-interactive installation via `curl | bash`
- System updates now skip in piped mode to avoid blocking on prompts
- All apt commands use `DEBIAN_FRONTEND=noninteractive` to prevent configuration prompts
- One-command installation now works reliably

### Changed
- Installation skips `apt upgrade` when piped (run manually if needed)
- WiFi AP installation still prompts but doesn't block on package configs

## [1.1.2] - 2026-02-12

### Fixed
- **dnsmasq Configuration**: Fixed `_configure_dnsmasq()` to create `/etc/dnsmasq.conf` if it doesn't exist
- **wlan0-ip Service**: Fixed systemd service to use bash instead of sh (fixes "source: not found" error)
- **WiFi AP Persistence**: WiFi AP now properly survives reboots with correct IP and DHCP configuration
- Added "bind-interfaces" to dnsmasq WiFi AP configuration for better interface isolation

### Technical
- `_configure_dnsmasq()` now checks if file exists before reading
- `wlan0-ip.service` uses `/bin/bash` instead of `/bin/sh`
- Better error handling and logging throughout WiFi AP configuration

## [1.1.1] - 2026-02-10

### Fixed
- **WiFi AP IP Assignment**: Fixed wlan0 IP assignment to work when hostapd makes interface unmanaged
- Changed from NetworkManager-based IP assignment to direct `ip` command
- Added boot-time wlan0 IP assignment service for persistence across reboots
- WiFi AP now properly configures and survives system restarts

### Technical
- Updated `wifi_ap_manager.py` to use direct IP commands instead of NetworkManager
- Added `wlan0-ip.service` systemd service for boot-time IP assignment
- WiFi AP IP saved to `/etc/hostapd/wlan0-ip.conf` for boot service

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
