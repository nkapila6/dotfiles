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
alias ob "cd /Users/nkapila6/Library/CloudStorage/OneDrive-Personal/Apps/Notes && nvim /Users/nkapila6/Library/CloudStorage/OneDrive-Personal/Apps/Notes"

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

# gpg
export GPG_TTY=$(tty)

# startship
starship init fish | source

# Homebrew curl setup for C development
set -gx LDFLAGS -L/opt/homebrew/opt/curl/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/curl/include
set -gx PKG_CONFIG_PATH /opt/homebrew/opt/curl/lib/pkgconfig

# Ensure the binary is preferred over system curl
fish_add_path /opt/homebrew/opt/curl/bin
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx GPG_TTY (tty)
set -gx ANDROID_NDK_HOME /opt/homebrew/share/android-ndk
