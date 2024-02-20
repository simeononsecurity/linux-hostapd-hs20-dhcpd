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
: ${INTERFACE:=${INTERFACE}}
: ${SUBNET:=192.168.200.0}
: ${AP_ADDR:=192.168.200.1}
: ${PRI_DNS:=1.1.1.2}
: ${SEC_DNS:=1.0.0.2}
: ${SSID:=Orion}
: ${CHANNEL:=11}

# HOSTAPD Configuration Variables
: ${DRIVER:=nl80211}
: ${LOGGER_SYSLOG:=127}
: ${LOGGER_SYSLOG_LEVEL:=2}
: ${LOGGER_STDOUT:=127}
: ${LOGGER_STDOUT_LEVEL:=2}
: ${COUNTRY_CODE:=US}
: ${IEEE80211D:=1}
: ${IEEE80211H:=1}
: ${HW_MODE:=a}
: ${BEACON_INT:=100}
# Set CHANNEL to 'acs_survey' if it's not already defined
: ${CHANNEL:=acs_survey}
# Set CHANLIST only if CHANNEL is set to 'acs_survey'
if [ "$CHANNEL" = "acs_survey" ]; then
  : ${CHANLIST:=36,40,44,48,149,153,157,161}
fi

# Transmission Queue Settings
: ${TX_QUEUE_DATA2_BURST:=2.0}

# IEEE 802.11n/ac/ax Configuration
: ${IEEE80211N:=1}
: ${HT_COEX:=0}
: ${HT_CAPAB:=[HT40+][LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][MAX-AMSDU-7935]}
: ${IEEE80211AC:=1}
: ${VHT_OPER_CHWIDTH:=1}
: ${VHT_OPER_CENTR_FREQ_SEG0_IDX:=-6}
: ${VHT_CAPAB:=[RXLDPC][SHORT-GI-80][SHORT-GI-160][TX-STBC-2BY1][SU-BEAMFORMER][SU-BEAMFORMEE][MU-BEAMFORMER][MU-BEAMFORMEE][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN][RX-STBC-1][SOUNDING-DIMENSION-4][BF-ANTENNA-4][VHT160][MAX-MPDU-11454][MAX-A-MPDU-LEN-EXP7]}
: ${IEEE80211AX:=0}

# Basic Service Set (BSS) Configuration
: ${BSS:=phy1-ap0}
: ${CTRL_INTERFACE:=/var/run/hostapd}
: ${AP_ISOLATE:=1}
: ${BSS_LOAD_UPDATE_PERIOD:=60}
: ${CHAN_UTIL_AVG_PERIOD:=600}
: ${DISASSOC_LOW_ACK:=1}
: ${SKIP_INACTIVITY_POLL:=0}
: ${PREAMBLE:=1}
: ${WMM_ENABLED:=1}
: ${IGNORE_BROADCAST_SSID:=0}
: ${UAPSD_ADVERTISEMENT_ENABLED:=1}
: ${UTF8_SSID:=1}
: ${MULTI_AP:=0}

# Accounting Server Configuration
: ${ACCT_SERVER_ADDR:=127.0.0.1}
: ${ACCT_SERVER_PORT:=1813}
: ${ACCT_SERVER_SHARED_SECRET:=radsec}

# Authentication Server Configuration
: ${AUTH_SERVER_ADDR:=127.0.0.1}
: ${AUTH_SERVER_PORT:=1812}
: ${AUTH_SERVER_SHARED_SECRET:=radsec}
: ${RADIUS_REQUEST_CUI:=1}
: ${DYNAMIC_OWN_IP_ADDR:=1}

# Simultaneous Authentication of Equals (SAE) Configuration
: ${SAE_REQUIRE_MFP:=1}
: ${SAE_PWE:=2}

