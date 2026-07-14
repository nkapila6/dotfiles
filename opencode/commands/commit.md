---
description: Stage and commit current changes using conventional commits
agent: senior-dev
---
Here is the current staged diff:
!`git diff --staged`

If nothing is staged, show the unstaged diff:
!`git diff`

Stage all changes if nothing is staged yet. Then write a conventional commit message (fix, feat, docs, chore, refactor, etc).

Rules:
- Subject line only, no body, no description.
- Lowercase, imperative mood.
- No co-authored-by or AI attribution lines.
- Keep it short.

Show me the diff before committing. Then commit.