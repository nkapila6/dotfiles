---
name: btw
description: A side-note or tangent that should not pollute the main conversation context. Answer concisely without changing the codebase.
user-invocable: true
disable-model-invocation: true
---

Answer the user's side question concisely. This is a tangent, not the main task.

## Rules

- Answer the question directly and concisely. No filler.
- Do not make any changes to the codebase. No edits, no writes, no staged changes.
- Do not spawn subagents.
- Keep the answer short and factual. If a one-line answer suffices, give one line.
- If the question requires reading a file, read it and answer. Do not refactor.
- If the question is about something you don't know, say so plainly. Don't guess.