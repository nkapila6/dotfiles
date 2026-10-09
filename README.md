# dotfiles
config files for apps

## agent harnesses

Plain copies, not symlinked. Restore by copying back:

- `claude/` -> `~/.claude/` (CLAUDE.md, settings.json, statusline.sh, agents, my own skills)
- `opencode/` -> `~/.config/opencode/`
- `omp/` -> `~/.omp/agent/` (config.yml and stream rules in `rules/`)
- `bin/sync-skills` -> `~/.local/bin/`
- `config/fish/conf.d/opencode.fish` -> `~/.config/fish/conf.d/`

Things that aren't stored here:

- `~/.omp/agent/AGENTS.md` is a symlink to `~/.claude/CLAUDE.md` so omp follows the same rules. Recreate it with `ln -s ~/.claude/CLAUDE.md ~/.omp/agent/AGENTS.md`.
- Third-party skills get reinstalled, not backed up: hyperframes (`npx skills add heygen-com/hyperframes`), terminal-browser (ships with the app), video-shotcraft (git clone).
- API keys. omp keeps the Ollama Cloud key in `~/.omp/agent/agent.db`, opencode in `~/.local/share/opencode/auth.json`.

Skills live in `~/.claude/skills`. Run `sync-skills` after editing one to copy them into `~/.agents/skills`, which opencode and omp read.
