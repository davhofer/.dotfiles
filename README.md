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

`cd` into the .dotfiles directory and run `stow` as follows
```bash
cd .dotfiles 
stow .
```
This will symlink all files in the .dotfiles directory to the equivalent locations in your home directory.

**IMPORTANT**: don't run `stow .dotfiles` from your home directory (e.g. `/home/<user>/`)! This will set up the symlinks in `/home`.


