# Linux Deployment Toolbox

A framework and policy built using `bash` (`sh` compatible) shell scripts that allows mass deployment of a system configuration to all machines within an organisation.

**Currently supported operations are:**

- Installing from default repsitories
- Adding new repositories
- Installing software from source (using GNU-Stow to place it under the normal `/usr/local` directory heirarchy)
- Installing NPM modules (either using `nvm` or vanilla `nodejs`)
- Installing Python packages
- Installing Ruby gems
- Installing dotfiles (provided that your dotfiles include an `install.sh` script)
- Installing fonts
- Purging and uninstalling packages already present
- Configuring any arbitrary software using a custom shell script

**Planned features:**

- Importing the `dconf` settings
- Importing GNOME Shell settings from `gsettings`
- Configuring popular software according to simple rules

