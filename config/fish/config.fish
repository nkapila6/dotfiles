#pycharm
# fish_add_path "/Applications/PyCharm.app/Contents/MacOS"
fish_add_path "/opt/homebrew/opt/node@22/bin"
# fish_add_path "$HOME/Library/Application Support/reflex/bun/bin"
# fish_add_path "/Users/nkapila6/.lmstudio/bin"
fish_add_path /usr/local/bin
# fish_add_path $HOME/.emacs.d/bin
fish_add_path $HOME/go/bin/
fish_add_path "~/.config/v-analyzer/bin/"
fish_add_path $HOME/bin/

# tools
zoxide init fish | source
direnv hook fish | source
source "$HOME/.cargo/env.fish"

set -g fish_key_bindings fish_vi_key_bindings

# aliases
alias arm "env /usr/bin/arch -arm64 /bin/zsh --login"
alias intel "env /usr/bin/arch -x86_64 /bin/zsh --login"
alias ms "switchaudiosource -s 'MacBook Pro Speakers'"
alias pas "switchaudiosource -s 'Proxy Audio Device'"
alias lg lazygit
alias f fuck
alias n nvim
# alias an "NVIM_APPNAME=astrovim nvim"
# alias nn "NVIM_APPNAME=nvchad nvim"
alias ls lsd
alias pd proton-drive
# Vite+ node under explicit aliases (bare npm/node use Homebrew)
alias npm+ "$HOME/.vite-plus/bin/npm"
alias node+ "$HOME/.vite-plus/bin/node"
alias npx+ "$HOME/.vite-plus/bin/npx"
alias ob "cd /Users/nkapila6/Library/CloudStorage/OneDrive-Personal/Apps/Notes && nvim /Users/nkapila6/Library/CloudStorage/OneDrive-Personal/Apps/Notes"

function ggl -a search
    open "https://www.google.com/search?hl=en&q=$search"
end

function ddgs -a search
    open "https://duckduckgo.com/?q=$search"
end

function yt -a search
    open "https://www.youtube.com/results?search_query=$search"
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# set theme_color_scheme gruvbox
set -g fish_prompt_pwd_dir_length 0
set -g theme_powerline_fonts
set -g theme_nerd_fonts yes
set -g theme_newline_cursor yes

# uv
fish_add_path "/Users/nkapila6/.local/bin"

# global node modules (Homebrew) on the require path
set -gx NODE_PATH /opt/homebrew/lib/node_modules

# gpg
export GPG_TTY=$(tty)

# startship
starship init fish | source
# one-line starship prompt that only wraps the right side when it won't fit.
# replaces the fish_prompt/fish_right_prompt that `starship init` defines.
function __starship_adaptive
    function fish_prompt
        set -l st $status
        set -l ps $pipestatus
        set -l keymap insert
        contains -- "$fish_key_bindings" fish_vi_key_bindings fish_hybrid_key_bindings; and set keymap $fish_bind_mode
        __starship_set_job_count
        set -l args --terminal-width=$COLUMNS --status=$st --pipestatus="$ps" --keymap=$keymap --cmd-duration="$CMD_DURATION$cmd_duration" --jobs=$STARSHIP_JOBS

        set -l lines (starship prompt $args)
        set -l right (starship prompt --right $args)
        set -l n (count $lines)
        if test $n -lt 2; or test -z "$right"
            printf '%s\n' $lines[1..-2]
            printf '%s' $lines[-1]
            return
        end

        # everything before the last two lines is the add_newline/clear prefix
        test $n -gt 2; and printf '%s\n' $lines[1..-3]
        set -l left $lines[-2]
        set -l gap (math $COLUMNS - (string length --visible -- $left) - (string length --visible -- $right))
        if test $gap -ge 1
            printf '%s%s%s\n' $left (string repeat -n $gap ' ') $right
        else
            printf '%s\n%s\n' $left $right
        end
        printf '%s' $lines[-1]
    end

    function fish_right_prompt
    end
