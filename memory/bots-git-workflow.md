# Git Workflow — Bug Fixes & Feature Development

## Repos
- ai-news-agent: ~/Documents/claude-code/ai-news-agent
- music-releases-agent: ~/Documents/claude-code/music-releases-agent
- scheduler: ~/Documents/claude-code/claude-code-scheduler

## Fix a Bug

```bash
cd ~/Documents/claude-code/ai-news-agent  # or music-releases-agent

# 1. Make sure you're up to date
git pull origin main

# 2. Fix the code (Claude Code or manually)

# 3. Test it
python3 main.py --run-now          # ai-news-agent
node index.js                      # music-releases-agent

# 4. Commit and push
git add -p                         # review changes interactively
git commit -m "fix: describe what was broken"
git push origin main
```

## Develop a Feature

```bash
# 1. Create a feature branch
git checkout -b feat/my-new-feature

# 2. Develop + test iteratively

# 3. When done, merge to main
git checkout main
git merge feat/my-new-feature
git push origin main
git branch -d feat/my-new-feature
```

## Keep Everything in Sync

After ANY change to code:
```bash
git add . && git commit -m "..." && git push origin main
```

After changing scheduler script or plist:
```bash
cd ~/Documents/claude-code/claude-code-scheduler
cp ../run-agents-every-6h.sh .
cp ~/Library/LaunchAgents/com.agents.every6h.plist .
git add . && git commit -m "chore: update scheduler" && git push origin main
```

After changing secrets (.env, genres.json):
```bash
# Re-pack secrets backup
mkdir -p /tmp/secrets-pack/ai-news-agent-secrets-temp
mkdir -p /tmp/secrets-pack/music-releases-agent-secrets-temp
cp ~/Documents/claude-code/ai-news-agent/.env /tmp/secrets-pack/ai-news-agent-secrets-temp/
cp ~/Documents/claude-code/music-releases-agent/.env /tmp/secrets-pack/music-releases-agent-secrets-temp/
cp ~/Documents/claude-code/music-releases-agent/genres.json /tmp/secrets-pack/music-releases-agent-secrets-temp/
cd /tmp && tar -czf ~/Desktop/secrets_$(date +%Y%m%d_%H%M%S).tar.gz -C secrets-pack .
rm -rf /tmp/secrets-pack
# Upload the .tar.gz to Google Drive
```

## Check Logs After Push
```bash
tail -f ~/Documents/claude-code/scheduler-logs/scheduler.log
tail -f ~/Documents/claude-code/ai-news-agent/logs/agent.log
```
