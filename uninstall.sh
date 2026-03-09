#!/bin/bash

PLIST_DEST="$HOME/Library/LaunchAgents/com.keepaudioalive.plist"

if launchctl list | grep -q "com.keepaudioalive"; then
    echo "Unloading agent..."
    launchctl unload "$PLIST_DEST" 2>/dev/null
fi

if [ -f "$PLIST_DEST" ]; then
    rm "$PLIST_DEST"
    echo "Removed $PLIST_DEST"
fi

echo "Uninstall complete."
