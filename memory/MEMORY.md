# Claude Memory — shahar halperin (Mac Mini)

## User
- GitHub: checkmate9 / checkmate9@gmail.com
- Mac Mini, Israel timezone (Asia/Jerusalem)
- Working dir for Claude sessions: ~/claude-code

## Telegram Bots — ~/Documents/claude-code/

- [project_ai_news_agent.md](project_ai_news_agent.md) — Python bot, AI news digest, dashboard on :3010
- [project_music_releases_agent.md](project_music_releases_agent.md) — Node.js bot, Spotify releases filtered by genre

### Scheduler (shared)
- macOS LaunchAgent: `~/Library/LaunchAgents/com.agents.every6h.plist`
- Fires at: 00:00, 06:00, 12:00, 18:00 **Israel time**
- Script: `~/Documents/claude-code/run-agents-every-6h.sh` (ai-news only — music has internal scheduler)
- Repo: https://github.com/checkmate9/claude-code-scheduler
- Logs: `~/Documents/claude-code/scheduler-logs/`

### Full Disk Access — Required Binaries
System Settings → Privacy & Security → Full Disk Access:
- `/bin/bash` ✅
- `/usr/bin/python3` ⚠️ PENDING — needed for dashboard.py / main.py via LaunchAgent
- `/opt/homebrew/bin/node` ⚠️ PENDING — needed for bot.js / index.js via LaunchAgent
- Until granted: workarounds in place (files in `~/claude-code/logs/`, bash-wrapper spawn)
- **Once granted: revert all workarounds, move all files back to ~/Documents/claude-code/**

### Known Issue: LaunchAgent Exit 126
Fix: Full Disk Access → `/bin/bash` ✅ already granted on this Mac Mini

## Migration to New Machine
1. `git clone https://github.com/checkmate9/ai-news-agent`
2. `git clone https://github.com/checkmate9/music-releases-agent`
3. `git clone https://github.com/checkmate9/claude-code-scheduler && bash claude-code-scheduler/install.sh`
4. Extract secrets from `secrets_*.tar.gz` into each agent folder
5. Grant Full Disk Access to: /bin/bash, /usr/bin/python3, /opt/homebrew/bin/node

## Whoop Dashboard
- [project_whoop_dashboard.md](project_whoop_dashboard.md) — Node.js/Express Whoop health dashboard at ~/Documents/claude-code/whoop-dashboard

## Git Workflow
- git user: checkmate9 / checkmate9@gmail.com
- Auth: GitHub PAT stored in macOS Keychain (NOT in remote URLs)
- Update PAT: `printf "protocol=https\nhost=github.com\nusername=checkmate9\npassword=NEW_PAT\n" | git credential-osxkeychain store`
- **After every fix or feature: run `bash ~/sync-bots "message"` automatically — don't wait for user to ask**
- sync-bots pushes all 3 repos + memory files in one command
- See bots-git-workflow.md for full workflow

## Secrets / .env
- Never committed — gitignored in both repos
- Backed up as `~/Downloads/secrets_*.tar.gz` (also upload to Google Drive for migration)
- ai-news-agent secrets: ANTHROPIC_API_KEY, TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID, Reddit creds
- music-releases-agent secrets: SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET, SPOTIFY_REFRESH_TOKEN, TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID
