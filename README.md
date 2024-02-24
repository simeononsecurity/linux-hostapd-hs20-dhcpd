# Hotspot 2.0 Docker Container: HostAPD + DHCP Server

This Docker container facilitates the deployment of a wireless access point (hostap) and DHCP server, supporting Hotspot 2.0 on Linux systems. It is designed to operate in both host networking mode and with the network interface attached directly to the container's network namespace.

**This is an advanced docker container**

> While we take strides to simplify the process of this container, not everything can be simplified or automated. If you are not comfortable reading documentation or working with and troubleshooting on linux, please use an [OpenWRT](https://simeononsecurity.com/guides/unlock-seamless-connectivity-hotspot-2.0-openwrt/) based device or a turn-key solution instead. 

## Requirements
- Minimum linux kernel for WiFi 6 device based master (AP) and AP/VLAN modes = 5.19
  - Verify using `uname -r`
  - Ideally, you should get your linux kernel to 6.1 or 6.6 if possible. Consult your OS maintainers.
  - See the [USB WiFi - Linux Kernel Support Matrix](https://github.com/morrownr/USB-WiFi/blob/main/home/USB_WiFi_Chipsets.md)
- Minimum of a WiFi 5/6 and AP Mode Capable WiFi Device
  - Drivers and Firmware for the device are installed and working on your Host OS. 
- 1-2 Spare USB Ports
- 1-2 AP Compatible WiFi Adapters (1 for 2.4Ghz and 1 for 5Ghz)
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

> Assuming you're already on the supported kernel levels for the device, run the [wifi-firmware.sh](wifi-firmware.sh) script on the docker host and reboot to install the appropriate drivers and firmware for all of our supported devices below.

- [ALFA AWUS036AXM](https://amzn.to/3Texv3H)
    - We love it because it has external and replaceable antennas and it supports either 2.4Ghz/5Ghz on WiFi 6. Once hostapd adds support, the device will also support the 6 Ghz band in the future.
    - Requires Linux Kernel Level 5.2 at least. Verify with `uname -r`.
    - Use ```-e HT_CAPAB="[HT40+][LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][MAX-AMSDU-7935]" -e VHT_CAPAB="[RXLDPC][SHORT-GI-80][TX-STBC-2BY1][SU-BEAMFORMEE][MU-BEAMFORMEE][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN][RX-STBC-1][BF-ANTENNA-4][MAX-MPDU-11454][MAX-A-MPDU-LEN-EXP7]"``` with your docker configuration.
- [NETGEAR WiFi AC1200 (A6210)](https://amzn.to/3T5FdwX)
    - We love it because it is cheap and it is the easiest to install out of any of the external adapters. Not to mention it is the easiest to get your hands on. It lacks external antennas however. 
    - Requires Linux Kernel Level 5.2 at least. Verify with `uname -r`.
    - Use ```-e HT_CAPAB="[HT40+][LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1]" -e VHT_CAPAB="[RXLDPC][SHORT-GI-80][TX-STBC-2BY1][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN][RX-STBC-1][MAX-A-MPDU-LEN-EXP3]"``` with your docker configuration.
- [ALFA AWUS036AXML](https://amzn.to/3vYvHT4)
    - We love it because it has external and replaceable antennas and it has WiFi 7 and 6GHz support as soon as Linux supports it. Till then it is 2.4Ghz/5Ghz and WiFi 6 capable. 
    - Requires Kernel Level 6.6 at least. Ideally, 6.7. Verify with `uname -r`. *This is problematic on ARM based devices, it's unlikely that your arm device supports any kernel above 6.1.*
    -  Use ```-e HT_CAPAB="[HT40+][LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][MAX-AMSDU-7935]" -e VHT_CAPAB="[RXLDPC][SHORT-GI-80][TX-STBC-2BY1][SU-BEAMFORMEE][MU-BEAMFORMEE][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN][RX-STBC-1][BF-ANTENNA-4][MAX-MPDU-11454][MAX-A-MPDU-LEN-EXP7]"``` with your docker configuration.

> *For a list of other documented adapters that have support on Linux See the [USB-WiFi Documentation Repo](https://github.com/morrownr/USB-WiFi/blob/main/home/USB_WiFi_Adapters_that_are_supported_with_Linux_in-kernel_drivers.md)*. Be aware though, that choosing an adapter that isn't on the list above, you'll need ot identify the devices capabilities before running the container.

#### Recomended alternative chipsets.

[USB WiFi devices recommended for Linux](https://github.com/morrownr/USB-WiFi/blob/main/home/USB_WiFi_Chipsets.md):

| Chipset           | Interface | Standard | Maximum Channel Width | Linux In-Kernel Driver | AP Mode | Monitor Mode | Recommended For Linux |
|-------------------|-----------|----------|-----------------------|------------------------|---------|--------------|-----------------------|
| Mediatek MT7925   | USB3      | WiFi 7   | 160                   | ✔️ 6.7+                | ✔️       | ✔️            | Yes [4]               |
| Mediatek MT7921au | USB3      | WiFi 6E  | 80                    | ✔️ 5.18+               | ✔️       | ✔️            | Yes                   |
| Mediatek MT7612u  | USB3      | WiFi 5   | 80                    | ✔️ 4.19+               | ✔️       | ✔️            | Yes                   |
| Realtek RTL8812bu | USB3      | WiFi 5   | 80                    | ✔️ 6.2+ [3]            | ✔️       | ✔️            | Yes                   |
| Mediatek MT7610u  | USB2      | WiFi 5   | 80                    | ✔️ 4.19+               | ✔️       | ✔️            | Yes                   |

These are the USB WiFi devices recommended for Linux, along with their specifications and compatibility details.

## Updating the Linux Kernel

Updaiting the linux kernel is an involved process. It won't work on every system. Consult your OS manufatures documentation and website for more details.

However if you're you're running ubuntu on a non-ARM based device we recommend the following articles for instructions on how to update the linux kernel.

- https://phoenixnap.com/kb/how-to-update-kernel-ubuntu
- https://itsfoss.com/upgrade-linux-kernel-ubuntu/

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

### Suggested Configurations for Recommended Hardware

#### [ALFA AWUS036AXM](https://amzn.to/3Texv3H)
```bash
sudo docker pull simeononsecurity/linux-hostapd-hs20-dhcpd
sudo docker run -td  \
-e INTERFACE=wlx13370420xx0x \
-e AP_ADDR=192.168.200.1 \
-e SUBNET=192.168.200.0 \
-e OUTGOINGS=eno1 \
-e ACCT_SERVER_ADDR="XXX.XXX.XXX.XXX" \
-e AUTH_SERVER_ADDR="XXX.XXX.XXX.XXX" \
-e VHT_ENABLED=1 \
-e CHANNEL=161 \
-e SSID="Orion" \
-e HT_CAPAB="[HT40+][LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][MAX-AMSDU-7935]" \
-e VHT_CAPAB="[RXLDPC][SHORT-GI-80][TX-STBC-2BY1][SU-BEAMFORMEE][MU-BEAMFORMEE][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN][RX-STBC-1][BF-ANTENNA-4][MAX-MPDU-11454][MAX-A-MPDU-LEN-EXP7]" \
--privileged  \
--net host \
--name wifiap \
--restart unless-stopped \
-v /var/run/docker.sock:/var/run/docker.sock \
simeononsecurity/linux-hostapd-hs20-dhcpd
```

#### [NETGEAR WiFi AC1200 (A6210)](https://amzn.to/3T5FdwX)
```bash
sudo docker pull simeononsecurity/linux-hostapd-hs20-dhcpd
sudo docker run -td  \
-e INTERFACE=wlx13370420xx0x \
-e AP_ADDR=192.168.200.1 \
-e SUBNET=192.168.200.0 \
-e OUTGOINGS=eno1 \
-e ACCT_SERVER_ADDR="XXX.XXX.XXX.XXX" \
-e AUTH_SERVER_ADDR="XXX.XXX.XXX.XXX" \
-e VHT_ENABLED=1 \
-e CHANNEL=161 \
-e SSID="Orion" \
-e HT_CAPAB="[HT40+][LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1]" \
-e VHT_CAPAB="[RXLDPC][SHORT-GI-80][TX-STBC-2BY1][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN][RX-STBC-1][MAX-A-MPDU-LEN-EXP3]" \
--privileged  \
--net host \
--name wifiap \
--restart unless-stopped \
-v /var/run/docker.sock:/var/run/docker.sock \
simeononsecurity/linux-hostapd-hs20-dhcpd
```
#### [ALFA AWUS036AXML](https://amzn.to/3vYvHT4)
```bash
sudo docker pull simeononsecurity/linux-hostapd-hs20-dhcpd
sudo docker run -td  \
-e INTERFACE=wlx13370420xx0x \
-e AP_ADDR=192.168.200.1 \
-e SUBNET=192.168.200.0 \
-e OUTGOINGS=eno1 \
-e ACCT_SERVER_ADDR="XXX.XXX.XXX.XXX" \
-e AUTH_SERVER_ADDR="XXX.XXX.XXX.XXX" \
-e VHT_ENABLED=1 \
-e CHANNEL=161 \
-e SSID="Orion" \
-e HT_CAPAB="[HT40+][LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][MAX-AMSDU-7935]" \
-e VHT_CAPAB="[RXLDPC][SHORT-GI-80][TX-STBC-2BY1][SU-BEAMFORMEE][MU-BEAMFORMEE][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN][RX-STBC-1][BF-ANTENNA-4][MAX-MPDU-11454][MAX-A-MPDU-LEN-EXP7]" \
--privileged  \
--net host \
--name wifiap \
--restart unless-stopped \
-v /var/run/docker.sock:/var/run/docker.sock \
simeononsecurity/linux-hostapd-hs20-dhcpd
```
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
