#!/bin/bash
# sync.sh — push all repos + memory to GitHub
# Usage: bash sync.sh "commit message"
# Or just: bash sync.sh  (uses auto timestamp message)

set -e

BASE="$HOME/Documents/claude-code"
MEMORY_SRC="$HOME/.claude/projects/-Users-shaharhalperin-claude-code/memory"
MSG="${1:-sync: $(date '+%Y-%m-%d %H:%M')}"

push_repo() {
  local dir="$1"
  local name="$(basename $dir)"
  cd "$dir"
  if [[ -n "$(git status --porcelain)" ]]; then
    git add -A
    git commit -m "$MSG"
    git push origin main
    echo "✅ $name pushed"
  else
    echo "— $name nothing to push"
  fi
}

# Sync memory files into scheduler repo first
if [ -d "$MEMORY_SRC" ]; then
  mkdir -p "$BASE/claude-code-scheduler/memory"
  cp "$MEMORY_SRC"/*.md "$BASE/claude-code-scheduler/memory/" 2>/dev/null || true
fi

# Push all repos
push_repo "$BASE/ai-news-agent"
push_repo "$BASE/music-releases-agent"
push_repo "$BASE/claude-code-scheduler"

echo ""
echo "Done. All repos synced to GitHub."
