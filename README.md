# Few helper scripts

### About

Developed and used in OS X environment. Extra packages installed mostly by Homebrew.

### The stuff

- Check for Brew updates. Possibility to install all updates for the installed brews and casks.
```
brew_check.sh
```

- Update pip2/pip3 packages in a straightforward way.
```
update_pip_packages.sh
```

- Reset Wi-Fi network and display IP address etc. Some basic functionality still on its way.
```
network.sh
```

- Terminal connection to a running Docker container.
```
connect_to_container.sh CONTAINER_ID
```

- Encode changer from äöå to nicer HTML encoding.
```
encode_changer.sh
```

- Display all running containers. Possility to stop them all.
```
stop_all_containers.sh
```

- Calculate the quota of used Docker images.
```
calculate_docker_images.sh
```

- Syntax checker using Shellcheck to verify bash/sh scripts. Analyzes current directory's files ending with ".sh" file extension.
```
syntaxchecker.sh
```

- Display wireless strenght signal, used SSID and the channel in use.
```
osx_wifi_strength.sh
```

## Author

Designed by Mikko Drocan.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.