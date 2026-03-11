# Claude Code Scheduler — Claude Context

## What This Is
macOS LaunchAgent + shell script that runs both Telegram bots every 6 hours.
This repo exists so the scheduler config survives machine migration.

## Files
- `run-agents-every-6h.sh` — runs ai-news-agent and music-releases-agent in parallel
- `com.agents.every6h.plist` — macOS LaunchAgent definition (installed at ~/Library/LaunchAgents/)
- `install.sh` — one-command setup for a new machine

## Schedule
Fires at **00:00, 06:00, 12:00, 18:00 Israel time** (Asia/Jerusalem).
LaunchAgent uses local system time — Mac must be set to Israel timezone.

## Install on a New Machine
```bash
git clone https://github.com/checkmate9/claude-code-scheduler.git
cd claude-code-scheduler
bash install.sh
```

## Manual Install Steps
```bash
# 1. Copy scheduler script
cp run-agents-every-6h.sh ~/Documents/claude-code/
chmod +x ~/Documents/claude-code/run-agents-every-6h.sh

# 2. Install LaunchAgent
cp com.agents.every6h.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.agents.every6h.plist

# 3. Verify
launchctl list | grep every6h
# Should show: - 0 com.agents.every6h (0 = success, not 126)
```

## macOS Full Disk Access (REQUIRED after migration)
LaunchAgent can't access ~/Documents without this:
> System Settings → Privacy & Security → Full Disk Access → + → /bin/bash

Without this, launchctl shows exit code 126.

## Check Status
```bash
launchctl list | grep every6h
tail -f ~/Documents/claude-code/scheduler-logs/scheduler.log
tail -f ~/Documents/claude-code/scheduler-logs/launch-agent-error.log
```

## Related Repos
- https://github.com/checkmate9/ai-news-agent
- https://github.com/checkmate9/music-releases-agent
