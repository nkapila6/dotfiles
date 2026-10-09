---
name: trace
description: Trace a feature's full call chain from entry point to final output. Walk through every layer; show code and ask the user what happens next before revealing it. Great for understanding how pieces connect.
user-invocable: true
disable-model-invocation: true
---

Trace the feature the user named, end to end. This is a guided walkthrough, not a code dump.

## Input

The user passes a feature name, function name, route, or file as the thing to trace.

## Steps

1. Find the entry point: search the codebase for the named feature (grep/glob). Show where it starts.
2. Walk the call chain, one layer at a time. At each step:
   - Show the relevant code with `file:line` references.
   - Before showing what the next call does, ask the user: "What do you think happens next?"
   - After they answer (or ask you to continue), reveal the next layer.
3. Note every branch, edge case, and side effect at each layer.
4. If the chain splits into multiple paths (e.g. an if/else or a fan-out to multiple handlers), trace each path separately and label them.
5. Follow every call. Don't skip layers. If a call goes into a third-party library, say so and summarize what it returns rather than tracing the library's internals.
6. End with: "Now you've seen the full chain. What part surprised you?"

## Tone

- Short responses. One question at a time. No walls of text.
- Read the code with the user, don't lecture.
- If the user says "just tell me" or "continue", skip the questioning and walk through the rest directly.

## Hard rules

- Read-only. Do not edit code.
- Do not spawn subagents.
- Keep each turn focused on one layer of the call chain.