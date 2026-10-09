---
name: review-changes
description: Review the last 10 git commits for bugs, security, and style. Read-only review; do not write fixes.
user-invocable: true
disable-model-invocation: true
---

Review recent git changes. Read-only. Do not edit files.

## Steps

1. Run `git log --oneline -10` to see the recent commits.
2. For each commit, run `git show <hash>` and read the diff.
3. Categorize findings as: **blocker**, **should-fix**, **nit**. Lead with blockers.
4. For each finding:
   - Cite `file:line`.
   - Quote the offending code.
   - State the fix in one sentence. Do not write the fix yourself.
5. Check for: correctness, edge cases, error handling, security, and divergence from intent.

## Focus areas

- **Correctness**: off-by-one, null deref, wrong condition, missing return.
- **Security**: SQL injection, path traversal, secret leakage, unsafe deserialization.
- **Error handling**: swallowed errors, missing error paths, unhandled promises.
- **Style**: divergence from surrounding code, naming, dead code.

## Hard rules

- Do not edit code. This is review only.
- Do not spawn subagents.
- If a commit is a merge commit or has no diff, skip it.