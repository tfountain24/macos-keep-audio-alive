#!/bin/bash
set -e

DEVICE_NAME="$1"
PLIST_NAME="com.keepaudioalive.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE="$SCRIPT_DIR/com.keepaudioalive.plist.template"

if [ -z "$DEVICE_NAME" ]; then
    echo "Usage: ./install.sh \"Your Audio Device Name\""
    echo ""
    echo "To list available devices, run:"
    echo "  sox -n -t coreaudio \"?\" synth sine 0 vol 0 2>&1"
    exit 1
fi

# Find sox
SOX_PATH="$(command -v sox 2>/dev/null || true)"
if [ -z "$SOX_PATH" ]; then
    echo "Error: sox is not installed. Install it with: brew install sox"
    exit 1
fi

# Unload existing agent if present
if launchctl list | grep -q "com.keepaudioalive"; then
    echo "Unloading existing agent..."
    launchctl unload "$PLIST_DEST" 2>/dev/null || true
fi

# Generate plist from template
echo "Creating LaunchAgent for device: $DEVICE_NAME"
echo "Using sox at: $SOX_PATH"

sed -e "s|{{DEVICE_NAME}}|$DEVICE_NAME|g" \
    -e "s|{{SOX_PATH}}|$SOX_PATH|g" \
    "$TEMPLATE" > "$PLIST_DEST"

# Load the agent
launchctl load "$PLIST_DEST"

echo ""
echo "Done! Verifying..."
if launchctl list | grep -q "com.keepaudioalive"; then
    echo "Agent is running successfully."
else
    echo "Warning: Agent may not have started. Check with: launchctl list | grep keepaudioalive"
fi
