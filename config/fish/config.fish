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
alias n nvim
# alias f fuck
alias saar fuck
alias lg lazygit

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
