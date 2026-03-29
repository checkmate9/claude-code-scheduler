---
name: AI News Agent
description: Full details for the ai-news-agent Telegram bot — architecture, paths, scheduler, dashboard, known issues
type: project
---

# AI News Agent

**Repo:** https://github.com/checkmate9/ai-news-agent
**Location:** `~/Documents/claude-code/ai-news-agent/`
**Language:** Python 3 (system python: `/usr/bin/python3`)

## What it does
Scrapes AI news (RSS feeds, Reddit, HN) → summarizes with Claude Haiku → sends Telegram digest.

## Entry Points
- One-shot run: `cd ~/Documents/claude-code/ai-news-agent && python3 main.py --run-now`
- Persistent (Telegram listener + APScheduler): `PYTHON=/usr/bin/python3 ./agent.sh start`
- Dashboard: http://localhost:3010 (runs `dashboard.py` on port 3010)

## Scheduler
- Built-in APScheduler inside the persistent `main.py` fires at 08:00 + 18:00 NY time
- Overridden at boot by `com.agents.every6h.plist` LaunchAgent which calls `main.py --run-now`
- External scheduler (run-agents-every-6h.sh) handles only ai-news — music bot has its own internal scheduler

## Telegram Commands
- `/runnow` — trigger digest immediately
- `/links` — send top 3 trending links from last digest
- `/help` — list commands

## Key Files
- `main.py` — entry point, Telegram polling, APScheduler
- `scraper.py` — RSS/Reddit/HN fetching, writes `source_status.json`
- `summarizer.py` — Claude Haiku summarization
- `telegram_bot.py` — sends digest messages
- `dashboard.py` — Flask web dashboard on port 3010
- `agent.sh` — start/stop/status helper script
- `config.py` — loads .env, schedule times, timezone
- `logs/agent.log` — live log
- `logs/activity.json` — digest run history (read by dashboard)
- `logs/agent.pid` — PID of running main.py (read by dashboard)
- `logs/source_status.json` — per-source fetch results (read by dashboard)

## State Files — FDA Workaround
LaunchAgent-spawned Python lacks Full Disk Access for ~/Documents. Until FDA is granted to `/usr/bin/python3`:
- `latest_links.json` lives at `~/claude-code/logs/latest_links.json` (readable without FDA)
**Why:** How to apply: once FDA granted to python3, move back to `logs/latest_links.json` in agent dir

## Persistent Listener LaunchAgent
- Plist: `com.ai-news-agent.listener.plist` → `~/Library/LaunchAgents/`
- Runs `agent.sh start` at boot (KeepAlive: false — does not restart on crash)
- Start manually: `cd ~/Documents/claude-code/ai-news-agent && PYTHON=/usr/bin/python3 ./agent.sh start`
- PID file: `logs/agent.pid`

## Secrets (.env — never committed)
- `ANTHROPIC_API_KEY`
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`
- Reddit credentials (REDDIT_CLIENT_ID, REDDIT_CLIENT_SECRET, REDDIT_USERNAME, REDDIT_PASSWORD)
- Backed up: `~/Downloads/secrets_*.tar.gz` + Google Drive
