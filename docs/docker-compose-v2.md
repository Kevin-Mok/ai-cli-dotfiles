# Docker Compose V2 On This Machine

## Observed Failure

The current machine has Docker installed, but `docker compose` fails because the Compose v2 CLI plugin is missing.

Observed state during diagnosis:

- `docker --version` reported Docker `27.5.1`
- `docker compose version` returned `docker: 'compose' is not a docker command.`
- `docker-compose --version` returned legacy Compose `1.29.2`
- `docker info --format '{{json .ClientInfo}}'` showed no client plugins

That means the Docker CLI is present, but only the old standalone `docker-compose` binary is installed. The newer `docker compose` subcommand requires a separate Compose v2 plugin.

## Scripts Added

- `scripts/executable_docker-compose-doctor.sh`
  - Diagnoses the local Docker and Compose state
  - Treats the known missing-plugin message as failure even if the command status is misleading
  - Suggests the install script when the failure matches this machine

- `scripts/executable_install-docker-compose-v2.sh`
  - Tries the distro apt package first when one is available
  - Falls back to Docker's official manual CLI plugin install under `~/.docker/cli-plugins`
  - Supports overriding the release with `COMPOSE_VERSION=vX.Y.Z`
  - Leaves legacy `docker-compose` untouched

## Why The First Installer Failed

On this machine, neither `docker-compose-v2` nor `docker-compose-plugin` is available from the currently configured apt sources. That can happen when Docker comes from the distro package set instead of Docker's upstream apt repository.

The installer now handles that case by downloading the Compose plugin binary into the standard per-user Docker CLI plugin directory.

## Usage

Run the doctor:

```bash
bash scripts/executable_docker-compose-doctor.sh
```

Install Compose v2:

```bash
bash scripts/executable_install-docker-compose-v2.sh
```

Pin a specific Compose release if needed:

```bash
COMPOSE_VERSION=vX.Y.Z bash scripts/executable_install-docker-compose-v2.sh
```

Verify after installation:

```bash
docker compose version
```
