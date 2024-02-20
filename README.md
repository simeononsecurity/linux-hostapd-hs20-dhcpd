# Hotspot 2.0 Docker Container: HostAPD + DHCP Server

This Docker container facilitates the deployment of a wireless access point (hostap) and DHCP server, supporting Hotspot 2.0 on Linux systems. It is designed to operate in both host networking mode and with the network interface attached directly to the container's network namespace.

**This is an advanced docker container**

> While we take strides to simplify the process of this container, not everything can be simplified or automated. If you are not comfortable reading documentation or working with and troubleshooting on linux, please use an [OpenWRT](https://simeononsecurity.com/guides/unlock-seamless-connectivity-hotspot-2.0-openwrt/) based device or a turn-key solution instead. 

## Requirements
- Minimum linux kernel for master (AP) and AP/VLAN modes = 5.19
  - Verify using `uname -r`
  - Ideally, you should get your linux kernel to 6.1 or 6.6 if possible. Consult your OS maintainers.
  - See the [USB WiFi - Linux Kernel Support Matrix](https://github.com/morrownr/USB-WiFi/blob/main/home/USB_WiFi_Chipsets.md)
- Minimum of a WiFi 5/6 and AP Mode Capable WiFi Device
  - Drivers and Firmware for the device are installed and working on your Host OS. 
- 1-2 Spare USB Ports
- Administrative SSH Access to the Host Device

Before deployment, ensure your system's Wi-Fi drivers are correctly installed and that your Wi-Fi adapter supports AP mode. You can verify this with the following command:

```shell
iw list
```

Look for "AP" under "Supported interface modes". Additionally, set your country's Wi-Fi regulations to comply with local laws. For example, for Spain, you would set:

```shell
iw reg set US
```

### Recommended Hardware

This docker container includes defaults and assumptions in mind for specific hardware adapters. They are recommended below. If you choose to use another adapter, be aware that you'll need to read the [hostapd.conf documentation](https://web.mit.edu/freebsd/head/contrib/wpa/hostapd/hostapd.conf) and look at `CONFIG.md` and `docker-init.sh` to figure out what config items you may need to change. 

- [ALFA AWUS036AXM](https://amzn.to/3Texv3H)
- [NETGEAR WiFi AC1200 (A6210)](https://amzn.to/3T5FdwX)

## Build and Run

### Using Host Networking:

To run the container in host networking mode, ensuring it has full access to the host's network interfaces, use the following command as an example:

```shell
sudo docker run -i -t -e INTERFACE=wlan1 -e OUTGOINGS=eth0 --net host --privileged simeononsecurity/linux-hostapd-hs20-dhcpd
```

### Using Network Interface Reattaching:

For scenarios where you need to attach a network interface directly to the container, the following command can be used as an example:

```shell
sudo docker run -d -t -e INTERFACE=wlan0 -v /var/run/docker.sock:/var/run/docker.sock --privileged simeononsecurity/linux-hostapd-hs20-dhcpd
```

This method requires access to the Docker socket to manage network interfaces dynamically.

## Environment Variables

The container can be customized with several environment variables:

Examples:

- **INTERFACE**: The name of the Wi-Fi interface to use for the access point.
- **OUTGOINGS**: Specifies the outgoing network interface for internet access.
- **CHANNEL**: Sets the Wi-Fi channel (e.g., 6).
- **SUBNET**: Defines the network subnet (e.g., 192.168.200.0).
- **AP_ADDR**: Specifies the access point's IP address (e.g., 192.168.200.1).
- **SSID**: Sets the SSID of the Wi-Fi network.
- **HW_MODE**: Specifies the Wi-Fi hardware mode (e.g., `g` for 2.4 GHz).
- **DRIVER**: Sets the Wi-Fi driver, defaulting to `nl80211`.
- **HT_CAPAB**: Defines 802.11n HT capabilities.

> See [CONFIG.MD](CONFIG.MD) for the complete list.

## Health Checks

The container includes health checks to ensure `hostapd` and `dhcpd` are running correctly and that the specified network interface is operational.

## Docker Host OS WiFi Driver Script

The script `wifi-firmware.sh` is a Bash utility designed for downloading and installing firmware files for various WiFi chipsets from MediaTek (such as mt7925, mt7922, mt7961, mt7662, mt7610) and Realtek (rtw88 series).\

The script automates the process of creating the necessary directories (if they do not already exist), downloading firmware files from the specified URLs using `wget`, and copying them to the appropriate locations in `/lib/firmware`. This setup is crucial for ensuring that the Linux system recognizes and correctly operates the WiFi hardware. 

To use the script, simply execute it with Bash in a Linux environment that has internet access. It requires `sudo` privileges to create directories and copy files into the system's firmware directory. This script streamlines the firmware installation process for supported WiFi devices, making it an essential tool for system administrators and users looking to manually update or install WiFi drivers on their Linux systems.

## License

No license is given at this time until we decide what needs to happen. All rights reserved.

## Acknowledgments

- Original inspiration from [sdelrio's RPi-hostap](https://github.com/sdelrio/rpi-hostap) implementation.
- Docker container and health check enhancements by SimeonOnSecurity.

For additional details and configurations, refer to the Dockerfile and the accompanying `docker-init.sh` and `healthcheck.sh` scripts provided with this container.