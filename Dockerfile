# Define Alpine Base
FROM alpine:latest

# Set Labels
LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/linux-hostapd-hs20-dhcpd"
LABEL org.opencontainers.image.description="Docker container for hostapd and dhcpd with hotspot 2.0 support on linux"
LABEL org.opencontainers.image.authors="simeononsecurity"

# Set ENV Variables
ENV container docker

# Combine RUN commands to reduce layers and clear cache in the same layer to minimize image size
RUN apk update && \
    apk add bash hostapd iptables dhcp && \
    echo "" > /var/lib/dhcp/dhcpd.leases && \
    rm -rf /var/cache/apk/*

# Add the startup script
ADD docker-init.sh /bin/docker-init.sh

# Specify the entrypoint script
ENTRYPOINT ["/bin/docker-init.sh"]
