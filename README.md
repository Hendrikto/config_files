# config_files
Dotfiles and other confiugration files.

## Usage
### Dotfiles
#### Deploy all config files
```sh
make all
```

#### Remove all config files
```sh
make remove_all
```

#### Deploy specific config files
```sh
make <name>
```

#### Remove specific config files
```sh
make remove_<name>
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
`make git` deploys all of git's config files

`make remove_git` removes all of git's config files

`cd issue && make arch` deploys the issue file for Arch Linux.
