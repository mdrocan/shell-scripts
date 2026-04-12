# Shell Scripts (macOS)

[![MegaLinter](https://github.com/mdrocan/shell-scripts/workflows/MegaLinter/badge.svg?branch=master)](https://github.com/mdrocan/shell-scripts/actions?query=workflow%3AMegaLinter+branch%3Amaster)

Practical command-line helpers used on macOS development machines.

## Quick Start

```sh
chmod +x ./*.sh
./syntaxchecker.sh
./brew_check.sh --help
./docker_tools.sh --help
./wifi_tools.sh --help
./pip_check.sh --help
```

Use `--help` first on each script to verify expected behavior in your environment.

## Design

- Keep tools small, composable, and script-friendly.
- Prefer one script per domain (package management, Docker, networking, linting).
- Use subcommands where workflows naturally belong together.

## Requirements

- macOS
- `sh` (POSIX shell)
- Homebrew (for `brew_check.sh`)
- Docker CLI + daemon running (for `docker_tools.sh`)
- `shellcheck` (for `syntaxchecker.sh`)

## Scripts

| Script             | Main use                                | Side effects                                 | Depends on                         |
|--------------------|-----------------------------------------|----------------------------------------------|------------------------------------|
| `brew_check.sh`    | Check/install Homebrew updates          | May install/update packages; may clean cache | Homebrew                           |
| `docker_tools.sh`  | List/connect/stop running containers    | `stop` can stop all running containers       | Docker daemon + CLI                |
| `wifi_tools.sh`    | Inspect and manage Wi-Fi connection     | `reset` toggles Wi-Fi interface, uses sudo   | macOS networksetup/system_profiler |
| `pip_check.sh`     | Check/update packages in activated venv | `-i` updates `pip` and outdated packages     | Python venv (activated)            |
| `syntaxchecker.sh` | Lint shell scripts                      | None                                         | shellcheck                         |

### `brew_check.sh`

Check and manage Homebrew updates.

- Checks outdated formulae and casks.
- Can install updates.
- Can clean the Homebrew cache.

Options:

- `[none]`: Check for available updates
- `-i, --install`: Install available updates
- `-clean`: Clean Homebrew cache
- `-h, --help`: Show help message

Examples:

```sh
./brew_check.sh              # Check for updates
./brew_check.sh -i           # Install updates
./brew_check.sh -clean       # Clean cache
./brew_check.sh -h           # Show help
```

### `docker_tools.sh`

Docker workflow helper for everyday container operations.

Subcommands:

- `list`: list running containers
- `connect <id>`: open root shell in a running container
- `stop [-y]`: stop all running containers (`-y` skips confirmation)

Examples:

```sh
./docker_tools.sh list
./docker_tools.sh connect <container_id>
./docker_tools.sh stop
./docker_tools.sh stop -y
```

### `wifi_tools.sh`

Wi-Fi inspection and management tool.

Subcommands:

- no args: show current Wi-Fi signal
- `signal`: show Wi-Fi signal metrics (channel, dBm, noise, SNR, Tx rate)
- `signal <n>`: repeat signal check `n` times (3s interval)
- `list`: list previously-connected Wi-Fi networks (preferred networks on `en0`)
- `reset`: restart Wi-Fi adapter

Examples:

```sh
./wifi_tools.sh                # Show current Wi-Fi signal
./wifi_tools.sh signal         # Show signal metrics
./wifi_tools.sh signal 10      # Repeat 10 times
./wifi_tools.sh list           # List known networks
./wifi_tools.sh reset          # Reset Wi-Fi adapter
```

Note: on recent macOS versions, scanning nearby SSIDs via system tools may be redacted. The `list` command intentionally shows preferred (previously connected) networks for reliable output.

## Operational Notes

- Scripts are intended for interactive terminal usage, not unattended automation.
- `docker_tools.sh stop` prompts by default; use `-y` only when you want non-interactive behavior.
- `wifi_tools.sh reset` requires `sudo` and will temporarily interrupt network connectivity.
- `pip_check.sh` requires an activated Python virtual environment (`source venv/bin/activate`).
- `syntaxchecker.sh` scans recursively from the provided path.

### `pip_check.sh`

Manage pip packages in an activated virtual environment.

- Checks for outdated packages in the venv.
- Can update `pip` and installed Python packages.
- Can list all installed package metadata.

Options:

- `[none]`: Check for available updates
- `-i, --install`: Install available updates
- `-l, --list`: List all installed packages
- `-h, --help`: Show help message

Examples:

```sh
source myproject/venv/bin/activate
./pip_check.sh              # Check for updates
./pip_check.sh -i           # Install updates
./pip_check.sh -l           # List installed packages
./pip_check.sh -h           # Show help
```

### `syntaxchecker.sh`

Run `shellcheck` on `.sh` files.

Arguments:

- `[none]`: Lint all `.sh` files in the current directory
- `PATH`: Lint all `.sh` files under the given path
- `-h, --help`: Show help message

Examples:

```sh
./syntaxchecker.sh             # Lint current directory
./syntaxchecker.sh /some/path  # Lint a specific path
./syntaxchecker.sh -h          # Show help
```

## Legacy Notes

The following scripts were merged into newer tools:

- `connect_to_container.sh` + `stop_all_containers.sh` -> `docker_tools.sh`
- `network.sh` + `wifi_strength.sh` -> `network_tools.sh` -> `wifi_tools.sh`

## Author

Designed by Mikko Drocan.

## License

MIT. See [LICENSE](LICENSE).
