### About

Developed, tested and used in macOS environment.
- Extra packages in use have been mostly installed with Homebrew.

### The stuff

- Checks and lists available Homebrew updates.
- Option to install updates to the installed formulae and applications.
The scripts does not verify and fix possible linking warnings - by purpose. Thus, you might occasionally see messages like: "Warning: You have unlinked kegs in your Cellar."
```
brew_check.sh
```

- Display package information of the installed Pip packages.
- Update pip3 packages and pip itself in a straightforward way.
```
pip_check.sh
```

- Reset wireless network and display IP address etc.
```
network.sh
```

- Display wireless network's strenght signal, SSID and the channel in use.
```
osx_wifi_strength.sh
```

- Open a terminal connection to a running Docker container.
```
connect_to_container.sh CONTAINER_ID
```

- List all running containers. Option to stop them.
```
stop_all_containers.sh
```

- Calculate the used quota from saved Docker images.
```
calculate_docker_images.sh
```

- Change couple umlauts to nicer HTML encoding.
```
encode_changer.sh
```

- Syntax checker using Shellcheck to verify all bash/sh scripts (*.sh) from the current directory or a directory given as an argument.
```
syntaxchecker.sh
```

- Notification about decreased battery charging level. Current check value set to 30%, using it through crontab schedule on hourly basis.
```
charging_level.sh
```

## Author

Designed by Mikko Drocan.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.