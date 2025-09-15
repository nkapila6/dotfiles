fish_add_path /opt/homebrew/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
    # starship init fish | source
end

# bun
set -gx BUN_INSTALL "$HOME/Library/Application Support/reflex/bun"
set -gx PATH "$BUN_INSTALL/bin" $PATH
set -gx PATH "/opt/homebrew/opt/node@22/bin" $PATH

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
alias f fuck
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

# # fzf

# set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
# set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
# set -gx FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"
# set -l show_file_or_dir_preview "if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; end"
#
# set -gx FZF_CTRL_T_OPTS "--preview '$show_file_or_dir_preview'"
# set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# function _fzf_comprun
#     set command $argv[1]
#     set -e argv[1]
#
#     switch "$command"
#         case cd
#             fzf --preview 'eza --tree --color=always {} | head -200' $argv
#         case export unset
#             fzf --preview "eval 'echo \$argv'" $argv
#         case ssh
#             fzf --preview 'dig {}' $argv
#         case "*"
#             fzf --preview "$show_file_or_dir_preview" $argv
#     end
# end

# Use fd for listing path candidates and directory completion.
# function _fzf_compgen_path
#     fd --hidden --exclude .git . "$argv"
# end
#
# function _fzf_compgen_dir
#     fd --type=d --hidden --exclude .git . "$argv"
# end

# To get fzf's key bindings working, you'll need to install the fish-specific completion
# and key-binding files. These are usually provided by the fzf package itself,
# often by sourcing a file like fzf.fish.

# zoxide
zoxide init fish | source

# pycharm
set -gx PATH "$PATH" "/Applications/PyCharm.app/Contents/MacOS"

# orbstack
#source ~/.orbstack/shell/init.fish
set -gx PATH "$PATH" /usr/local/bin
#atunin init fish | source

# Added by LM Studio CLI (lms)
set -gx PATH "$PATH" "/Users/nkapila6/.lmstudio/bin"
# End of LM Studio CLI section

# direnv
direnv hook fish | source

set -g fish_key_bindings fish_vi_key_bindings
