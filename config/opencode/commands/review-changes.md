---
description: Review recent git changes for bugs, security, and style
agent: reviewer
subtask: true
---
Recent git commits:
!`git log --oneline -10`

Review these changes. Categorize findings as: blocker, should-fix, nit. Lead with blockers.
Cite file:line, quote the offending code, state the fix in one sentence. Do not write the fix.