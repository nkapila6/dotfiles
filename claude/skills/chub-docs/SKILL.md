---
name: chub-docs
description: Fetch curated API documentation from Context Hub (chub). Use before writing code that calls an unfamiliar API or library, instead of guessing signatures. Search with a query, or get a specific doc by ID with an optional language. Also use when a library has had breaking changes and you need the current version's docs.
user-invocable: true
---

Fetch accurate, current API docs from Context Hub via the `chub` CLI instead of guessing API signatures.

## Prerequisite

The `chub` CLI must be on `$PATH`. Verify with `command -v chub`. If missing, tell the user and stop.

## Usage

### Search for available docs

```bash
chub search "query"    # e.g. chub search "stripe payments"
chub search            # list all available docs
```

### Fetch a specific doc

```bash
chub get <id> --lang py   # Python variant
chub get <id> --lang js   # JavaScript variant
chub get <id>             # default language
```

### Fetch a specific reference file within a doc

```bash
chub get <id> --file <filename>
```

### Annotate a gap or workaround for future sessions

```bash
chub annotate <id> "note about what was missing or how to work around it"
```

## When to use

- Writing code that calls an external API (OpenAI, Stripe, Cloudflare, etc.).
- Unsure about exact function signatures, parameters, or return types.
- The library has had breaking changes and you need the current version's docs.

## When NOT to use

- You already know the API well and are confident.
- The codebase has its own wrappers or examples you can follow.
- Simple standard library calls.

## Rules

- Run `chub` via the bash tool. Capture the output, read it, then write the code.
- If `chub` fails (network, auth, missing doc), report the error and fall back to the codebase's own wrappers/examples if any. Don't guess the API from memory.