#!/bin/sh
# Reload ghostty config by activating it and sending cmd+shift+,
osascript <<'APPLESCRIPT'
tell application "System Events"
    set proc to first process whose name is "ghostty"
    set frontmost of proc to true
end tell
delay 0.2
tell application "System Events" to keystroke "," using {command down, shift down}
APPLESCRIPT
