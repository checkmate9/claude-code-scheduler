#!/bin/bash
# install.sh — set up all bots + scheduler on a new machine
set -e

INSTALL_DIR="$HOME/Documents/claude-code"
LAUNCHAGENTS_DIR="$HOME/Library/LaunchAgents"
LOGS_DIR="$HOME/claude-code/logs"

echo "Setting up claude-code bots + scheduler..."

# Create directories
mkdir -p "$INSTALL_DIR/scheduler-logs"
mkdir -p "$LAUNCHAGENTS_DIR"
mkdir -p "$LOGS_DIR"

# Copy scheduler + listener scripts
cp run-agents-every-6h.sh "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/run-agents-every-6h.sh"
echo "✅ Scheduler script installed"

cp start-listener.sh "$INSTALL_DIR/music-releases-agent/"
chmod +x "$INSTALL_DIR/music-releases-agent/start-listener.sh"
echo "✅ Music listener script installed"

# Install all 3 LaunchAgents
for plist in com.agents.every6h.plist com.ai-news-agent.listener.plist com.bots.music-listener.plist; do
  cp "$plist" "$LAUNCHAGENTS_DIR/"
  launchctl bootout "gui/$(id -u)/$(basename $plist .plist)" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$LAUNCHAGENTS_DIR/$plist"
  echo "✅ $plist loaded"
done

echo ""
echo "Checking status..."
launchctl list | grep -E "every6h|ai-news|music"

echo ""
echo "⚠️  REQUIRED: System Settings → Privacy & Security → Full Disk Access → + → /bin/bash"
echo "   (Without this, the 6h scheduler will fail with exit 126)"
echo ""
echo "Logs:"
echo "  Scheduler:    $INSTALL_DIR/scheduler-logs/scheduler.log"
echo "  AI news bot:  $INSTALL_DIR/ai-news-agent/logs/agent.log"
echo "  Music bot:    $LOGS_DIR/music-bot.log"
