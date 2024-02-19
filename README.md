Based on the updated Dockerfile and scripts we've created, here's a revised version of the README.md to reflect the changes and improvements made:

# Hotspot 2.0 Docker Container: HostAPD + DHCP Server

This Docker container facilitates the deployment of a wireless access point (hostap) and DHCP server, supporting Hotspot 2.0 on Linux systems. It is designed to operate in both host networking mode and with the network interface attached directly to the container's network namespace.

## Requirements

Before deployment, ensure your system's Wi-Fi drivers are correctly installed and that your Wi-Fi adapter supports AP mode. You can verify this with the following command:

```shell
iw list
```

Look for "AP" under "Supported interface modes". Additionally, set your country's Wi-Fi regulations to comply with local laws. For example, for Spain, you would set:

```shell
iw reg set US
```

## Build and Run

### Using Host Networking:

To run the container in host networking mode, ensuring it has full access to the host's network interfaces, use the following command:

```shell
sudo docker run -i -t -e INTERFACE=wlan1 -e OUTGOINGS=wlan0 --net host --privileged simeononsecurity/linux-hostapd-hs20-dhcpd
```

### Using Network Interface Reattaching:

For scenarios where you need to attach a network interface directly to the container, the following command can be used:

```shell
sudo docker run -d -t -e INTERFACE=wlan0 -v /var/run/docker.sock:/var/run/docker.sock --privileged simeononsecurity/linux-hostapd-hs20-dhcpd
```

This method requires access to the Docker socket to manage network interfaces dynamically.

## Environment Variables

The container can be customized with several environment variables:

- **INTERFACE**: The name of the Wi-Fi interface to use for the access point.
- **OUTGOINGS**: Specifies the outgoing network interface for internet access.
- **CHANNEL**: Sets the Wi-Fi channel (e.g., 6).
- **SUBNET**: Defines the network subnet (e.g., 192.168.200.0).
- **AP_ADDR**: Specifies the access point's IP address (e.g., 192.168.200.1).
- **SSID**: Sets the SSID of the Wi-Fi network.
- **WPA_PASSPHRASE**: The WPA2 passphrase for securing the Wi-Fi network.
- **HW_MODE**: Specifies the Wi-Fi hardware mode (e.g., `g` for 2.4 GHz).
- **DRIVER**: Sets the Wi-Fi driver, defaulting to `nl80211`.
- **HT_CAPAB**: Defines 802.11n HT capabilities.
- **MODE**: Operation mode (`host` or `guest`), with `host` being the default.

## Health Checks

The container includes health checks to ensure `hostapd` and `dhcpd` are running correctly and that the specified network interface is operational.

## License

No license is given at this time until we decide what needs to happen. All rights reserved.

## Acknowledgments

- Original inspiration from [sdelrio's RPi-hostap](https://github.com/sdelrio/rpi-hostap) implementation.
- Docker container and health check enhancements by SimeonOnSecurity.

For additional details and configurations, refer to the Dockerfile and the accompanying `docker-init.sh` and `healthcheck.sh` scripts provided with this container.