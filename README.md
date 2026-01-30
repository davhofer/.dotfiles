# .dotfiles

## Installation

First, install the GNU Stow utility on your system, e.g. using 
```bash
sudo apt install stow
```

While being in your home directory, clone this repository
```bash 
cd
git clone https://github.com/davhofer/.dotfiles.git
```

`cd` into the .dotfiles directory and run `stow` as follows in order to stow the config for a specific tool
```bash
cd .dotfiles 
stow <tool>
```
This will symlink the .dotfiles subdirectory to the correct location in your home directory (`.config/<tool>/`)

**IMPORTANT**: don't run `stow .dotfiles` from your home directory (e.g. `/home/<user>/`)! 
