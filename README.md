---

# About

Linter verified software

[![GitHub Super-Linter](https://github.com/mdrocan/shell-scripts/workflows/CI-check/badge.svg)](https://github.com/marketplace/actions/super-linter)

Helper scripts for various cases.

- Developed, tested and used in macOS environment.
- Additional packages used in the scripts have been mostly \
installed with Homebrew.

## Script details

Short descriptions of the scripts.

```sh
brew_check.sh
```
- Checks and lists available Homebrew updates.
- Option to install updates to the installed formulae and applications.
- Note: The scripts does not verify and fix possible linking warnings - by purpose. Thus, you might occasionally see messages like: "Warning: You have unlinked kegs in your Cellar."

```sh
calculate_docker_images.sh
```
- Calculate the used quota from saved Docker images.

```sh
charging_level.sh
```
- Notification about decreased battery charging level. Current check value \
set to 30%, using it through crontab scheduling. If you set the Script \
Editor notification settings from Banners to Alerts the messages stay \
visible until you close the notification.

```sh
connect_to_container.sh CONTAINER_ID
```
- Open a terminal connection to a running Docker container.

```sh
encode_changer.sh
```
- Change few umlauts to nicer HTML encoding.

```sh
network.sh
```
- Reset wireless network and display IP address etc.

```sh
pip_check.sh
```
- Display package information of the installed Pip packages.
- Update pip3 packages and pip itself in a straightforward way.

```sh
stop_all_containers.sh
```
- List all running containers. Option to stop them.

```sh
syntaxchecker.sh
```
- Syntax checker using Shellcheck to verify all shellscripts from the current\
 directory or a directory given as an argument.

```sh
wifi_strength.sh
```
- Display wireless network's strenght signal, SSID and the channel in use.
- Looping by default 10 test rounds.

### Author

Designed by Mikko Drocan.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE)\
 file for details.
