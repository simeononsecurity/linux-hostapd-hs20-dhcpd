# Define Ubuntu Base
FROM ubuntu:latest

# Set Labels
LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/linux-hostapd-hs20-dhcpd"
LABEL org.opencontainers.image.description="Docker container for hostapd and dhcpd with hotspot 2.0 support on linux"
LABEL org.opencontainers.image.authors="simeononsecurity"

# Set ENV Variables
ENV container docker

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Combine RUN commands to reduce layers. Use apt-get to install packages in Ubuntu.
RUN apt-get update && \
    apt-get install -y bash hostapd iptables isc-dhcp-server iproute2 && \
    echo "" > /var/lib/dhcp/dhcpd.leases && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add the startup script
COPY docker-init.sh /bin/docker-init.sh
RUN chmod +x /bin/docker-init.sh

# Health check script
COPY healthcheck.sh /bin/healthcheck.sh
RUN chmod +x /bin/healthcheck.sh

# Specify the entrypoint script using /bin/bash
ENTRYPOINT ["/bin/bash", "/bin/docker-init.sh"]

# Healthcheck instruction
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
CMD ["/bin/healthcheck.sh"]
