## alpine-iptables

Minimal Alpine-based Docker image with iptables preinstalled, published to the GitHub Container Registry (GHCR) for amd64 and arm64.

Inspired by the approach in `alpine-docker/git` for a clean, multi-arch Alpine container and automated publishing workflow ([alpine-docker/git on GitHub](https://github.com/alpine-docker/git)).

### Features

- **Alpine base**: small, fast image
- **iptables and ip6tables** preinstalled
- **Optional legacy backend**: switch to legacy via `IPTABLES_BACKEND=legacy`
- **Multi-arch**: `linux/amd64` and `linux/arm64`
- **Automated builds**: on push, manual dispatch, and monthly schedule
- **Auto-versioned tags**: `latest`, `vYYYY.MM`, and `sha-<shortsha>`

### Image

- **GHCR**: `ghcr.io/paulicstudios/alpine-iptables`

After pushing this repo to GitHub, the GitHub Actions workflow will publish images automatically.

### Usage

Most iptables operations require additional Linux capabilities. If you're testing rules inside a container, you likely need at least `NET_ADMIN` and `NET_RAW`. For manipulating host firewall, you typically need `--privileged` or to run inside a Kubernetes DaemonSet with appropriate privileges.

Basic examples:

```bash
# Print iptables version (default CMD)
docker run --rm ghcr.io/paulicstudios/alpine-iptables

# List filter rules (IPv4)
docker run --rm --cap-add NET_ADMIN --cap-add NET_RAW \
  ghcr.io/paulicstudios/alpine-iptables iptables -L -n -v

# List filter rules (IPv6)
docker run --rm --cap-add NET_ADMIN --cap-add NET_RAW \
  ghcr.io/paulicstudios/alpine-iptables ip6tables -L -n -v

# Save rules
docker run --rm --cap-add NET_ADMIN --cap-add NET_RAW \
  ghcr.io/paulicstudios/alpine-iptables iptables-save

# Use legacy backend (if your environment requires it)
docker run --rm --cap-add NET_ADMIN --cap-add NET_RAW \
  -e IPTABLES_BACKEND=legacy \
  ghcr.io/paulicstudios/alpine-iptables iptables -V

# Drop into a shell (override entrypoint)
docker run --rm -it --entrypoint sh ghcr.io/paulicstudios/alpine-iptables
```

Notes:

- Backend selection (`nft` vs `legacy`) is set on container start via `update-alternatives`. Default is `nft`.
- Actual capabilities required depend on your host and what you need to do with iptables.

### Local build

```bash
docker build -t alpine-iptables:dev .
docker run --rm alpine-iptables:dev
```

### How versioning works

The workflow publishes tags:

- `latest`
- `vYYYY.MM` (e.g., `v2025.08`)
- `sha-<shortsha>`

The monthly scheduled workflow refreshes the image and automatically advances the `vYYYY.MM` tag.

### Credits

This repository takes inspiration from the multi-arch automation pattern used in `alpine-docker/git` ([GitHub repo](https://github.com/alpine-docker/git)).

 


