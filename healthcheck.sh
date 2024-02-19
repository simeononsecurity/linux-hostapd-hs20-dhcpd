#!/bin/bash

# Check if hostapd is running
pgrep hostapd > /dev/null || exit 1

# Check if dhcpd is running
pgrep dhcpd > /dev/null || exit 1

# Replace `eth0` with your actual interface variable or hardcode the expected interface
if [ -z "${INTERFACE}" ]; then
    echo "The INTERFACE environment variable is not set."
    exit 1
fi

# Check if the interface is up and has an IP address
ip addr show $INTERFACE | grep -q 'state UP' && ip addr show $INTERFACE | grep -q 'inet ' || exit 1

# If all checks pass
exit 0
