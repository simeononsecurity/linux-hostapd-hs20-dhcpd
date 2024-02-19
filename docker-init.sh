#!/bin/bash

# Exit on any error and pipefail to catch errors in pipelines
set -eo pipefail

# Define log file path
LOG_FILE="/var/log/docker_init.log"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a $LOG_FILE
}

# Check if running in privileged mode
if [ ! -w "/sys" ]; then
    log "[Error] Not running in privileged mode."
    exit 1
fi

# Check environment variables
if [ -z "${INTERFACE}" ]; then
    log "[Error] An interface must be specified."
    exit 1
fi

# Set default values for environment variables
: ${SUBNET:=192.168.200.0}
: ${AP_ADDR:=192.168.200.1}
: ${PRI_DNS:=1.1.1.2}
: ${SEC_DNS:=1.0.0.2}
: ${SSID:=raspberry}
: ${CHANNEL:=11}
: ${WPA_PASSPHRASE:=passw0rd}
: ${HW_MODE:=g}

# Function to configure hostapd
configure_hostapd() {
    if [ ! -f "/etc/hostapd.conf" ]; then
        cat > "/etc/hostapd.conf" <<EOF
interface=${INTERFACE}
${DRIVER+"driver=${DRIVER}"}
ssid=${SSID}
hw_mode=${HW_MODE}
channel=${CHANNEL}
wpa=2
wpa_passphrase=${WPA_PASSPHRASE}
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wpa_ptk_rekey=600
wmm_enabled=1
${HT_ENABLED+"ieee80211n=1"}
${HT_CAPAB+"ht_capab=${HT_CAPAB}"}
${VHT_ENABLED+"ieee80211ac=1"}
${VHT_CAPAB+"vht_capab=${VHT_CAPAB}"}
EOF
    fi
}

# Function to setup interface and restart DHCP service
setup_interface() {
    ip link set ${INTERFACE} up
    ip addr flush dev ${INTERFACE}
    ip addr add ${AP_ADDR}/24 dev ${INTERFACE}
    cat /proc/sys/net/ipv4/ip_dynaddr
    cat /proc/sys/net/ipv4/ip_forward
}

# Function to setup NAT settings
setup_nat() {
    log "Configuring NAT settings ip_dynaddr, ip_forward"
    for i in ip_dynaddr ip_forward; do
        if [ $(cat /proc/sys/net/ipv4/$i) -eq 1 ]; then
            log "$i already 1"
        else
            echo "1" > /proc/sys/net/ipv4/$i
            log "$i set to 1"
        fi
    done
}

# Function to setup iptables
setup_iptables() {
    if [ -n "${OUTGOINGS}" ]; then
        ints="$(sed 's/,\+/ /g' <<<"${OUTGOINGS}")"
        for int in ${ints}; do
            log "Setting iptables for outgoing traffics on ${int}..."
            iptables -t nat -D POSTROUTING -s ${SUBNET}/24 -o ${int} -j MASQUERADE 2>/dev/null || true
            iptables -t nat -A POSTROUTING -s ${SUBNET}/24 -o ${int} -j MASQUERADE

            iptables -D FORWARD -i ${int} -o ${INTERFACE} -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
            iptables -A FORWARD -i ${int} -o ${INTERFACE} -m state --state RELATED,ESTABLISHED -j ACCEPT

            iptables -D FORWARD -i ${INTERFACE} -o ${int} -j ACCEPT 2>/dev/null || true
            iptables -A FORWARD -i ${INTERFACE} -o ${int} -j ACCEPT
        done
    else
        log "Setting iptables for outgoing traffics on all interfaces..."
        iptables -t nat -D POSTROUTING -s ${SUBNET}/24 -j MASQUERADE 2>/dev/null || true
        iptables -t nat -A POSTROUTING -s ${SUBNET}/24 -j MASQUERADE

        iptables -D FORWARD -o ${INTERFACE} -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
        iptables -A FORWARD -o ${INTERFACE} -m state --state RELATED,ESTABLISHED -j ACCEPT

        iptables -D FORWARD -i ${INTERFACE} -j ACCEPT 2>/dev/null || true
        iptables -A FORWARD -i ${INTERFACE} -j ACCEPT
    fi
}

# Function to configure DHCP server
configure_dhcp() {
    log "Configuring DHCP server..."
    cat > "/etc/dhcp/dhcpd.conf" <<EOF
option domain-name-servers ${PRI_DNS}, ${SEC_DNS};
option subnet-mask 255.255.255.0;
option routers ${AP_ADDR};
subnet ${SUBNET} netmask 255.255.255.0 {
  range ${SUBNET::-1}100 ${SUBNET::-1}200;
}
EOF
}

# Function to start DHCP server
start_dhcp() {
    log "Starting DHCP server..."
    dhcpd ${INTERFACE} &
}

# Function to start hostapd
start_hostapd() {
    log "Starting HostAP daemon..."
    /usr/sbin/hostapd /etc/hostapd.conf &
}

# Function to cleanup on exit
cleanup() {
    log "Removing iptables rules..."
    iptables -t nat -F
    iptables -F
    ip addr flush dev ${INTERFACE}
    log "Cleanup completed."
}

# Capture signals for cleanup
trap cleanup SIGINT SIGTERM SIGHUP

# Main execution flow
configure_hostapd
setup_interface
setup_nat
setup_iptables
configure_dhcp
start_dhcp
start_hostapd

# Wait for hostapd to finish
wait $!

cleanup
