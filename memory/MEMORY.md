# Claude Memory — shahar halperin (Mac Mini)

## User
- GitHub: checkmate9 / checkmate9@gmail.com
- Mac Mini, Israel timezone (Asia/Jerusalem)
- Working dir for Claude sessions: ~/claude-code

## Telegram Bots — ~/Documents/claude-code/

### ai-news-agent (Python)
- Scrapes AI news (RSS, Reddit, HN) → summarizes with Claude Haiku → sends Telegram digest
- Entry: `main.py --run-now` | Persistent: `./agent.sh start`
- Dashboard: http://localhost:3010
- Schedule: built-in APScheduler (08:00 + 18:00 NY time by default, overridden by master LaunchAgent)
- Repo: https://github.com/checkmate9/ai-news-agent
- Has CLAUDE.md ✅

### music-releases-agent (Node.js, zero deps)
- Fetches new Spotify releases → filters by genre → sends Telegram digest
- Entry: `node index.js` (one-shot) | Persistent: `node bot.js`
- Genres configured in: `genres.json`
- Repo: https://github.com/checkmate9/music-releases-agent
- Has CLAUDE.md ✅ (added 2026-03-11)

### Scheduler
- macOS LaunchAgent: `~/Library/LaunchAgents/com.agents.every6h.plist`
- Fires at: 00:00, 06:00, 12:00, 18:00 **Israel time** (local system time)
- Script: `~/Documents/claude-code/run-agents-every-6h.sh`
- Uses full paths: PYTHON=/usr/bin/python3, NODE=/opt/homebrew/bin/node
- macOS has no `timeout` — uses background kill pattern instead
- Repo: https://github.com/checkmate9/claude-code-scheduler
- Logs: `~/Documents/claude-code/scheduler-logs/`

### Persistent Listeners (for /links and /runnow)
- AI news: `com.ai-news-agent.listener.plist` → runs `agent.sh start` at boot
  - PID tracked in: `~/Documents/claude-code/ai-news-agent/logs/agent.pid`
  - Start manually: `cd ~/Documents/claude-code/ai-news-agent && PYTHON=/usr/bin/python3 ./agent.sh start`
- Music bot: `com.bots.music-listener.plist` → runs `start-listener.sh` (while-true wrapper around bot.js)
  - Log: `~/claude-code/logs/music-bot.log`
  - Start manually: `nohup /opt/homebrew/bin/node ~/Documents/claude-code/music-releases-agent/bot.js &`

### LaunchAgent Log Paths
- LaunchAgent stdout/stderr must NOT point to ~/Documents/ — causes exit 78 (no Full Disk Access for log writes)
- Safe log path: `~/claude-code/logs/` (outside Documents)
- Scheduler logs (written by bash which has FDA): `~/Documents/claude-code/scheduler-logs/`

### Known Issue: LaunchAgent Exit 126
macOS blocks launchd from ~/Documents without Full Disk Access for /bin/bash.
Fix: System Settings → Privacy & Security → Full Disk Access → + → /bin/bash
Already granted on this Mac Mini ✅

## Migration to New Machine
1. `git clone https://github.com/checkmate9/ai-news-agent`
2. `git clone https://github.com/checkmate9/music-releases-agent`
3. `git clone https://github.com/checkmate9/claude-code-scheduler && bash claude-code-scheduler/install.sh`
4. Extract secrets from `secrets_*.tar.gz` into each agent folder
5. Grant Full Disk Access to /bin/bash

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
