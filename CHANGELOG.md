# Changelog

## 1.1.1

- Fix Lua error "bad argument #1 to 'UnitIsPlayer'" when hovering hostile mobs or nameplates (filter by GUID instead, avoid touching the secure unit token)

## 1.1.0

- Persistent cache: known players' item levels survive logout/relog (configurable TTL, default 7 days)
- Item level number is now colored by quality relative to your own gear (orange = higher, purple = on par, blue/green/white = lower)
- New settings panel reachable from Interface options or via `/hoverilvl` (also `/hilvl`)
- Optional floating group/raid panel listing every member's item level, hidden by default — toggle from settings or `/hilvl show`
- Slash commands: `/hilvl` (open settings), `/hilvl show|hide` (toggle group panel), `/hilvl reset` (clear cache)

## 1.0.1

- Bumped Interface to 120007 (Midnight 12.0.7) — clears the "Incompatible" warning on current retail client

## 1.0.0

- Prima release
- Item level dei giocatori nel tooltip al passaggio del cursore
- Cache 120s e dedupe inspect per non sovraccaricare il server
