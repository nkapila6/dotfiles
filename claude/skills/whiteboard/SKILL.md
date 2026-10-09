---
name: whiteboard
description: Generate a text-based architecture diagram of the project or a specific area. ASCII boxes and arrows showing how components interact.
user-invocable: true
disable-model-invocation: true
---

Produce a text-based architecture diagram of the project, or a specific area the user names.

## Input

The user may pass an area to focus on (e.g. "auth", "the orders flow", "the build pipeline"). If empty, diagram the whole project at a high level.

## Steps

1. Explore the codebase to identify: entry points, core modules, data flow, external dependencies, and system boundaries.
2. Draw an ASCII/box diagram showing:
   - Entry points (API routes, main functions, UI components).
   - Core modules and their responsibilities.
   - Data flow (what calls what, what passes where) - use arrows.
   - External dependencies (databases, APIs, services).
   - Boundaries between systems.
3. Use boxes, arrows, and labels. Keep it readable in a terminal (no wide diagrams that wrap).
4. After the diagram, ask: "Which of these boundaries would be hardest to change, and why?"

## Example shape

```
┌──────────────┐     ┌──────────────┐
│  HTTP entry  │────▶│  Auth middleware │
└──────────────┘     └──────────────┘
                            │
                            ▼
                     ┌──────────────┐
                     │  User store  │
                     └──────────────┘
```

## Hard rules

- Read-only. Do not edit code.
- Do not spawn subagents.
- Keep the diagram narrow enough for a terminal.