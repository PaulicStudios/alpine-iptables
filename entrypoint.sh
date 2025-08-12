#!/usr/bin/env sh
set -euo pipefail

# Switch iptables backend if requested
if [ "${IPTABLES_BACKEND:-nft}" = "legacy" ]; then
  if command -v update-alternatives >/dev/null 2>&1; then
    # Use legacy userspace
    update-alternatives --set iptables /sbin/iptables-legacy || true
    update-alternatives --set ip6tables /sbin/ip6tables-legacy || true
  fi
else
  if command -v update-alternatives >/dev/null 2>&1; then
    # Ensure nft is active
    update-alternatives --set iptables /sbin/iptables-nft || true
    update-alternatives --set ip6tables /sbin/ip6tables-nft || true
  fi
fi

exec "$@"


