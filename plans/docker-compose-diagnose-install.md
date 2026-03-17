# ExecPlan: Diagnose Missing Docker Compose Plugin And Add Install Scripts

## Checklist

- [x] Inspect repo conventions and existing script patterns.
- [x] Reproduce the Docker Compose failure on this machine.
- [x] Capture the current Docker and Compose installation state.
- [x] Add a diagnostic script that reports the root cause and next steps.
- [x] Fix the doctor script after a user-reported false positive.
- [x] Add an install script for the Compose v2 plugin on Debian/Ubuntu systems.
- [x] Fix the installer script after a user-reported apt-package dead end.
- [x] Add a short doc describing the observed failure and script usage.
- [x] Review the new files for correctness and scope.

## Assumptions

- The user wants checked-in scripts in this repo, not only inline shell commands.
- The target machine is the current Ubuntu/Debian environment where the failure was observed.
- The install script should add Compose v2 and leave legacy `docker-compose` alone unless the user chooses to remove it separately.

## Review Notes

- Reproduced the current failure before editing:
  - `docker --version` -> `Docker version 27.5.1, build 27.5.1-0ubuntu3~24.04.2`
  - `docker compose version` -> `docker: 'compose' is not a docker command.`
  - `docker-compose --version` -> `docker-compose version 1.29.2, build unknown`
  - `docker info --format '{{json .ClientInfo}}'` showed `Plugins: []`
- Root cause on this machine: Docker CLI is installed, but the Compose v2 CLI plugin is missing, so `docker compose` is unavailable even though legacy `docker-compose` v1 is present.
- After the first version of the doctor script, the user provided an executable reproducer showing a false positive. The script was rewritten to treat the known missing-plugin message as failure even if the command status is misleading.
- After the first version of the install script, the user provided an executable reproducer showing that neither `docker-compose-v2` nor `docker-compose-plugin` was available from the current apt sources. The script was rewritten to fall back to Docker's standard manual CLI plugin install in `~/.docker/cli-plugins`.
- Further shell verification remained limited by the restricted sandbox, so follow-up validation should be done by rerunning the installer and doctor scripts locally.
