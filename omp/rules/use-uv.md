---
description: "Use uv, never pip"
condition:
  - "(?<!uv )\\bpip3?\\s+install\\b"
  - "\\bpython3?\\s+-m\\s+pip\\b"
---
Python tooling goes through uv, never pip. Use `uv add`, `uv pip install`, `uv run`, or `uv tool install` instead.
