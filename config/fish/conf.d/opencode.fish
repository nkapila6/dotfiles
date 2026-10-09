# opencode reads skills from ~/.agents/skills (synced by sync-skills), not ~/.claude/skills
set -gx OPENCODE_DISABLE_CLAUDE_CODE_SKILLS 1
