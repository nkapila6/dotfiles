fish_add_path /opt/homebrew/bin
#pycharm
# fish_add_path "/Applications/PyCharm.app/Contents/MacOS"
fish_add_path "/opt/homebrew/opt/node@22/bin"
fish_add_path "$HOME/Library/Application Support/reflex/bun/bin"
fish_add_path "/Users/nkapila6/.lmstudio/bin"
fish_add_path /usr/local/bin

# tools
zoxide init fish | source
direnv hook fish | source
source "$HOME/.cargo/env.fish"
#source ~/.orbstack/shell/init.fish
# atuin init fish | sourc

set -g fish_key_bindings fish_vi_key_bindings

if status is-interactive
    # Commands to run in interactive sessions can go here
    # starship init fish | source
end

# aliases
alias arm "env /usr/bin/arch -arm64 /bin/zsh --login"
alias intel "env /usr/bin/arch -x86_64 /bin/zsh --login"
alias l "eza --color=always --long --git --icons=always --no-user --no-permissions --header --group-directories-first"
alias e eza
alias gios-o "ssh -i ~/.ssh/m1pro.pem nkapila6@20.174.16.88"
alias gios "az vm start --resource-group gios_group --name gios"
alias gios-s "az vm deallocate --resource-group gios_group --name gios"
alias ms "switchaudiosource -s 'MacBook Pro Speakers'"
alias pas "switchaudiosource -s 'Proxy Audio Device'"
alias saar fuck
alias lg lazygit
# alias f fuck
alias n nvim
alias an "NVIM_APPNAME=astrovim nvim"
alias nn "NVIM_APPNAME=nvchad nvim"

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

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# monokai theme for TIDE
set --universal tide_color_frame_and_connection "#272822"
set --universal tide_color_separator_same_color "#272822"

# Prompt Items
set --universal tide_pwd_bg_color "#272822"
set --universal tide_pwd_color_dirs "#f8f8f2"

set --universal tide_git_bg_color "#75715e"
set --universal tide_git_color_branch "#f8f8f2"
set --universal tide_git_color_untracked "#e6db74"
set --universal tide_git_color_dirty "#fd971f"
set --universal tide_git_color_staged "#a6e22e"

set --universal tide_status_bg_color "#a6e22e"
set --universal tide_status_color_failure "#f92672"
set --universal tide_status_color_failure "#ff0000"
