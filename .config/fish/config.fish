# PATH configuration - adds directories to the front of $PATH
# fish_add_path automatically handles duplicates and prepends to PATH
fish_add_path /home/david/zig-0.13.0
fish_add_path /home/david/.local/bin
fish_add_path /home/david/texlive/2024/bin/x86_64-linux
fish_add_path /home/david/go/bin
fish_add_path /home/david/.cargo/bin

# Environment variables
# -Ux flag makes variables universal and exported (persistent across sessions)
set -Ux XDG_CONFIG_HOME "/home/david/.config/"
set -Ux EDITOR "nvim"
set -Ux ANDROID_HOME "/home/david/Android/Sdk/"
set -Ux VIRTUAL_ENV_DISABLE_PROMPT 1

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# direnv
direnv hook fish | source

# starship prompt
starship init fish | source

# brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# zoxide
zoxide init fish --cmd cd | source
