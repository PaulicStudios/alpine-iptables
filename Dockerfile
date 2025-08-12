FROM alpine:latest

LABEL org.opencontainers.image.title="alpine-iptables" \
      org.opencontainers.image.description="Minimal Alpine image with iptables and ip6tables" \
      org.opencontainers.image.source="https://github.com/paulicstudios/alpine-iptables"

# Install iptables (nft userspace by default in Alpine) and common tools
RUN --mount=type=cache,target=/var/cache/apk \
    apk add --no-cache \
      iptables \
      ip6tables \
      iptables-legacy \
      ca-certificates && \
    update-ca-certificates

# Optional switch between nft and legacy on container start
ENV IPTABLES_BACKEND=nft

# Entrypoint script selects backend on boot then execs cmd
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["iptables", "--version"]


