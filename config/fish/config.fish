fish_add_path /opt/homebrew/bin
#pycharm
# fish_add_path "/Applications/PyCharm.app/Contents/MacOS"
fish_add_path "/opt/homebrew/opt/node@22/bin"
fish_add_path "$HOME/Library/Application Support/reflex/bun/bin"
fish_add_path "/Users/nkapila6/.lmstudio/bin"
fish_add_path /usr/local/bin
fish_add_path $HOME/.emacs.d/bin
fish_add_path $HOME/go/bin/
fish_add_path "~/.config/v-analyzer/bin/"

# tools
zoxide init fish | source
direnv hook fish | source
source "$HOME/.cargo/env.fish"

set -g fish_key_bindings fish_vi_key_bindings

if status is-interactive
    # Commands to run in interactive sessions can go here
    # starship init fish | source
end

# aliases
alias arm "env /usr/bin/arch -arm64 /bin/zsh --login"
alias intel "env /usr/bin/arch -x86_64 /bin/zsh --login"
alias ms "switchaudiosource -s 'MacBook Pro Speakers'"
alias pas "switchaudiosource -s 'Proxy Audio Device'"
alias lg lazygit
# alias f fuck
alias n nvim
alias c cd
alias an "NVIM_APPNAME=astrovim nvim"
alias nn "NVIM_APPNAME=nvchad nvim"
alias ls lsd

function nv
    neovide $argv &
end

function anv
    env NVIM_APPNAME=astrovim neovide --frame buttonless $argv &
end

function nnv
    env NVIM_APPNAME=nvchad neovide --frame buttonless $argv &
end

# thefuck
function fuck -d "Correct your previous console command"
    set -l fucked_up_command $history[1]
    env TF_SHELL=fish TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $fucked_up_command THEFUCK_ARGUMENT_PLACEHOLDER $argv | read -l unfucked_command
    if [ "$unfucked_command" != "" ]
        eval $unfucked_command
        builtin history delete --exact --case-sensitive -- $fucked_up_command
        builtin history merge
    end
end
alias saar fuck

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

set theme_color_scheme gruvbox
set -g fish_prompt_pwd_dir_length 0
set -g theme_powerline_fonts
set -g theme_nerd_fonts yes
set -g theme_newline_cursor yes

# uv
fish_add_path "/Users/nkapila6/.local/bin"

# gpg
export GPG_TTY=$(tty)

# startship
starship init fish | source

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish
