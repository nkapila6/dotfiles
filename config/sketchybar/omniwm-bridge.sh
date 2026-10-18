#!/usr/bin/env bash
# Bridges OmniWM events to sketchybar.
# Run with: omniwmctl watch active-workspace --exec "$HOME/.config/sketchybar/omniwm-bridge.sh" &

while IFS= read -r line; do
	workspace=$(echo "$line" | jq -r '.workspace // .name // .id // empty' 2>/dev/null)
	monitor=$(echo "$line" | jq -r '.monitor // .display // .focusedMonitor // empty' 2>/dev/null)

	if [ -n "$workspace" ]; then
		sketchybar --trigger omniwm_workspace_change \
			FOCUSED_WORKSPACE="$workspace" \
			FOCUSED_DISPLAY="$monitor" 2>/dev/null
	fi
done
