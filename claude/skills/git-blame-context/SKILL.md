---
name: git-blame-context
description: Get git blame context for a specific file and line. Returns who changed it, when, the commit hash, and the commit message, plus surrounding code. Faster than running git blame + git show separately. Use when investigating a bug and you need the history of a specific line.
user-invocable: true
---

Get git blame context for a file and line number. Run via the bash tool.

## Input

- `file` (required): path relative to project root.
- `line` (required): line number to blame.
- `context` (optional): lines of context around the blamed line (default 3).

## Command

```bash
FILE="<file>"; LINE=<line>; CTX=<context>      # optional, default 3
HASH=$(git blame -L ${LINE},${LINE} --porcelain "$FILE" | head -1 | awk '{print $1}')
AUTHOR=$(git blame -L ${LINE},${LINE} --porcelain "$FILE" | awk '/^author /{print $0}')
DATE=$(git blame -L ${LINE},${LINE} --porcelain "$FILE" | awk '/^author-time /{print $2}')
DATESTR=$(date -r "$DATE" +%Y-%m-%d 2>/dev/null || date -d @"$DATE" +%Y-%m-%d 2>/dev/null)
MSG=$(git log -1 --format=%s "$HASH")
START=$((LINE - CTX)); [ $START -lt 1 ] && START=1
END=$((LINE + CTX))
CODE=$(git blame -L ${START},${END} -- "$FILE")

echo "Commit: $HASH"
echo "Author: ${AUTHOR#author }"
echo "Date: $DATESTR"
echo "Message: $MSG"
echo
echo "Code (${START}-${END}):"
echo "$CODE"
```

## Rules

- Run via the bash tool with the project root as the working directory.
- If the file or line is invalid, git will error - surface the error, don't guess.
- Read-only. Do not edit anything.