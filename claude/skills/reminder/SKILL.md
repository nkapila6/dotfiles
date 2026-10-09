---
name: reminder
description: Schedule persistent reminders via macOS Reminders.app. Fires native OS notifications at the scheduled time, survives restarts, no background process. Reminders appear in the Reminders app under a "crush" list (override with --list). Use to schedule a follow-up nudge or a "come back in 20 minutes" marker.
user-invocable: true
---

Schedule persistent reminders via macOS Reminders.app using `osascript`. Run via the bash tool.

## Prerequisite

macOS only. `osascript` must be on `$PATH` (default on macOS). If not on macOS, stop and tell the user.

## Actions

### add

Schedule a reminder.

```bash
MSG="<message>"
MIN=<minutes_from_now>   # either this or FIRE_AT
FIRE_AT="<ISO8601>"       # e.g. 2026-07-13T09:00:00, alternative to MIN
LIST="crush"              # optional, default "crush"
```

```bash
SECONDS=$((MIN * 60))
LIST_ESC=$(echo "$LIST" | sed 's/\\/\\\\/g; s/"/\\"/g')
MSG_ESC=$(echo "$MSG" | sed 's/\\/\\\\/g; s/"/\\"/g')

osascript -e "
set fireDate to current date
set time of fireDate to (time of fireDate) + ${SECONDS}
tell application \"Reminders\"
    if not (exists list \"${LIST_ESC}\") then
        make new list with properties {name:\"${LIST_ESC}\"}
    end if
    tell list \"${LIST_ESC}\"
        make new reminder with properties {name:\"${MSG_ESC}\", due date:fireDate, remind me date:fireDate}
    end tell
end tell"
```

### list

Show pending reminders in the list.

```bash
LIST="crush"
osascript -e "
tell application \"Reminders\"
    if not (exists list \"$LIST\") then
        return \"No crush reminders yet.\"
    end if
    set output to \"\"
    tell list \"$LIST\"
        set rs to (every reminder whose completed is false)
        repeat with r in rs
            set output to output & (name of r) & \" | due: \" & (due date of r) & linefeed
        end repeat
    end tell
    return output
end tell"
```

### clear

Delete the entire list.

```bash
LIST="crush"
osascript -e "
tell application \"Reminders\"
    if (exists list \"$LIST\") then
        delete list \"$LIST\"
        return \"Cleared.\"
    end if
    return \"Nothing to clear.\"
end tell"
```

## Rules

- Always run via the bash tool. Never inline `osascript` into a script the user runs themselves unless they ask.
- If `osascript` fails (Reminders.app not authorized, not on macOS), surface the error and stop.
- Default list name is `crush`. Override per call if the user asks.
- If both `inMinutes` and `fireAt` are missing, report "Need either inMinutes or fireAt" and stop.
- If `fireAt` is in the past, report it and stop.