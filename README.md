# config_files
Dotfiles and other configuration files.

## Usage
### Dotfiles
#### Deploy all config files
```sh
make deploy_all
```

#### Remove all config files
```sh
make remove_all
```

#### Deploy specific config files
```sh
make deploy-<name>
```

#### Remove specific config files
```sh
make remove-<name>
```

### Issue
```sh
cd issue
make <distro>
```

Currently the following distros are supported:
* Arch
* Ubuntu

## Examples:
`make deploy-git` deploys all of git's config files

`make remove-git` removes all of git's config files

`cd issue && make arch` deploys the issue file for Arch Linux.
