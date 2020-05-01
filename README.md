### About

Developed, tested and used in OS X environment. Extra packages have been mostly installed using Homebrew.

### The stuff

- Checks and lists available Homebrew updates. An option to install all available updates for the installed brews and casks.
```
brew_check.sh
```

- Update pip3 packages and pip itself in a straightforward way.  
Python and pip installed as by the information shared by Homebrew: https://docs.brew.sh/Homebrew-and-Python
One note (differing from the previous link): The commands installing at first place Pip and Setuptools executed by command: python3
```
update_pip_packages.sh
```
- Display package information of the installed Pip packages.
```
info_pip_packages.sh
```

- Reset wireless network and display IP address etc.
```
network.sh
```

- Open a terminal connection to a running Docker container.
```
connect_to_container.sh CONTAINER_ID
```

- Change couple umlauts to nicer HTML encoding.
```
encode_changer.sh
```

- List all running containers. Option to stop them.
```
stop_all_containers.sh
```

- Calculate the used quota from saved Docker images.
```
calculate_docker_images.sh
```

- Syntax checker using Shellcheck to verify all bash/sh scripts (*.sh) from the current directory or a directory given as an argument.
```
syntaxchecker.sh
```

- Display wireless network's strenght signal, SSID and the channel in use.
```
osx_wifi_strength.sh
```

## Author

Designed by Mikko Drocan.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.