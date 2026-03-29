---
name: Music Releases Agent
description: Full details for the music-releases-agent Telegram bot — architecture, paths, scheduler, genres, known issues
type: project
---

# Music Releases Agent

**Repo:** https://github.com/checkmate9/music-releases-agent
**Location:** `~/Documents/claude-code/music-releases-agent/`
**Language:** Node.js (zero deps, `/opt/homebrew/bin/node`)

## What it does
Fetches new Spotify/Metacritic/Pitchfork releases → filters by genre via MusicBrainz → sends Telegram digest with streaming links and Metacritic scores.

## Entry Points
- One-shot run: `cd ~/Documents/claude-code/music-releases-agent && node index.js`
- Persistent (Telegram listener + internal scheduler): `node bot.js`
- Via wrapper (prevents crashes losing the process): `start-listener.sh`

## Scheduler
- Internal scheduler inside `bot.js` fires at 00:00, 06:00, 12:00, 18:00 **Israel time**
- Does NOT use the external `run-agents-every-6h.sh` — that was causing duplicate sends
- `bot.js` sends "nothing to send" + genre hints when no matches found

## Telegram Commands
- `/runnow` — trigger release check immediately
- Replies with digest if matches found, or `🔍 Done — Genre-matched: 0` + genre hints if not

## Genre Hints Feature
When no releases match, bot shows other genres found in MusicBrainz lookups:
`💡 Other genres found: electronic, pop, hip-hop...`
→ Use this to decide what to add to `genres.json`

## Key Files
- `index.js` — one-shot scraper: fetches Metacritic + Pitchfork, MusicBrainz genre lookup, Spotify/Apple Music links, sends digest
- `bot.js` — persistent Telegram listener + internal scheduler; spawns index.js via `/bin/bash` (for FDA)
- `start-listener.sh` — while-true wrapper around bot.js with PID lock (prevents multiple instances)
- `genres.json` — list of genres to match against (edit here to add/remove genres)
- `seen_releases.json` — deduplication store
- `bot.pid` — PID lock file for start-listener.sh (gitignored)

## Current Genres (genres.json)
indie, indie rock, indie folk, indie pop, dream pop, shoegaze, singer-songwriter, folk rock, rock, progressive, indie israeli, contemporary jazz, alternative, americana

## Persistent Listener LaunchAgent
- Plist: `com.bots.music-listener.plist` → `~/Library/LaunchAgents/`
- Runs `start-listener.sh` at boot
- Start manually: `nohup /bin/bash ~/Documents/claude-code/music-releases-agent/start-listener.sh >> ~/claude-code/logs/music-bot.log 2>&1 &`
- Log (temporary location): `~/claude-code/logs/music-bot.log`

## FDA Workaround
`bot.js` spawns `index.js` via `/bin/bash -c "node index.js"` instead of calling node directly.
**Why:** node process started by LaunchAgent lacks Full Disk Access for ~/Documents. bash has FDA.
Once `/opt/homebrew/bin/node` gets FDA in System Settings, can revert to direct `execFile(node, [index.js])`.

## Duplicate Send Fix
`run-agents-every-6h.sh` no longer runs `index.js` — bot.js internal scheduler handles it.
Previously both fired at the same hours → duplicate digests.

## Secrets (.env — never committed)
- `SPOTIFY_CLIENT_ID`, `SPOTIFY_CLIENT_SECRET`, `SPOTIFY_REFRESH_TOKEN`
- `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`
- Backed up: `~/Downloads/secrets_*.tar.gz` + Google Drive
