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

  echo "[$TIMESTAMP] Running music-releases-agent..."
  cd "$INSTALL_DIR/music-releases-agent"
  # macOS has no `timeout` — use background job + manual kill after 300s
  $NODE index.js 2>&1 &
  MUSIC_PID=$!
  ( sleep 300 && kill $MUSIC_PID 2>/dev/null ) &
  KILLER_PID=$!

  wait $AI_PID 2>/dev/null
  echo "[$TIMESTAMP] AI News Agent completed"

  wait $MUSIC_PID 2>/dev/null
  echo "[$TIMESTAMP] Music Agent completed"
  kill $KILLER_PID 2>/dev/null  # cancel the timeout killer if music finished early

  echo "[$TIMESTAMP] ====== Both agents completed ======"
} | tee -a "$LOG_DIR/scheduler.log"
