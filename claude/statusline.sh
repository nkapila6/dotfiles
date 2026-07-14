#!/bin/bash
input=$(cat)
branch=$(echo "$input" | jq -r '.git.branch // empty')
status=$(echo "$input" | jq -r '.git.status // empty')
cwd=$(echo "$input" | jq -r '.cwd // empty')

if [ -n "$branch" ]; then
    printf "\033[32m%b\033[0m" "$branch"
    case "$status" in
        dirty) printf " \033[33m!\033[0m" ;;
        clean) printf " \033[32m✓\033[0m" ;;
    esac
fi

if [ -n "$cwd" ]; then
    printf " \033[36m%s\033[0m" "$(basename "$cwd")"
fi