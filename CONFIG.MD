# hostapd Configuration and Env Variable Documentation

## Recommended Hardare
This docker container includes defaults and assumptions in mind for specific hardware adapters. They are recommended below. If you choose to use another adapter, be aware that you'll need to read the [hostapd.conf documentation](https://web.mit.edu/freebsd/head/contrib/wpa/hostapd/hostapd.conf) and look at `CONFIG.md` and `docker-init.sh` to figure out what config items you may need to change and [this documentation](https://github.com/morrownr/USB-WiFi/blob/main/home/USB_WiFi_Chipsets.md) to see what kernel level you need to be at.

- [ALFA AWUS036AXM](https://amzn.to/3Texv3H)
- [NETGEAR WiFi AC1200 (A6210)](https://amzn.to/3T5FdwX)

## Network Configuration Variables

### INTERFACE
- **Purpose**: Specifies the network interface that `hostapd` will manage.
- **Default Value**: Uses existing value of `INTERFACE` if set; otherwise, must be explicitly defined.
- **Example**: `INTERFACE=wlan0`

### SUBNET
- **Purpose**: Defines the subnet for the DHCP configuration associated with the wireless network.
- **Default Value**: `192.168.200.0`
- **Example**: `SUBNET=192.168.100.0`

### AP_ADDR
- **Purpose**: The IP address of the access point within the specified subnet.
- **Default Value**: `192.168.200.1`
- **Example**: `AP_ADDR=192.168.200.254`

### PRI_DNS
- **Purpose**: Primary DNS server IP address for client devices connected to the access point.
- **Default Value**: `1.1.1.2`
- **Example**: `PRI_DNS=8.8.8.8`

### SEC_DNS
- **Purpose**: Secondary DNS server IP address for client devices.
- **Default Value**: `1.0.0.2`
- **Example**: `SEC_DNS=8.8.4.4`

### SSID
- **Purpose**: Specifies the SSID (network name) for the wireless network.
- **Default Value**: `Orion`
- **Example**: `SSID=MyHomeNetwork`

### DRIVER
- **Purpose**: Specifies the driver to be used by hostapd for the wireless interface.
- **Default Value**: `nl80211` (the most common driver for modern Linux-based systems supporting 802.11 interfaces).
- **Example**: `DRIVER=nl80211`

### LOGGER_SYSLOG
- **Purpose**: Enables or disables logging of hostapd messages to the system log (syslog).
- **Default Value**: `127` (enabled with maximum verbosity).
- **Example**: `LOGGER_SYSLOG=0` (to disable) or `LOGGER_SYSLOG=127` (to enable).

### LOGGER_SYSLOG_LEVEL
- **Purpose**: Sets the verbosity level of messages logged to syslog.
- **Default Value**: `2` (informational messages and higher severity).
- **Example**: `LOGGER_SYSLOG_LEVEL=1` (for more verbose logging).

### LOGGER_STDOUT
- **Purpose**: Enables or disables logging of hostapd messages to standard output (useful for debugging).
- **Default Value**: `127` (enabled with maximum verbosity).
- **Example**: `LOGGER_STDOUT=0` (to disable) or `LOGGER_STDOUT=127` (to enable).

### LOGGER_STDOUT_LEVEL
- **Purpose**: Sets the verbosity level of messages logged to standard output.
- **Default Value**: `2` (informational messages and higher severity).
- **Example**: `LOGGER_STDOUT_LEVEL=1` (for more verbose output).

### COUNTRY_CODE
- **Purpose**: Sets the country code to ensure the wireless operation complies with local regulatory requirements.
- **Default Value**: `US` (United States).
- **Example**: `COUNTRY_CODE=GB` (for the United Kingdom).

### IEEE80211D
- **Purpose**: Enables or disables 802.11d (International Roaming) support.
- **Default Value**: `1` (enabled).
- **Example**: `IEEE80211D=0` (to disable).

### IEEE80211H
- **Purpose**: Enables or disables 802.11h (Spectrum Management) support.
- **Default Value**: `1` (enabled).
- **Example**: `IEEE80211H=0` (to disable).

### HW_MODE
- **Purpose**: Specifies the hardware mode (frequency band) of the wireless network.
- **Default Value**: `a` (5 GHz).
- **Example**: `HW_MODE=g` (for 2.4 GHz).

### BEACON_INT
- **Purpose**: Sets the beacon interval in milliseconds.
- **Default Value**: `100` (100 milliseconds).
- **Example**: `BEACON_INT=50` (for a faster beacon rate).

### CHANNEL
- **Purpose**: Sets the wireless channel. Special value `acs_survey` enables Automatic Channel Selection.
- **Default Value**: `acs_survey` (Automatic Channel Selection based on survey).
- **Example**: `CHANNEL=6` (to manually set the channel to 6).
- **Details**: If channel is not defined, the AP will default to channel selection from a chanel list of 5 Ghz channels. If you want to use 2.4 Ghz, you'll need to appropriately define the channel.

### CHANLIST
- **Purpose**: Specifies a list of allowed channels for Automatic Channel Selection.
- **Condition**: Only set if `CHANNEL` is `acs_survey`.
- **Default Value**: `36,40,44,48,149,153,157,161` (a list of 5 GHz channels).
- **Example**: `CHANLIST=1,6,11` (to limit ACS to these 2.4 GHz channels).

## Transmission Queue Settings and IEEE 802.11 Standards Configuration Documentation

### Transmission Queue Settings

#### TX_QUEUE_DATA2_BURST
- **Purpose**: Configures the burst value for data queue 2, which can affect throughput and latency.
- **Default Value**: `2.0`
- **Example**: `TX_QUEUE_DATA2_BURST=1.5`

### IEEE 802.11n/ac/ax Configuration

#### IEEE80211N
- **Purpose**: Enables or disables support for IEEE 802.11n (High Throughput) features.
- **Default Value**: `1` (enabled).
- **Example**: `IEEE80211N=0` (to disable).

#### HT_COEX
- **Purpose**: Enables or disables 802.11n coexistence protection for 40 MHz channels in the 2.4 GHz band.
- **Default Value**: `0` (disabled).
- **Example**: `HT_COEX=1` (to enable).

#### HT_CAPAB
- **Purpose**: Specifies the High Throughput (HT) capabilities of the 802.11n network.
- **Default Value**: `[HT40+][LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][MAX-AMSDU-7935]`
- **Example**: `HT_CAPAB=[HT40-][SHORT-GI-20]`

#### IEEE80211AC
- **Purpose**: Enables or disables support for IEEE 802.11ac (Very High Throughput) features.
- **Default Value**: `1` (enabled).
- **Example**: `IEEE80211AC=0` (to disable).

#### VHT_OPER_CHWIDTH
- **Purpose**: Sets the channel width for VHT operation. `0` for 20 or 40 MHz, `1` for 80 MHz, etc.
- **Default Value**: `1` (80 MHz channel width).
- **Example**: `VHT_OPER_CHWIDTH=2` (for 160 MHz channel width).

#### VHT_OPER_CENTR_FREQ_SEG0_IDX
- **Purpose**: Specifies the center frequency segment 0 index for VHT operation, affecting the channel's center frequency.
- **Default Value**: `-6`
- **Example**: `VHT_OPER_CENTR_FREQ_SEG0_IDX=42`

#### VHT_CAPAB
- **Purpose**: Defines the Very High Throughput (VHT) capabilities of the 802.11ac network.
- **Default Value**: `[RXLDPC][SHORT-GI-80][SHORT-GI-160][TX-STBC-2BY1][SU-BEAMFORMER][SU-BEAMFORMEE][MU-BEAMFORMER][MU-BEAMFORMEE][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN][RX-STBC-1][SOUNDING-DIMENSION-4][BF-ANTENNA-4][VHT160][MAX-MPDU-11454][MAX-A-MPDU-LEN-EXP7]`
- **Example**: `VHT_CAPAB=[SHORT-GI-80][SU-BEAMFORMEE]`

#### IEEE80211AX
- **Purpose**: Enables or disables support for IEEE 802.11ax (Wi-Fi 6) features.
- **Default Value**: `0` (disabled).
- **Example**: `IEEE80211AX=1` (to enable).

## Basic Service Set (BSS) Configuration Documentation

### BSS
- **Purpose**: Specifies the Basic Service Set identifier for the access point.
- **Default Value**: `phy1-ap0`
- **Example**: `BSS=phy0-ap1`

### CTRL_INTERFACE
- **Purpose**: Defines the path for the control interface directory used by hostapd to communicate with other processes.
- **Default Value**: `/var/run/hostapd`
- **Example**: `CTRL_INTERFACE=/var/run/wpa_supplicant`

### AP_ISOLATE
- **Purpose**: Enables or disables client isolation within the same access point, preventing direct communication between clients.
- **Default Value**: `1` (enabled)
- **Example**: `AP_ISOLATE=0` (to disable client isolation)

### BSS_LOAD_UPDATE_PERIOD
- **Purpose**: Sets the period in seconds for updating BSS load element in beacon and probe response frames.
- **Default Value**: `60`
- **Example**: `BSS_LOAD_UPDATE_PERIOD=30`

### CHAN_UTIL_AVG_PERIOD
- **Purpose**: Specifies the channel utilization averaging period in seconds.
- **Default Value**: `600`
- **Example**: `CHAN_UTIL_AVG_PERIOD=300`

### DISASSOC_LOW_ACK
- **Purpose**: Enables or disables the feature to disassociate clients that are not acknowledging frames.
- **Default Value**: `1` (enabled)
- **Example**: `DISASSOC_LOW_ACK=0` (to disable)

### SKIP_INACTIVITY_POLL
- **Purpose**: Enables or disables the skipping of inactivity polling of clients.
- **Default Value**: `0` (disabled)
- **Example**: `SKIP_INACTIVITY_POLL=1` (to enable skipping)

### PREAMBLE
- **Purpose**: Configures the use of short or long preamble. A short preamble improves throughput.
- **Default Value**: `1` (short preamble enabled)
- **Example**: `PREAMBLE=0` (to use long preamble)

### WMM_ENABLED
- **Purpose**: Enables or disables Wi-Fi Multimedia (WMM) support, which is essential for quality of service in Wi-Fi networks.
- **Default Value**: `1` (enabled)
- **Example**: `WMM_ENABLED=0` (to disable)

### IGNORE_BROADCAST_SSID
- **Purpose**: Configures the access point to hide the SSID in beacon frames, making the network name not broadcasted.
- **Default Value**: `0` (disabled, SSID is broadcast)
- **Example**: `IGNORE_BROADCAST_SSID=1` (to enable SSID hiding)

### UAPSD_ADVERTISEMENT_ENABLED
- **Purpose**: Enables or disables Unscheduled Automatic Power Save Delivery (U-APSD) advertisement in beacon frames, which can save power for clients.
- **Default Value**: `1` (enabled)
- **Example**: `UAPSD_ADVERTISEMENT_ENABLED=0` (to disable)

### UTF8_SSID
- **Purpose**: Allows the use of UTF-8 encoded SSIDs, enabling more character options for the network name.
- **Default Value**: `1` (enabled)
- **Example**: `UTF8_SSID=0` (to disable)

### MULTI_AP
- **Purpose**: Enables or disables the Multi-AP feature to support EasyMesh.
- **Default Value**: `0` (disabled)
- **Example**: `MULTI_AP=1` (to enable)
## Accounting and Authentication Server Configuration Documentation

### Accounting Server Configuration

#### ACCT_SERVER_ADDR
- **Purpose**: Specifies the IP address of the RADIUS accounting server.
- **Default Value**: `127.0.0.1` (localhost)
- **Example**: `ACCT_SERVER_ADDR=192.168.1.100`

#### ACCT_SERVER_PORT
- **Purpose**: Sets the port number for the RADIUS accounting server.
- **Default Value**: `1813`
- **Example**: `ACCT_SERVER_PORT=1813`

#### ACCT_SERVER_SHARED_SECRET
- **Purpose**: Defines the shared secret used for authenticating with the RADIUS accounting server.
- **Default Value**: `radsec`
- **Example**: `ACCT_SERVER_SHARED_SECRET=mysecret`

### Authentication Server Configuration

#### AUTH_SERVER_ADDR
- **Purpose**: Specifies the IP address of the RADIUS authentication server.
- **Default Value**: `127.0.0.1` (localhost)
- **Example**: `AUTH_SERVER_ADDR=192.168.1.101`

#### AUTH_SERVER_PORT
- **Purpose**: Sets the port number for the RADIUS authentication server.
- **Default Value**: `1812`
- **Example**: `AUTH_SERVER_PORT=1812`

#### AUTH_SERVER_SHARED_SECRET
- **Purpose**: Defines the shared secret used for authenticating with the RADIUS authentication server.
- **Default Value**: `radsec`
- **Example**: `AUTH_SERVER_SHARED_SECRET=mysecret2`

#### RADIUS_REQUEST_CUI
- **Purpose**: Enables or disables the request for Chargeable User Identity (CUI) from the RADIUS server.
- **Default Value**: `1` (enabled)
- **Example**: `RADIUS_REQUEST_CUI=0` (to disable)

#### DYNAMIC_OWN_IP_ADDR
- **Purpose**: Enables or disables the dynamic selection of the host IP address in RADIUS messages.
- **Default Value**: `1` (enabled)
- **Example**: `DYNAMIC_OWN_IP_ADDR=0` (to disable)

### Simultaneous Authentication of Equals (SAE) Configuration

#### SAE_REQUIRE_MFP
- **Purpose**: Requires Management Frame Protection (MFP) for SAE authentication, enhancing security.
- **Default Value**: `1` (required)
- **Example**: `SAE_REQUIRE_MFP=0` (not required)

#### SAE_PWE
- **Purpose**: Specifies the method for deriving the Password Element (PWE) in SAE, affecting compatibility and security.
- **Default Value**: `2`
- **Example**: `SAE_PWE=1` (for hunting-and-pecking method)

## IEEE 802.1X and Wi-Fi Alliance Hotspot 2.0 Configuration Documentation

### IEEE 802.1X Configuration

#### EAPOL_KEY_INDEX_WORKAROUND
- **Purpose**: Enables a workaround for devices that do not properly set key indexes in EAPOL-Key frames.
- **Default Value**: `1` (enabled)
- **Example**: `EAPOL_KEY_INDEX_WORKAROUND=0` (to disable)

#### IEEE8021X
- **Purpose**: Enables or disables IEEE 802.1X authentication (often used for WPA/WPA2 Enterprise).
- **Default Value**: `1` (enabled)
- **Example**: `IEEE8021X=0` (to disable)

#### AUTH_ALGS
- **Purpose**: Specifies the authentication algorithms to be used.
- **Default Value**: `1` (Open System authentication)
- **Example**: `AUTH_ALGS=3` (Open System and Shared Key authentication)

#### WPA
- **Purpose**: Specifies the WPA mode (WPA, WPA2, or both).
- **Default Value**: `2` (WPA2)
- **Example**: `WPA=3` (both WPA and WPA2)

#### WPA_PAIRWISE
- **Purpose**: Specifies the pairwise cipher(s) for WPA.
- **Default Value**: `CCMP` (AES encryption)
- **Example**: `WPA_PAIRWISE=TKIP CCMP` (both TKIP and AES encryption)

#### SSID
- **Purpose**: Specifies the SSID of the wireless network.
- **Default Value**: `Orion`
- **Example**: `SSID=MyNetwork`

#### BRIDGE
- **Purpose**: Specifies the bridge interface to add the wireless interface to (if bridging is used).
- **Default Value**: Not set
- **Example**: `BRIDGE=br0`

#### WDS_BRIDGE
- **Purpose**: Specifies a bridge interface for WDS (Wireless Distribution System) if used.
- **Default Value**: Not set
- **Example**: `WDS_BRIDGE=br1`

#### SNOOP_IFACE
- **Purpose**: Specifies an interface for IGMP snooping.
- **Default Value**: Not set
- **Example**: `SNOOP_IFACE=eth0`

#### TIME_ZONE
- **Purpose**: Specifies the local timezone of the AP for time-related information broadcast.
- **Default Value**: Not set
- **Example**: `TIME_ZONE=EST5EDT`

#### BSS_TRANSITION
- **Purpose**: Enables or disables support for BSS Transition Management.
- **Default Value**: `1` (enabled)
- **Example**: `BSS_TRANSITION=0` (to disable)

#### RRM_NEIGHBOR_REPORT and RRM_BEACON_REPORT
- **Purpose**: Enables Radio Resource Management (RRM) features for neighbor and beacon reporting.
- **Default Value**: `1` (enabled)
- **Example**: `RRM_NEIGHBOR_REPORT=0` or `RRM_BEACON_REPORT=0` (to disable)

#### WPA_DISABLE_EAPOL_KEY_RETRIES
- **Purpose**: Disables retries for EAPOL-Key frames to prevent attacks.
- **Default Value**: `1` (disabled)
- **Example**: `WPA_DISABLE_EAPOL_KEY_RETRIES=0` (to enable retries)

#### WPA_KEY_MGMT
- **Purpose**: Specifies the key management suite(s) used in WPA/WPA2.
- **Default Value**: `WPA-EAP WPA-EAP-SHA256`
- **Example**: `WPA_KEY_MGMT=WPA-PSK`

#### OKC and DISABLE_PMKSA_CACHING
- **Purpose**: Controls Opportunistic Key Caching and PMKSA caching, affecting fast reauthentication.
- **Default Value**: `OKC=0` (disabled), `DISABLE_PMKSA_CACHING=1` (enabled)
- **Example**: `OKC=1`, `DISABLE_PMKSA_CACHING=0`

#### IEEE80211W
- **Purpose**: Enables or disables management frame protection (IEEE 802.11w).
- **Default Value**: `1` (enabled)
- **Example**: `IEEE80211W=0` (to disable)

#### GROUP_MGMT_CIPHER
- **Purpose**: Specifies the group management cipher suite.
- **Default Value**: `AES-128-CMAC`
- **Example**: `GROUP_MGMT_CIPHER=BIP-GMAC-256`

### Hotspot 2.0 (HS2.0) and Interworking Configuration

#### INTERWORKING and INTERNET
- **Purpose**: Enables Interworking and advertises internet availability.
- **Default Value**: `INTERWORKING=1` (enabled), `INTERNET=1` (internet available)
- **Example**: `INTERWORKING=0`, `INTERNET=

0` (to disable)

#### ASRA, ESR, UESA
- **Purpose**: Configures Access Network Query Protocol (ANQP) elements for HS2.0.
- **Default Value**: `ASRA=0`, `ESR=0`, `UESA=0` (all disabled)
- **Example**: `ASRA=1`, `ESR=1`, `UESA=1` (to enable)

#### ACCESS_NETWORK_TYPE, VENUE_GROUP, VENUE_TYPE
- **Purpose**: Specifies network type, venue group, and type for HS2.0.
- **Default Values**: `ACCESS_NETWORK_TYPE=2`, `VENUE_GROUP=1`, `VENUE_TYPE=7`
- **Examples**: `ACCESS_NETWORK_TYPE=0`, `VENUE_GROUP=2`, `VENUE_TYPE=5`

##### Access Network Type

Configure the Access Network Type using the following format:

| Access Network Type | Description                           |
|---------------------|---------------------------------------|
| 0                   | Private network                       |
| 1                   | Private network with guest access     |
| 2                   | Chargeable public network             |
| 3                   | Free public network                   |
| 4                   | Personal device network               |
| 5                   | Emergency services only network       |
| 14                  | Test or experimental                  |
| 15                  | Wildcard                              |

**Explanation**:

- The 'Access Network Type' specifies the nature of the network, helping devices categorize and interact appropriately.
- Choose the appropriate number to define the desired network type.

##### Venue Info (Optional)

Configure Venue Information using the following format:

> **Group, Type**

###### IEEE Std 802.11u-2011 Venue Group and Type Values:

Here are the individual tables for each the venue groups and venue types:

**Venue Groups**

| Venue Group Name   | Value |
|--------------------|-------|
| UNSPECIFIED        | 0     |
| ASSEMBLY           | 1     |
| BUSINESS           | 2     |
| EDUCATIONAL        | 3     |
| FACTORY-INDUSTRIAL| 4     |
| INSTITUTIONAL      | 5     |
| MERCANTILE         | 6     |
| RESIDENTIAL        | 7     |
| STORAGE            | 8     |
| UTILITY-MISC       | 9     |
| VEHICULAR          | 10    |
| OUTDOOR            | 11    |

**Venue Types for UNSPECIFIED ASSEMBLY (Group Value: 1)**

| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED ASSEMBLY                            |
| 1                | ARENA                                            |
| 2                | STADIUM                                          |
| 3                | PASSENGER TERMINAL (E.G., AIRPORT, BUS, FERRY, TRAIN STATION) |
| 4                | AMPHITHEATER                                     |
| 5                | AMUSEMENT PARK                                   |
| 6                | PLACE OF WORSHIP                                 |
| 7                | CONVENTION CENTER                                |
| 8                | LIBRARY                                          |
| 9                | MUSEUM                                           |
| 10               | RESTAURANT                                       |
| 11               | THEATER                                          |
| 12               | BAR                                              |
| 13               | COFFEE SHOP                                      |
| 14               | ZOO OR AQUARIUM                                  |
| 15               | EMERGENCY COORDINATION CENTER                    |

**Venue Types for UNSPECIFIED BUSINESS (Group Value: 2)**

| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED BUSINESS                            |
| 1                | DOCTOR OR DENTIST OFFICE                        |
| 2                | BANK                                             |
| 3                | FIRE STATION                                     |
| 4                | POLICE STATION                                   |
| 6                | POST OFFICE                                      |
| 7                | PROFESSIONAL OFFICE                             |
| 8                | RESEARCH AND DEVELOPMENT FACILITY               |
| 9                | ATTORNEY OFFICE                                 |

**Venue Types for UNSPECIFIED EDUCATIONAL (Group Value: 3)**

| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED EDUCATIONAL                         |
| 1                | SCHOOL, PRIMARY                                  |
| 2                | SCHOOL, SECONDARY                                |
| 3                | UNIVERSITY OR COLLEGE                            |

**Venue Types for UNSPECIFIED FACTORY AND INDUSTRIAL (Group Value: 4)**

| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED FACTORY AND INDUSTRIAL              |
| 1                | FACTORY                                          |

**Venue Types for UNSPECIFIED INSTITUTIONAL (Group Value: 5)**

| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED INSTITUTIONAL                        |
| 1                | HOSPITAL                                         |
| 2                | LONG-TERM CARE FACILITY (E.G., NURSING HOME, HOSPICE, ETC.) |
| 3                | ALCOHOL AND DRUG RE-HABILITATION CENTER         |
| 4                | GROUP HOME                                       |
| 5                | PRISON OR JAIL                                   |

**Venue Types for UNSPECIFIED MERCANTILE (Group Value: 6)**

| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED MERCANTILE                          |
| 1                | RETAIL STORE                                     |
| 2                | GROCERY MARKET                                   |
| 3                | AUTOMOTIVE SERVICE STATION                       |
| 4                | SHOPPING MALL                                    |
| 5                | GAS STATION                                      |

**Venue Types for UNSPECIFIED RESIDENTIAL (Group Value: 7)**

| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED RESIDENTIAL                          |
| 1                | PRIVATE RESIDENCE                                |
| 2                | HOTEL OR MOTEL                                   |
| 3                | DORMITORY                                        |
| 4                | BOARDING HOUSE                                   |

**Venue Types for UNSPECIFIED STORAGE (Group Value: 8)**

| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED STORAGE                             |

**Venue Types for UNSPECIFIED UTILITY AND MISCELLANEOUS (Group Value: 9)**

| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED UTILITY AND MISCELLANEOUS            |

**Venue Types for UNSPECIFIED VEHICULAR (Group Value: 10)**

| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED VEHICULAR                           |
| 1                | AUTOMOBILE OR TRUCK                              |
| 2                | AIRPLANE                                         |
| 3                | BUS                                              |
| 4                | FERRY                                            |
| 5                | SHIP OR BOAT                                     |
| 6                | TRAIN                                            |
| 7                | MOTOR BIKE                                       |

**Venue Types for UNSPECIFIED OUTDOOR (Group Value: 11)**
| Venue Type Value | Venue Type Description                           |
|------------------|--------------------------------------------------|
| 0                | UNSPECIFIED OUTDOOR                             |
| 1                | MUNI-MESH NETWORK                               |
| 2                | CITY PARK                                        |
| 3                | REST AREA                                        |
| 4                | TRAFFIC CONTROL                                  |
| 5                | BUS STOP                                         |
| 6                | KIOSK                                            |

**Explanation**:

- Venue Information allows you to specify the group and type based on [IEEE Std 802.11u-2011, 7.3.1.34](https://ieeexplore.ieee.org/iel5/5721906/5721907/05721908.pdf).
- The 'Group' parameter represents a broader category, while 'Type' specifies the specific venue type within that group.


#### NETWORK_AUTH_TYPE, ROAMING_CONSORTIUM, NAI_REALM_ORION
- **Purpose**: Defines network authentication type, roaming consortium OI, and NAI realm for HS2.0.
- **Default Values**: `NETWORK_AUTH_TYPE=00`, `ROAMING_CONSORTIUM=f4f5e8f5f4`, `NAI_REALM_ORION=0,*.orion.area120.com,13[5:6],21[2:4][5:7],23[5:1][5:2],50[5:1][5:2],18[5:1][5:2]`
- **Examples**: `NETWORK_AUTH_TYPE=01`, `ROAMING_CONSORTIUM=abcdef1234`, `NAI_REALM_ORION=0,example.com`

##### NAI Realm Information

One or more realms can be advertised, with each `nai_realm` line adding a new realm to the set. These parameters provide information for stations using Interworking network selection to facilitate automatic connection to a network based on credentials.

> Format: `<Encoding>,<NAI Realm(s)>[,<EAP Method 1>][,<EAP Method 2>][,...]`

###### Encoding

Choose the encoding format for the realm. The following options are available:

| Realm Format | Description                                               |
|--------------|-----------------------------------------------------------|
| 0            | Realm formatted in accordance with IETF RFC 4282           |
| 1            | UTF-8 formatted character string not following RFC 4282  |

**NAI Realm(s): Semi-colon delimited NAI Realm(s)**

> EAP Method: `<EAP Method>[:<[AuthParam1:Val1]>][<[AuthParam2:Val2]>][...]`

For EAP Method types, refer to [AuthParam (Table 8-188 in IEEE Std 802.11-2012)](http://www.iana.org/assignments/eap-numbers/eap-numbers.xhtml#eap-numbers-4).

**ID 2 = Non-EAP Inner Authentication Type**

|  ID  |      Authentication Type     |
|:----:|:-----------------------------:|
|   1  |             PAP               |
|   2  |             CHAP              |
|   3  |            MSCHAP             |
|   4  |           MSCHAPV2            |

**ID 3 = Inner Authentication EAP Method Type**

*No specific values.*

**ID 5 = Credential Type**

|  ID  |         Credential Type          |
|:----:|:--------------------------------:|
|   1  |               SIM                |
|   2  |              USIM                |
|   3  | NFC Secure Element                |
|   4  |          Hardware Token          |
|   5  |            Softoken              |
|   6  |            Certificate           |
|   7  |      Username/Password           |
|   9  |            Anonymous              |
|  10  |       Vendor Specific             |

#### VENUE_NAME, VENUE_URL, DOMAIN_NAME
- **Purpose**: Provides venue information and domain name for HS2.0.
- **Default Values**: `VENUE_NAME=eng:Orion`, `VENUE_URL=1:https://orionwifi.com`, `DOMAIN_NAME=orion.area120.com`
- **Examples**: `VENUE_NAME=eng:MyVenue`, `VENUE_URL=1:https://example.com`, `DOMAIN_NAME=example.com`

#### ANQP_3GPP_CELL_NET, QOS_MAP_SET, HS20
- **Purpose**: Configures 3GPP cellular network information, QoS map set, and enables HS2.0.
- **Default Values**: `ANQP_3GPP_CELL_NET=310,150;310,280;310,410;313,100`, `QOS_MAP_SET` (not set), `HS20=1` (enabled)
- **Examples**: `ANQP_3GPP_CELL_NET=310,260`, `QOS_MAP_SET=0,7;8,15;16,31`, `HS20=0` (to disable HS2.0)

#### DISABLE_DGAF, OSEN
- **Purpose**: Controls Downstream Group-Addressed Forwarding (DGAF) blocking and OSEN protocol support.
- **Default Values**: `DISABLE_DGAF=1` (enabled), `OSEN=0` (disabled)
- **Examples**: `DISABLE_DGAF=0` (to disable), `OSEN=1` (to enable)

#### ANQP_DOMAIN_ID, HS20_DEAUTH_REQ_TIMEOUT, HS20_OPERATING_CLASS
- **Purpose**: Specifies ANQP Domain ID, deauthentication request timeout, and operating class for HS2.0.
- **Default Values**: `ANQP_DOMAIN_ID=0`, `HS20_DEAUTH_REQ_TIMEOUT=60`, `HS20_OPERATING_CLASS=5173`
- **Examples**: `ANQP_DOMAIN_ID=123`, `HS20_DEAUTH_REQ_TIMEOUT=30`, `HS20_OPERATING_CLASS=115`

#### HS20_OPER_FRIENDLY_NAME, OPERATOR_ICON
- **Purpose**: Configures Hotspot 2.0 operator friendly name and icon.
- **Default Values**: `HS20_OPER_FRIENDLY_NAME=eng:Orion`, `OPERATOR_ICON=64:64:eng:image/png:operator_icon:operator_icon.png`
- **Examples**: `HS20_OPER_FRIENDLY_NAME=eng:MyHotspot`, `OPERATOR_ICON=64:64:eng:image/png:my_icon.png`

#### NAS_IDENTIFIER
- **Purpose**: Specifies the Network Access Server (NAS) identifier sent in RADIUS messages, which can be useful for distinguishing between different access points or locations when communicating with a RADIUS server. **For Hotspot 2.0, this must be defined. It should be unique per network, not per location or AP.**
- **Default Value**: Not set explicitly; should be defined based on deployment needs.
- **Example**: `NAS_IDENTIFIER=ap1-location1`


## References
- [802.11 Operating Classes](https://mentor.ieee.org/802.11/dcn/10/11-10-0564-00-0s1g-operating-classes.ppt)
- [Android - Passpoint (Hotspot 2.0)](https://source.android.com/docs/core/connect/wifi-passpoint)
- [Apple Platform Deployment - Intro to mobile device management profiles](https://support.apple.com/guide/deployment/intro-to-mdm-profiles-depc0aadd3fe/1/web/1.0)
- [AuthParam (Table 8-188 in IEEE Std 802.11-2012)](http://www.iana.org/assignments/eap-numbers/eap-numbers.xhtml#eap-numbers-4)
- [Cambium Enterprise Wi-Fi and Google Orion Wi-Fi Deployment Guide](https://www.cambiumnetworks.com/wp-content/uploads/2020/10/Cambium-Enterprise-Wi-Fi-and-Google-Orion-Wi-Fi-Deployment-Guide.pdf)
- [Cisco - Chapter: Chapter 16 - Configuring Mobile Concierge -  Information About 802.11u](https://www.cisco.com/c/en/us/td/docs/wireless/controller/7-2/configuration/guide/cg/cg_hotspot_msap.html)
- [Configure Juniper Mist Cloud](https://www.mist.com/wp-content/uploads/Example-Configure-Hotspot-2.0-with-Orion-WiFi.pdf)
- [Configure RUCKUS wireless LAN controller 5](https://docs.google.com/document/d/e/2PACX-1vRh81adM12GG7lY3vauxEd-rID4A6xbc91mzurin8bGVW9L80XqRnRBgTYOJ75CHwOGl-8v-o6OByrP/pub)
- [Configure Wi-Fi APs for Orion](https://support.google.com/orion-wifi/answer/14528189?hl=en&ref_topic=12673678&sjid=4937468210388342306-NA)
- [Configuring Hotspot 2.0 (Passpoint) on OpenWrt](https://hgot07.hatenablog.com/entry/2022/03/21/231715)
- [EAP Method Types](https://www.iana.org/assignments/eap-numbers/eap-numbers.xhtml#eap-numbers-4)
- [Freeradius](https://wiki.freeradius.org/guide/Getting-Started)
- [GL-iNet](https://www.gl-inet.com/)
- [HotSpot 2.0 MDM settings for Apple devices](https://support.apple.com/guide/deployment/hotspot-20-settings-depea26c29b9/web)
- [IEEE 802.11-2016](https://standards.ieee.org/ieee/802.11/5536/)
- [IEEE 802.11-2020](https://standards.ieee.org/ieee/802.11/7028/)
- [IEEE 802.11u Standard](https://www.ieee.org/)
- [IEEE 802.11u](https://en.wikipedia.org/wiki/IEEE_802.11u)
- [ISO639-2 Language Codes](http://www.loc.gov/standards/iso639-2/php/code_list.php)
- [Infographic - Wi-Fi CERTIFIED Passpoint®](https://www.wi-fi.org/file/infographic-wi-fi-certified-passpoint)
- [MikroTik - Configuration guide using native RadSec and Orion Wifi](https://help.mikrotik.com/docs/display/ROS/Interworking+Profiles#InterworkingProfiles-ConfigurationguideusingnativeRadSecandOrionWifi:)
- [Mobile Country Code (MCC) and Mobile Network Code (MNC)](https://www.itu.int/en/ITU-T/inr/nnp/Pages/mcc-mnc.aspx)
- [Mobile Country Codes (MCC) and Mobile Network Codes (MNC)](https://www.mcc-mnc.com/)
- [OpenWRT Documentation](https://openwrt.org/)
- [OpenWrt - Passpoint configuration](https://www.ironwifi.com/help/openwrt-passpoint)
- [Orion - Ubiquiti UniFi Deployment Guide](https://support.google.com/orion-wifi/answer/12759869)
- [Passpoint Certification](https://www.wi-fi.org/discover-wi-fi/wi-fi-certified-passpoint)
- [RFC 7542](https://datatracker.ietf.org/doc/html/rfc7542)
- [T-MOBILE WI-FI PASSPOINT](https://howmobileworks.com/wp-content/uploads/2021/06/T-Mobile-Passpoint-Indoor-Coverage-Solution-Tech-Overview-012621.pdf)
- [T-Mobile A GUIDE TO BUILDING YOUR OWN COVERAGE](https://howmobileworks.com/wp-content/uploads/2020/11/tmo-byoc-acs-brochure-110520-spreads.pdf)
- [T-Mobile Smart Buildings Plan for Wireless (BYOC STEP-BY-STEP)](https://howmobileworks.com/wp-content/uploads/2020/11/tmo-byoc-one-pager-103020.pdf)
- [Testing eith eapol_test](https://wiki.geant.org/display/H2eduroam/Testing+with+eapol_test)
- [The Benefits of In-Building Cellular Coverage](https://howmobileworks.com/wp-content/uploads/2020/11/tmo-byoc-infographic-updated-logo-only-110520.pdf)
- [Troubleshooting EAP-TLS with freeradius](https://blog.rchapman.org/posts/Troubleshooting_EAP-TLS_with_freeradius/)
- [WBA OpenRoaming™ Roaming Consortium Organization Identifiers (RCOI)](https://wireless-broadband-alliance.github.io/OR-rcoi-config/#)
- [WBA specification for PPS-MO extensions](https://wballiance.com/resource/wba-pps-mo-extensions/)
- [Wi-Fi Alliance (WFA) - PassPoint](https://www.wi-fi.org/discover-wi-fi/passpoint)
- [Wi-Fi Alliance (WFA)](https://www.wi-fi.org/)
- [Wi-Fi CERTIFIED Passpoint® Deployment Guidelines](https://www.wi-fi.org/file/wi-fi-certified-passpoint-deployment-guidelines)
- [Wi-Fi CERTIFIED Passpoint® Technology Overview (2019)](https://www.wi-fi.org/file/wi-fi-certified-passpoint-technology-overview-2019)
- [Wikipedia - Wi-Fi hotspot](https://en.wikipedia.org/wiki/Wi-Fi_hotspot)
- [Windows - Passpoint](https://learn.microsoft.com/en-us/windows-hardware/drivers/mobilebroadband/passpoint)
- [Wireless LAN Medium Access Control (MAC) and Physical Layer (PHY) Specifications](https://ieeexplore.ieee.org/iel5/6361246/6361247/06361248.pdf)
- [[Orion 2022 Guide] ArubaOS Initial Setup](https://docs.google.com/document/u/0/d/e/2PACX-1vSiHM7Rof4YaX2h5NheiD4RWDnw376BFedgnGJmk_rhgctreFDv3vvFRR3sem45pUGJ3TBiAh7r2qh0/pub?pli=1)
- [[Orion 2022 Guide] Cisco 9800 Initial Setup](https://docs.google.com/document/d/e/2PACX-1vRVlZKhmzivG8kJI2PSSTrQGN6CLGym1DkFzEYsF8Y6PfhklDQF7Sp_hdRYFtoh20vf-k9eAATiM7tz/pub)
- [[Orion 2022 Guide] FortiGate Initial Setup](https://docs.google.com/document/u/1/d/e/2PACX-1vTFGddllsSXmXfbmNlJ2MP8TciMqqBKbOKXDSqYLc9qxm3iPELX_kbpkDtkwJpK2kdQi_lztd6l2Ue8/pub)
- [[Orion 2022 Guide] Meraki Hotspot 2.0 Initial Setup](https://docs.google.com/document/d/e/2PACX-1vQTTIC6OKwvURbqyO29ZK6pgofAe1D-AsnNodyrnFnxZmY8h4Ln_SbLRoH0xzQKG1kNcpzT3eNstehQ/pub)
- [aosp/718508](https://android-review.googlesource.com/c/platform/frameworks/opt/net/wifi/+/718508)
- [geant.org - OpenRoaming ANPs](https://wiki.geant.org/pages/viewpage.action?pageId=133763844)
- [google-area120/orion-radsec](https://github.com/google-area120/orion-radsec)
- [hostap default config](https://w1.fi/cgit/hostap/plain/hostapd/hostapd.conf)
- [morrownr/USB-WiFi](https://github.com/morrownr/USB-WiFi)
- [simeononsecurity/orion-radsec](https://github.com/simeononsecurity/orion-radsec/tree/sos-dev)