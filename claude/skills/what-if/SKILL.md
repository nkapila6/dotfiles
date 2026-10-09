---
name: what-if
description: Predict the blast radius of a proposed change. What breaks, what's affected, what to watch out for. Read-only analysis.
user-invocable: true
disable-model-invocation: true
---

Analyze the blast radius of a proposed change. Read-only. Do not make changes.

## Input

The user describes a change they're considering, e.g. "rename the `getUser` function" or "switch from REST to GraphQL for the orders endpoint".

## Steps

1. Find every file and function that touches the code the user wants to change. Use grep, glob, and LSP references.
2. List what would break if the change were made naively.
3. List what tests would need updating (name the test files).
4. Identify hidden coupling: shared state, implicit contracts, timing dependencies, reflection or string-based lookups that won't show up in a reference search.
5. Rate the risk: **low / medium / high**, and why.
6. End with: "Given this blast radius, how would you sequence the change to minimize risk?"

## Output format

```
## Affected files
- path/to/file.ts:42 - calls the function
- ...

## What breaks
- ...

## Tests to update
- tests/file.test.ts - asserts on the old signature

## Hidden coupling
- ...

## Risk: <low|medium|high>
<one sentence why>
```

## Hard rules

- Read-only. Do not edit, write, or stage any files.
- Do not spawn subagents.
- If the proposed change is ambiguous, ask one clarifying question before searching.