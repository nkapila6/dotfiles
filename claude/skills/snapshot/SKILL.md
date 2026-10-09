---
name: snapshot
description: Save or restore a snapshot of current file state before making risky edits. Save copies files to a temp dir under .opencode-snapshots/. Restore brings them back. Useful before a risky multi-file edit - if it messes up, one call restores. Actions are save, restore, list, clear.
user-invocable: true
---

Save or restore a snapshot of file state. Run via the bash tool.

## Actions

### save

Snapshot the current state of files. If no files given, snapshot all git-tracked files.

```bash
LABEL="<optional_label>"   # default: timestamp
DEST=".opencode-snapshots/$LABEL"
mkdir -p "$DEST"

# If files are given, snapshot them. Otherwise snapshot all tracked files.
# Example for explicit files:
FILES="path/to/a.ts path/to/b.go"
for f in $FILES; do
    [ -f "$f" ] && mkdir -p "$DEST/$(dirname "$f")" && cp "$f" "$DEST/$f"
done

# Default (all tracked files):
# git ls-files | while read f; do [ -f "$f" ] && mkdir -p "$DEST/$(dirname "$f")" && cp "$f" "$DEST/$f"; done
```

Use a label like `before-refactor-auth` so you can restore by name.

### restore

Restore files from a saved snapshot.

```bash
LABEL="<label>"
cp -r ".opencode-snapshots/$LABEL/." .
```

### list

List saved snapshots.

```bash
ls -1 .opencode-snapshots/ 2>/dev/null || echo "No snapshots."
```

### clear

Delete all snapshots.

```bash
rm -rf .opencode-snapshots
```

## Rules

- Snapshots live in `.opencode-snapshots/` at the project root. Add it to `.gitignore` so it's never committed.
- Before a risky multi-file edit, call `snapshot save` with a label. If the edit goes wrong, `snapshot restore <label>`.
- Don't snapshot `node_modules`, build output, or `.git` - only source files. The git-tracked default handles this.
- If the snapshot dir doesn't exist on restore, report "Snapshot '<label>' not found" and stop.