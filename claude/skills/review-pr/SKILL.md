---
name: review-pr
description: Review a specific git diff (pass a ref like HEAD~1 or a branch name) for bugs, security, and style. Read-only.
user-invocable: true
disable-model-invocation: true
---

Review a specific git diff. Read-only. Do not edit files.

## Input

The user passes a git ref or ref range, e.g. `HEAD~1`, `main..feature-branch`, `abc123..def456`, or a branch name. Treat the entire argument string as the ref spec.

## Steps

1. Run `git diff <ref>` (or `git diff <ref1>..<ref2>` if a range was given).
2. Read the full diff.
3. Categorize findings as: **blocker**, **should-fix**, **nit**. Lead with blockers.
4. For each finding:
   - Cite `file:line`.
   - Quote the offending code.
   - State the fix in one sentence. Do not write the fix yourself.
5. Check for: correctness, edge cases, error handling, security, style divergence, and whether the change matches its commit message.

## Focus areas

- **Correctness**: logic errors, off-by-one, null deref, race conditions.
- **Security**: injection, path traversal, secret leakage, unsafe deserialization, auth bypass.
- **Error handling**: swallowed errors, missing error paths, unhandled promises.
- **Style**: divergence from surrounding code, naming, dead code, scope creep.

## Hard rules

- Do not edit code. This is review only.
- If the diff is empty, say so and stop.
- If the ref is invalid, report the git error and stop. Don't guess a different ref.