---
name: get-api-docs
description: Use when writing code that calls an external API or library and you need accurate, current documentation to avoid hallucinating API signatures. Runs `chub` to fetch curated docs.
---

When you need API documentation for a library or service, use the `chub` CLI tool to fetch curated, versioned docs instead of guessing or searching the web.

## How to use chub

1. Search for available docs:
   ```
   chub search "query"    # e.g. chub search "stripe payments"
   chub search             # list all available docs
   ```

2. Fetch the doc you need:
   ```
   chub get <id> --lang py  # Python variant
   chub get <id> --lang js  # JavaScript variant
   ```

3. If the doc has multiple reference files and you only need one:
   ```
   chub get <id> --file <filename>
   ```

4. If you discover a gap or workaround, annotate it for future sessions:
   ```
   chub annotate <id> "note about what was missing or how to work around it"
   ```

## When to use this skill
- Writing code that calls an external API (OpenAI, Stripe, Cloudflare, etc.)
- Unsure about exact function signatures, parameters, or return types
- The library has had breaking changes and you need the current version's docs

## When NOT to use
- You already know the API well and are confident
- The codebase has its own wrappers or examples you can follow
- Simple standard library calls