#!/bin/bash
# Explicit paths for LaunchAgent environment (no Homebrew PATH by default)
PYTHON="/usr/bin/python3"
NODE="/opt/homebrew/bin/node"
INSTALL_DIR="$HOME/Documents/claude-code"
LOG_DIR="$INSTALL_DIR/scheduler-logs"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
{
  echo "[$TIMESTAMP] ====== Starting agents run ======"

  echo "[$TIMESTAMP] Running ai-news-agent..."
  cd "$INSTALL_DIR/ai-news-agent"
  $PYTHON main.py --run-now 2>&1 &
  AI_PID=$!

  # music-releases-agent is scheduled internally by bot.js — skipped here to avoid duplicate sends

  wait $AI_PID 2>/dev/null
  echo "[$TIMESTAMP] AI News Agent completed"

  echo "[$TIMESTAMP] ====== Agents run complete ======"
} | tee -a "$LOG_DIR/scheduler.log"
