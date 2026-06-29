# Changelog

## 1.2.0

- New minimap button: left-click toggles the group/raid panel, right-click opens the settings. Drag to move around the minimap. Hideable from the settings panel.

## 1.1.4

- Translate remaining Italian release notes (1.0.0) to English for consistency

## 1.1.3

- Add Ko-fi support button to README (donations are voluntary; addon stays free and fully functional)

## 1.1.2

- Fix Lua error in dungeons/raids when hovering hostile NPCs whose GUID is a "secret string value" (guard the player-prefix check with pcall and bail out on the secret case)

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

- First release
- Shows other players' item level in the tooltip on hover
- 120s cache and inspect dedupe to avoid spamming the server
