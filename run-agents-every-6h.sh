#!/bin/bash
INSTALL_DIR="$HOME/Documents/claude-code"
LOG_DIR="$INSTALL_DIR/scheduler-logs"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
{
  echo "[$TIMESTAMP] ====== Starting agents run ======"
  echo "[$TIMESTAMP] Running ai-news-agent..."
  cd "$INSTALL_DIR/ai-news-agent"
  python3 main.py --run-now 2>&1 &
  AI_PID=$!
  echo "[$TIMESTAMP] Running music-releases-agent..."
  cd "$INSTALL_DIR/music-releases-agent"
  timeout 300 node index.js 2>&1 &
  MUSIC_PID=$!
  wait $AI_PID 2>/dev/null || echo "[$TIMESTAMP] AI News Agent completed"
  wait $MUSIC_PID 2>/dev/null || echo "[$TIMESTAMP] Music Agent completed"
  echo "[$TIMESTAMP] ====== Both agents completed ======"
} | tee -a "$LOG_DIR/scheduler.log"
