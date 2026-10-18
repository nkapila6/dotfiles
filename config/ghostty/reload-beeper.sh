#!/bin/sh
# Reload Beeper custom.css by sending Cmd+R (reloads Electron renderer)
osascript -e 'tell application "System Events"
  set proc to first process whose name is "Beeper Desktop"
  set frontmost of proc to true
end tell
delay 0.3
tell application "System Events" to keystroke "r" using {command down}' 2>/dev/null
