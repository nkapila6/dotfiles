---
description: Review a specific git diff (pass a ref like HEAD~1 or a branch name)
agent: reviewer
subtask: true
---
Review the diff in !`git diff $ARGUMENTS` for bugs, security, and style.
Categorize findings as: blocker, should-fix, nit. Lead with blockers.
Cite file:line, quote the offending code, state the fix in one sentence. Do not write the fix.