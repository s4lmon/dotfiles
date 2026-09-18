#!/bin/bash

# Background watcher that updates workspace icons when windows change
# Polls every 2 seconds to detect window changes

CONFIG_DIR="$HOME/.config/sketchybar"
CACHE_FILE="/tmp/aerospace_windows_cache"

# Initialize cache
aerospace list-windows --all | sort > "$CACHE_FILE"

while true; do
    sleep 2

    # Get current window list
    current_windows=$(aerospace list-windows --all | sort)

    # Compare with cache
    if [ "$current_windows" != "$(cat "$CACHE_FILE")" ]; then
        # Windows changed, update icons
        "$CONFIG_DIR/plugins/update_workspace_icons.sh"
        echo "$current_windows" > "$CACHE_FILE"
    fi
done