# IEEE 802.1X Configuration
: ${EAPOL_KEY_INDEX_WORKAROUND:=1}
: ${IEEE8021X:=1}
: ${AUTH_ALGS:=1}
: ${WPA:=2}
: ${WPA_PAIRWISE:=CCMP}
: ${SSID:=Orion}
: ${BRIDGE:=}
: ${WDS_BRIDGE:=}
: ${SNOOP_IFACE:=}
: ${TIME_ZONE:=}
: ${BSS_TRANSITION:=1}
: ${RRM_NEIGHBOR_REPORT:=1}
: ${RRM_BEACON_REPORT:=1}
: ${WPA_DISABLE_EAPOL_KEY_RETRIES:=1}
: ${WPA_KEY_MGMT:=WPA-EAP WPA-EAP-SHA256}
: ${OKC:=0}
: ${DISABLE_PMKSA_CACHING:=1}
: ${IEEE80211W:=1}
: ${GROUP_MGMT_CIPHER:=AES-128-CMAC}
: ${INTERWORKING:=1}
: ${INTERNET:=1}
: ${ASRA:=0}
: ${ESR:=0}
: ${UESA:=0}
: ${ACCESS_NETWORK_TYPE:=2}
: ${VENUE_GROUP:=1}
: ${VENUE_TYPE:=7}
: ${NETWORK_AUTH_TYPE:=00}
: ${ROAMING_CONSORTIUM:=f4f5e8f5f4}
: ${NAI_REALM_ORION:=0,*.orion.area120.com,13[5:6],21[2:4][5:7],23[5:1][5:2],50[5:1][5:2],18[5:1][5:2]}
: ${VENUE_NAME:=eng:Orion}
: ${VENUE_URL:=1:https://orionwifi.com}
: ${DOMAIN_NAME:=orion.area120.com}
: ${ANQP_3GPP_CELL_NET:=310,150;310,280;310,410;313,100}
: ${QOS_MAP_SET:=}
: ${HS20:=1}
: ${DISABLE_DGAF:=1}
: ${OSEN:=0}
: ${ANQP_DOMAIN_ID:=0}
: ${HS20_DEAUTH_REQ_TIMEOUT:=60}
: ${HS20_OPERATING_CLASS:=5173}
: ${HS20_OPER_FRIENDLY_NAME:=eng:Orion}
: ${OPERATOR_ICON:=64:64:eng:image/png:operator_icon:operator_icon.png}

# Use `ip link` to get the MAC address of the interface and assign it to BSSID
BSSID=$(ip link show $INTERFACE | awk '/ether/ {print $2}')

# Check if BSSID is successfully retrieved and not empty
if [ -n "$BSSID" ]; then
  echo "BSSID for $INTERFACE is set to $BSSID"
else
  echo "Failed to retrieve BSSID for $INTERFACE"
fi

# Network Access Server (NAS) Identifier
# Set NAS_IDENTIFIER to INTERFACE_BSSID if not already set
: ${NAS_IDENTIFIER:=${INTERFACE}_${BSSID}}

# Function to configure hostapd
configure_hostapd() {
    if [ ! -f "/etc/hostapd.conf" ]; then
        cat > "/etc/hostapd.conf" <<EOF
driver=${DRIVER}
logger_syslog=${LOGGER_SYSLOG}
logger_syslog_level=${LOGGER_SYSLOG_LEVEL}
logger_stdout=${LOGGER_STDOUT}
logger_stdout_level=${LOGGER_STDOUT_LEVEL}
country_code=${COUNTRY_CODE}
ieee80211d=${IEEE80211D}
ieee80211h=${IEEE80211H}
hw_mode=${HW_MODE}
beacon_int=${BEACON_INT}
channel=${CHANNEL}
${CHANLIST+"chanlist=${CHANLIST}"}


tx_queue_data2_burst=${TX_QUEUE_DATA2_BURST}

ieee80211n=${IEEE80211N}
ht_coex=${HT_COEX}
${HT_ENABLED+"ieee80211n=1"}
${HT_CAPAB+"ht_capab=${HT_CAPAB}"}
ieee80211ac=${IEEE80211AC}
vht_oper_chwidth=${VHT_OPER_CHWIDTH}
vht_oper_centr_freq_seg0_idx=${VHT_OPER_CENTR_FREQ_SEG0_IDX}
${VHT_ENABLED+"ieee80211ac=1"}
${VHT_CAPAB+"vht_capab=${VHT_CAPAB}"}
ieee80211ax=${IEEE80211AX}

interface=wlan1
ctrl_interface=${CTRL_INTERFACE}
ap_isolate=${AP_ISOLATE}
bss_load_update_period=${BSS_LOAD_UPDATE_PERIOD}
chan_util_avg_period=${CHAN_UTIL_AVG_PERIOD}
disassoc_low_ack=${DISASSOC_LOW_ACK}
skip_inactivity_poll=${SKIP_INACTIVITY_POLL}
preamble=${PREAMBLE}
wmm_enabled=${WMM_ENABLED}
ignore_broadcast_ssid=${IGNORE_BROADCAST_SSID}
uapsd_advertisement_enabled=${UAPSD_ADVERTISEMENT_ENABLED}
utf8_ssid=${UTF8_SSID}
multi_ap=${MULTI_AP}

acct_server_addr=${ACCT_SERVER_ADDR}
acct_server_port=${ACCT_SERVER_PORT}
acct_server_shared_secret=${ACCT_SERVER_SHARED_SECRET}

auth_server_addr=${AUTH_SERVER_ADDR}
auth_server_port=${AUTH_SERVER_PORT}
auth_server_shared_secret=${AUTH_SERVER_SHARED_SECRET}

sae_require_mfp=${SAE_REQUIRE_MFP}
sae_pwe=${SAE_PWE}

eapol_key_index_workaround=${EAPOL_KEY_INDEX_WORKAROUND}
ieee8021x=${IEEE8021X}
auth_algs=${AUTH_ALGS}
wpa=${WPA}
wpa_pairwise=${WPA_PAIRWISE}
ssid=${SSID}

${BRIDGE+"bridge=${BRIDGE}"}
${WDS_BRIDGE+"wds_bridge=${WDS_BRIDGE}"}
${SNOOP_IFACE+"snoop_iface=${SNOOP_IFACE}"}
${TIME_ZONE+"time_zone=${TIME_ZONE}"}
${QOS_MAP_SET+"qos_map_set=${QOS_MAP_SET}"}

bss_transition=${BSS_TRANSITION}
rrm_neighbor_report=${RRM_NEIGHBOR_REPORT}
rrm_beacon_report=${RRM_BEACON_REPORT}

wpa_disable_eapol_key_retries=${WPA_DISABLE_EAPOL_KEY_RETRIES}
wpa_key_mgmt=${WPA_KEY_MGMT}
okc=${OKC}
disable_pmksa_caching=${DISABLE_PMKSA_CACHING}
ieee80211w=${IEEE80211W}
group_mgmt_cipher=${GROUP_MGMT_CIPHER}

## HS20 Options
interworking=${INTERWORKING}
internet=${INTERNET}
asra=${ASRA}
esr=${ESR}
uesa=${UESA}
access_network_type=${ACCESS_NETWORK_TYPE}
venue_group=${VENUE_GROUP}
venue_type=${VENUE_TYPE}
network_auth_type=${NETWORK_AUTH_TYPE}
roaming_consortium=${ROAMING_CONSORTIUM}
nai_realm=${NAI_REALM_ORION}
venue_name=${VENUE_NAME}
venue_url=${VENUE_URL}
domain_name=${DOMAIN_NAME}
anqp_3gpp_cell_net=${ANQP_3GPP_CELL_NET}
hs20=${HS20}
disable_dgaf=${DISABLE_DGAF}
osen=${OSEN}
anqp_domain_id=${ANQP_DOMAIN_ID}
hs20_deauth_req_timeout=${HS20_DEAUTH_REQ_TIMEOUT}
hs20_operating_class=${HS20_OPERATING_CLASS}
hs20_oper_friendly_name=${HS20_OPER_FRIENDLY_NAME}
operator_icon=${OPERATOR_ICON}
nas_identifier=${NAS_IDENTIFIER}
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
    mkdir /run/dhcp/
    touch /run/dhcp/dhcpd.pid
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
