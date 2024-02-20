# First stage: Build environment
FROM ubuntu:latest as builder

# Set labels for intermediate builder stage
LABEL stage=builder

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && \
    apt-get install -fy build-essential git pkg-config libnl-3-dev libnl-genl-3-dev libssl-dev libreadline-dev libdbus-1-dev && \
    git clone git://git.launchpad.net/ubuntu/+source/wpa /wpa && \

WORKDIR /wpa

COPY hostapd-build.conf .config

# Second stage: Production environment
FROM ubuntu:latest

# Set Labels
LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/linux-hostapd-hs20-dhcpd"
LABEL org.opencontainers.image.description="Docker container for hostapd and dhcpd with hotspot 2.0 support on linux"
LABEL org.opencontainers.image.authors="simeononsecurity"

# Set ENV Variables
ENV container docker

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies and clean up in a single RUN command to reduce image size
RUN apt-get update && \
    apt-get install -y bash iptables isc-dhcp-server iproute2 && \
    echo "" > /var/lib/dhcp/dhcpd.leases && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the hostapd binary from the build stage
COPY --from=builder /wpa/hostapd/hostapd /usr/local/bin/hostapd
COPY --from=builder /wpa/hostapd/hostapd_cli /usr/local/bin/hostapd_cli

# Add the startup and health check scripts, then make them executable
COPY docker-init.sh /bin/docker-init.sh
COPY healthcheck.sh /bin/healthcheck.sh
RUN chmod +x /bin/docker-init.sh /bin/healthcheck.sh

# Specify the entrypoint and health check scripts
ENTRYPOINT ["/bin/bash", "/bin/docker-init.sh"]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD ["/bin/healthcheck.sh"]