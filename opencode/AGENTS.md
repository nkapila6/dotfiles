# Global Rules

> Rules marked `[Enforced by guardrails plugin]` are automatically enforced via OpenCode plugin hooks. Rules marked `[Prompt only]` cannot be enforced programmatically. See `plugin/guardrails.ts`.

## Communication

- Be blunt and direct. No sycophancy, no filler.
- No emojis anywhere: commits, code, comments, docs. `[Enforced by guardrails plugin for commits and file edits]`
- No em dashes in any output. Use regular hyphens or restructure the sentence. `[Prompt only - cannot be hook-enforced]`
- When stuck after 2 attempts, stop and ask. Don't spiral.

## Git Commits

- No `Co-authored-by: Claude` or any AI attribution lines. `[Enforced by guardrails plugin]`
- No descriptions/body in commits. Subject line only. `[Enforced by guardrails plugin]`
- Always use "Conventional Commits" style (fix, feat, docs, chore, etc). `[Enforced by guardrails plugin]`
- Keep subject lines short, lowercase, imperative mood. Example: `fix token refresh on expired sessions` `[Enforced by guardrails plugin]`

## Code Style

- Comments should be short and human-sounding. No verbose docstring novels.
- Write comments for the "why", not the "what". If the code is obvious, skip the comment.
- No hardcoded secrets, tokens, or API keys. Always use environment variables.
- Never read or parse `.env` files directly in code. Use the runtime environment. `[Enforced by safeguard plugin for reads]`

## Tooling

- Python: always use `uv`, never `pip`. `[Enforced by guardrails plugin]`
- Go: prefer the standard library. Don't pull third-party deps unless there's a clear justification.

## Testing

- Before writing tests, ask the human what they want tested and what the expected behavior is.
- Ask enough questions to understand the overall functionality before generating test code.
- Don't auto-generate test suites without explicit direction.

## Worktrees

- Prefer git worktrees over switching branches. Work in separate directories, not stashing or switching.
- Create worktrees under `../<project>-worktrees/<branch-name>` (sibling to the main repo).
- Command: `git worktree add ../<project>-worktrees/<branch-name> -b <branch-name>` (or use an existing branch).
- When done with a worktree, merge the branch back and remove it: `git worktree remove ../<project>-worktrees/<branch-name>`.
- Before creating a worktree, check if one already exists for the branch: `git worktree list`.
- If a task needs isolation (experimental change, parallel work), create a worktree first and work there.
- Don't create worktrees for trivial one-file fixes. Use judgment.

## Autonomy Boundaries

- Don't add or remove dependencies without asking. `[Enforced by guardrails plugin]`
- Don't refactor files outside the scope of the current task.
- Don't delete files. `[Enforced by guardrails plugin]`
- Don't touch CI/CD configs, build configs, or deploy scripts without asking. `[Enforced by guardrails plugin]`
- If a change touches 3+ files, outline the plan first and wait for approval.
- If stuck after 2 attempts at a problem, stop and ask. Don't keep guessing.

## Decision Making

- Ground every technical decision with a web search or a clear justification.
- If choosing between approaches, briefly state the tradeoff and why you picked one.

## Mechanical Edits

- If a task is a mechanical find-and-replace (rename, reformatting, bulk substitution, anything regex-shaped), use a command (`sed`, `perl`, `rg --replace`, `python -c`) instead of editing files one-by-one through the LLM. Do not burn forward passes on something a one-liner solves.
- If the replacement is simple enough that you can describe it as a regex pattern, it should be a command, not a subagent task.
- Only fall back to LLM edits when the replacement requires understanding context, meaning, or intent that a regex can't capture.

## READMEs and Documentation

- Write READMEs and docs in a human, natural style. Not corporate, not robotic, not LLM-sounding.
- Match the tone of a developer talking to another developer, not a marketing page.
- Keep docs concise. No filler paragraphs. No "Getting Started" novels if a one-liner suffices.
- Never generate boilerplate sections (Contributing, License, Code of Conduct) unless explicitly asked.

## The `explained/` Folder

Maintain a folder called `explained/` at the project root. Create it if it doesn't exist.

Purpose: a developer should be able to read these markdown files and understand the entire codebase: architecture, decisions, data flow, APIs, without reading a single line of source code. They should be able to make changes and submit a PR from this context alone.

Do not push this folder to GitHub or the commits, it is always untracked. `[Enforced by guardrails plugin for git add]`

### Structure

- One markdown file per module or feature (e.g., `explained/auth-flow.md`, `explained/mcp-helvarnet.md`).
- NOT one file per commit or per change.

### What goes in

- New module or feature: what it does, how it fits in, key files involved.
- Architecture and design decisions: what was chosen, why, what was rejected.
- Non-obvious implementation choices: the "why" behind things that would confuse a new dev.
- API contracts, data flow, and integration points.
- Any external dependencies and why they are needed.

### What does NOT trigger an update

- Bug fixes
- Style or formatting tweaks
- Small refactors that don't change architecture

### Format per file

```
# [Module/Feature Name]

## Overview
What this does in 2-3 sentences.

## Key Files
- `path/to/file.go` - brief role

## How It Works
Explain the flow. A new dev reads this instead of the code.

## Decisions
- [Decision]: [Why]. [What was rejected and why].

## Gotchas
Anything non-obvious that would trip someone up.
```
