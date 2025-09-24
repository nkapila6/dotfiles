# notheme.fish

# This file configures a "colorless" Fish shell theme.
# It disables all color settings for both Fish's built-in syntax highlighting
# and the Tide prompt, allowing the terminal emulator to provide the theme.

# ====================
# Fish Syntax Colors
# ====================
# Set all built-in Fish color variables to 'normal' to use the terminal's defaults.
set -U fish_color_autosuggestion normal
set -U fish_color_cancel normal
set -U fish_color_command normal
set -U fish_color_comment normal
set -U fish_color_cwd normal
set -U fish_color_cwd_root normal
set -U fish_color_end normal
set -U fish_color_error normal
set -U fish_color_escape normal
set -U fish_color_history_current normal
set -U fish_color_host normal
set -U fish_color_host_remote normal
set -U fish_color_keyword normal
set -U fish_color_match normal
set -U fish_color_normal normal
set -U fish_color_operator normal
set -U fish_color_option normal
set -U fish_color_param normal
set -U fish_color_quote normal
set -U fish_color_redirection normal
set -U fish_color_search_match normal
set -U fish_color_selection normal
set -U fish_color_status normal
set -U fish_color_user normal
set -U fish_color_valid_path normal
set -U fish_pager_color_background normal
set -U fish_pager_color_completion normal
set -U fish_pager_color_description normal
set -U fish_pager_color_prefix normal
set -U fish_pager_color_progress normal

# ====================
# Tide Prompt Colors
# ====================
# Set all Tide item colors and background colors to 'normal'.
# This allows the prompt to inherit the terminal's theme colors.

# Prompt-wide settings
set --universal tide_color_frame_and_connection normal
set --universal tide_color_separator_same_color normal

# PWD
set --universal tide_pwd_bg_color normal
set --universal tide_pwd_color_dirs normal
set --universal tide_pwd_color_truncated_dirs normal
set --universal tide_pwd_color_anchors normal

# Git
set --universal tide_git_bg_color normal
set --universal tide_git_color_branch normal
set --universal tide_git_color_untracked normal
set --universal tide_git_color_dirty normal
set --universal tide_git_color_staged normal
set --universal tide_git_color_conflicted normal
set --universal tide_git_bg_color_unstable normal
set --universal tide_git_bg_color_urgent normal

# Character
set --universal tide_character_color normal
set --universal tide_character_color_failure normal

# Status
set --universal tide_status_bg_color normal
set --universal tide_status_bg_color_failure normal
set --universal tide_status_color normal
set --universal tide_status_color_failure normal

# Cmd Duration
set --universal tide_cmd_duration_bg_color normal
set --universal tide_cmd_duration_color normal

# Jobs
set --universal tide_jobs_bg_color normal
set --universal tide_jobs_color normal

# Time
set --universal tide_time_bg_color normal
set --universal tide_time_color normal

# Context
set --universal tide_context_bg_color normal
set --universal tide_context_color_default normal
set --universal tide_context_color_root normal
set --universal tide_context_color_ssh normal

# Other items
set --universal tide_aws_bg_color normal
set --universal tide_aws_color normal
set --universal tide_bun_bg_color normal
set --universal tide_bun_color normal
set --universal tide_crystal_bg_color normal
set --universal tide_crystal_color normal
set --universal tide_direnv_bg_color normal
set --universal tide_direnv_bg_color_denied normal
set --universal tide_direnv_color normal
set --universal tide_direnv_color_denied normal
set --universal tide_distrobox_bg_color normal
set --universal tide_distrobox_color normal
set --universal tide_docker_bg_color normal
set --universal tide_docker_color normal
set --universal tide_elixir_bg_color normal
set --universal tide_elixir_color normal
set --universal tide_gcloud_bg_color normal
set --universal tide_gcloud_color normal
set --universal tide_go_bg_color normal
set --universal tide_go_color normal
set --universal tide_java_bg_color normal
set --universal tide_java_color normal
set --