end
__starship_adaptive

# Homebrew curl setup for C development
set -gx LDFLAGS -L/opt/homebrew/opt/curl/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/curl/include
set -gx PKG_CONFIG_PATH /opt/homebrew/opt/curl/lib/pkgconfig

# Ensure the binary is preferred over system curl
fish_add_path /opt/homebrew/opt/curl/bin
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx GPG_TTY (tty)
set -gx ANDROID_NDK_HOME /opt/homebrew/share/android-ndk

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Environment:
#   TODO_DIR     directory holding todo.txt / done.txt
#   TODO_FILE    path to the todo file (default $TODO_DIR/todo.txt)
#   DONE_FILE    path to the archive file (default sibling done.txt)
set --export TODO_DIR "~/.config/tuxedo/"
set --export TODO_FILE "~/.config/tuxedo/todo.txt"
set --export DONE_FILE "~/.config/tuxedo/done.txt"

# wallust
# if status is-interactive
#     test -f "$HOME/Library/Caches/wallust/sequences" && cat "$HOME/Library/Caches/wallust/sequences"
# end

# fastfetch on new shells, but not inside nvim's terminal
function fish_greeting
    set -q NVIM; or fastfetch
end

# preview / pick starship prompt variants from ~/.config/starship/variants
function spv --description "preview and switch starship prompt variants"
    set -l dir ~/.config/starship/variants
    set -l names (path basename -E $dir/*.toml)
    set -l active (path basename -E -- "$STARSHIP_CONFIG")

    switch "$argv[1]"
        case -h --help help
            echo "spv - preview starship prompt variants"
            echo
            echo "usage:"
            echo "  spv               list variants (* = previewing now)"
            echo "  spv <name>        preview a variant in this shell only"
            echo "  spv next | prev   cycle through variants"
            echo "  spv random        preview a random variant"
            echo "  spv save [name]   make a variant your real prompt (backs up the old one)"
            echo "  spv reset         stop previewing, back to ~/.config/starship.toml"
            echo "  spv -h            this help"
            echo
            echo "variants live in $dir"
        case '' ls list
            for n in $names
                if test "$n" = "$active"
                    echo "* $n"
                else
                    echo "  $n"
                end
            end
        case reset
            set -e STARSHIP_CONFIG
            echo "back to ~/.config/starship.toml"
        case next prev
            set -l i (contains -i -- "$active" $names; or echo 0)
            set -l n (count $names)
            if test $argv[1] = next
                set i (math "$i % $n + 1")
            else
                set i (math "($i + $n - 2) % $n + 1")
            end
            set -gx STARSHIP_CONFIG $dir/$names[$i].toml
            echo "previewing $names[$i]"
        case random
            set -l pick (random choice $names)
            set -gx STARSHIP_CONFIG $dir/$pick.toml
            echo "previewing $pick"
        case save
            set -l pick $argv[2]
            test -z "$pick"; and set pick $active
            if not contains -- "$pick" $names
                echo "spv: nothing to save, preview one first or pass a name" >&2
                return 1
            end
            cp ~/.config/starship.toml ~/.config/starship.toml.bak 2>/dev/null
            cp $dir/$pick.toml ~/.config/starship.toml
            set -e STARSHIP_CONFIG
            echo "saved $pick as your prompt (old one at ~/.config/starship.toml.bak)"
        case '*'
            if not contains -- "$argv[1]" $names
                echo "spv: no variant '$argv[1]', run spv to list them" >&2
                return 1
            end
            set -gx STARSHIP_CONFIG $dir/$argv[1].toml
    end
end
complete -c spv -f
complete -c spv -n __fish_is_first_arg -a "(path basename -E ~/.config/starship/variants/*.toml)" -d variant
complete -c spv -n __fish_is_first_arg -a "next prev random save reset" -d command
complete -c spv -n "__fish_seen_subcommand_from save" -a "(path basename -E ~/.config/starship/variants/*.toml)" -d variant
complete -c spv -s h -l help -d "show help"
