---
name: todo-file
description: Read or write a .todo file in the project root to persist task state across the session. Survives compaction. Use to track multi-step task progress so context isn't lost across long sessions or agent handoffs. Actions are read, write, append, clear.
user-invocable: true
---

Persist task state to a `.todo` file at the project root. Run via the bash tool.

## Why

Long sessions get compacted and the in-memory todo list is lost. A `.todo` file on disk survives compaction, restarts, and handoffs between agents. Use this when a task spans many steps and you want progress to outlive the current turn.

## Actions

### read

```bash
cat .todo 2>/dev/null || echo "No .todo file yet."
```

### write (replace all)

```bash
cat > .todo <<'EOF'
- [ ] step one
- [ ] step two
- [x] done step
EOF
```

### append (add a line)

```bash
echo "- [ ] new task" >> .todo
```

### clear

```bash
: > .todo   # truncate, keep the file
```

## Format

Use markdown checkbox syntax:

```
- [ ] pending task
- [x] completed task
```

## Rules

- The `.todo` file lives at the project root. Add it to `.gitignore` so it's never committed.
- One line per task. Keep lines short.
- `write` replaces the entire file. `append` adds a single line. Use `write` for the initial plan, `append` for additions, and edit lines in place to mark `[ ]` -> `[x]`.
- Don't store secrets, code, or long prose in the `.todo` file. It's a checklist, not a notebook.