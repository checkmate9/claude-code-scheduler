#!/bin/bash
# install.sh — set up the 6h scheduler on a new machine
set -e

INSTALL_DIR="$HOME/Documents/claude-code"
LAUNCHAGENTS_DIR="$HOME/Library/LaunchAgents"

echo "Setting up claude-code scheduler..."

# Create directories
mkdir -p "$INSTALL_DIR/scheduler-logs"
mkdir -p "$LAUNCHAGENTS_DIR"

# Copy scheduler script
cp run-agents-every-6h.sh "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/run-agents-every-6h.sh"
echo "✅ Scheduler script installed at $INSTALL_DIR/run-agents-every-6h.sh"

# Install LaunchAgent
cp com.agents.every6h.plist "$LAUNCHAGENTS_DIR/"

# Unload if already loaded, then reload
launchctl unload "$LAUNCHAGENTS_DIR/com.agents.every6h.plist" 2>/dev/null || true
launchctl load "$LAUNCHAGENTS_DIR/com.agents.every6h.plist"
echo "✅ LaunchAgent loaded"

# Check status
STATUS=$(launchctl list | grep every6h || echo "not found")
echo ""
echo "Status: $STATUS"

if echo "$STATUS" | grep -q "126"; then
  echo ""
  echo "⚠️  Exit code 126 = macOS blocking access to ~/Documents"
  echo "   Fix: System Settings → Privacy & Security → Full Disk Access → + → /bin/bash"
else
  echo "✅ Scheduler running — fires at 00:00, 06:00, 12:00, 18:00 local time"
fi

echo ""
echo "Logs: $INSTALL_DIR/scheduler-logs/"
