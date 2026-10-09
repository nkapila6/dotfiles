---
name: commit
description: Stage and commit current changes using conventional commits. Subject line only, no body, no AI attribution.
user-invocable: true
disable-model-invocation: true
---

Stage and commit current changes following the user's global rules.

## Steps

1. Run `git status` and inspect the staged/unstaged changes.
2. If nothing is staged, stage all tracked changes (`git add -u`).
3. Run `git diff --staged` and review what will be committed.
4. Write a conventional commit message:
   - Subject line only, no body, no description.
   - Lowercase, imperative mood. Example: `fix token refresh on expired sessions`.
   - Type prefix: `fix`, `feat`, `docs`, `chore`, `refactor`, `style`, `test`, `perf`, `ci`, `build`.
   - Keep it short.
5. Show the diff to the user before committing, then commit with `git commit -m "<message>"`.
6. **No `Co-authored-by` or any AI attribution lines.** The user's global rules forbid it.
7. Do not push unless the user asks.

## Hard rules

- Never use `git commit -i` or interactive modes.
- Never stage untracked files unless the user asks.
- Never edit git config.
- If a pre-commit hook fails, retry once. If it still fails, surface the hook error and stop.