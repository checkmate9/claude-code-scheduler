---
name: whoop-dashboard
description: Personal WHOOP health dashboard — full project context, stack, features, and run instructions
type: project
---

## Whoop Dashboard

**Path:** `~/Documents/claude-code/whoop-dashboard`
**Repo:** https://github.com/checkmate9/whoop-dashboard (private)
**Start:** `cd ~/Documents/claude-code/whoop-dashboard && node server.js` → http://localhost:3000
**Dev:** `npm run dev` (nodemon auto-reload)
**Port:** 3000

---

## Stack
- **Backend:** Node.js + Express
- **Database:** SQLite via `better-sqlite3` (data/whoop.db)
- **AI:** Anthropic SDK — `claude-sonnet-4-6` for AI Trainer
- **Frontend:** Vanilla JS + Chart.js, no framework
- **Other:** `node-cron` (daily 08:30 sync), `axios`, `dotenv`

---

## Key Files
- `server.js` — all routes + AI Trainer logic
- `lib/db.js` — DB schema + all queries
- `lib/sync.js` — WHOOP API sync
- `lib/whoop.js` — OAuth + API calls
- `public/index.html` — entire frontend (CSS + JS inline)
- `.env` — secrets (gitignored)

---

## Features / Tabs
1. **Today** — metric tiles (recovery, sleep, strain, RHR, weight) + 4 charts
2. **Recovery** — 90-day recovery, RHR, HRV charts
3. **Sleep** — 90-day sleep perf, duration, last-night stages doughnut
4. **Workouts** — strain timeline + weekly workout frequency bar
5. **Nutrition** — calories in vs burn, weight trend, adjusted BMI chart
6. **Log Entry** — daily log (meals, weight, calories, notes) + history table
7. **Insights** — auto-generated bullet insights + **30-day vs prev-30 comparison cards**
8. **AI Trainer** — auto-loads daily brief on tab open, full chat, trainer log feedback loop

---

## AI Trainer Details
- **Model:** `claude-sonnet-4-6`, max_tokens: 2048
- **Brief endpoint:** `POST /api/trainer-brief` — generates today + 3-day plan, cached per day in DB
- **Chat endpoint:** `POST /api/coach`
- **Trainer log:** `POST/GET /api/trainer-log` — saves what was recommended vs what user did
- **Feedback loop:** last 14 days of trainer_log fed into system prompt so AI adapts

## User Context (fed into every AI Trainer call)
- Age: 51, right leg **above-knee** (transfemoral) amputee
- Observed weight: 76 kg → Adjusted weight (Osterkamp 1995): ~90.5 kg
- BMI formula: `weight / 0.84 / height²` (AKA = 16% body weight)
- TDEE ~2,700 kcal/day (moderate), protein target 145–200 g/day
- Priority muscles: gluteus medius > glute max > hip flexors > core > intact limb
- CVD risk ~1.5–2x elevated

---

## DB Tables
- `recovery` — WHOOP cycle data (HRV, RHR, recovery score, SpO2, skin temp)
- `sleep` — sleep stages, performance, duration
- `workouts` — strain, HR, kilojoules
- `body` — height, weight, max HR
- `profile` — name, email
- `manual_log` — daily meals, weight, calories, notes
- `trainer_log` — AI recommendation vs actual activity per day
- `tokens` — WHOOP OAuth tokens
- `sync_log` — sync history

---

## Design
- **Font:** Inter (Google Fonts)
- **Palette:** Windward.ai — navy `#021953`, orange `#ff6f00`, off-white `#faf7f4`
- **Cards:** white `#fff`, `border-radius: 16px`, subtle shadow
- **CTA buttons:** orange pill `border-radius: 9999px`
- **Nav:** orange underline active tab

---

## Setup Notes
- `.env` needs: `WHOOP_CLIENT_ID`, `WHOOP_CLIENT_SECRET`, `WHOOP_REDIRECT_URI`, `ANTHROPIC_API_KEY`, `PORT`
- Use `dotenv.config({ override: true })` — Claude Code shell blanks out ANTHROPIC_API_KEY
- After Node upgrade: `npm install better-sqlite3@latest` + `xattr -d com.apple.provenance data/whoop.db`
- Daily sync cron: 08:30 (node-cron, local time)

**Why:** Built with coworker (~Feb 22 2026) to sync and visualise WHOOP health metrics locally, then extended with AI Trainer (Mar 2026).
