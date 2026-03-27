---
name: whoop-dashboard
description: Whoop health data dashboard project built with coworker around Feb 2026
type: project
---

Node.js/Express dashboard for personal Whoop health data.

**Path:** `~/Documents/claude-code/whoop-dashboard`
**Start:** `npm start` (port 3000)
**Dev:** `npm run dev` (nodemon)

**Stack:** Node.js + Express, SQLite (better-sqlite3), Anthropic SDK, node-cron, axios, dotenv
**DB:** `data/whoop.db`
**Frontend:** `dashboard.html` + `public/` dir

**Key lib files:** `lib/db.js`, `lib/sync.js`, `lib/whoop.js`
**Auth:** WHOOP OAuth (reads profile, body measurements, cycles, recovery)
**Control scripts:** `start.command`, `stop.command`

**Why:** Built with coworker (~Feb 22 2026) to sync and visualize Whoop health metrics locally.
**How to apply:** When user wants to continue building this, cd to the path above, start with `npm start`, open http://localhost:3000.

**Migration fix (2026-03-27):**
- Upgraded `better-sqlite3` to latest (v9.6.0 → v11+) for Node 25 compatibility
- Removed `com.apple.provenance` xattr from `data/whoop.db` that caused disk I/O error: `xattr -d com.apple.provenance data/whoop.db`
