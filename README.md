# HoverIlvl

> Hover any player. See their item level instantly in the tooltip.

A lightweight addon for **World of Warcraft Retail (Midnight)** that adds a colored `Item Level` line to player tooltips, with a persistent cache so known players show up with zero delay.

---

## Features

- **Tooltip ilvl on hover** — a colored `Item Level: NNN` line is added to any player's tooltip
- **Quality-colored** — the number is colored relative to your own ilvl: orange (much higher), purple (on par), blue/green/white (lower)
- **Persistent cache** — known players' item levels survive logout/relog (default 7 days, configurable)
- **Optional group/raid panel** — floating list of every party/raid member with their ilvl. Hidden by default, class-colored, draggable, lockable
- **Minimap button** — left-click to toggle the group/raid panel, right-click to open settings. Draggable, hideable
- **Settings panel** — integrated into Interface options, also reachable via slash commands
- **Server-friendly** — throttled inspect with dedupe and round-robin polling, calls `ClearInspectPlayer` so it plays nice with other inspect addons (Examiner, InspectEquip, …)

## Slash commands

```
/hoverilvl       Open the settings panel
/hilvl           Same (short alias)
/hilvl show      Show the group/raid panel
/hilvl hide      Hide the group/raid panel
/hilvl reset     Clear the cached item levels
```

## Color scale

The ilvl number is colored by the difference against your own item level:

| Difference | Color |
|---|---|
| `+10` or more | Orange (legendary) |
| `0` to `+9` | Purple (epic) |
| `-1` to `-10` | Blue (rare) |
| `-11` to `-20` | Green (uncommon) |
| `-21` or less | White (common) |

## Installation

- **CurseForge / WowUp / Wago** — search for **HoverIlvl** (recommended)
- **Manual** — copy the `HoverIlvl` folder into `World of Warcraft\_retail_\Interface\AddOns\`

## Limitations

These are client-side limits, not addon bugs:

| Limit | Reason |
|---|---|
| Only same-faction / same-group players | Blizzard's `CanInspect` blocks the rest |
| ~0.3–1 s on the first hover | Server inspect roundtrip |
| No data in arenas vs. enemies | `CanInspect` is disabled |
| Hostile NPCs in dungeons skipped | Their GUID is hidden by anti-cheat (graceful no-op) |

## Supported version

Retail — **Midnight** (Interface 12.0.7+).

## Source & issues

GitHub: <https://github.com/gfrascarelli1996/HoverIlvl>
Open an issue if you find a bug or want to suggest a feature.

## License

MIT — free to fork, modify, redistribute. See [LICENSE](LICENSE).

---

## Support development

HoverIlvl is free and always will be. If it saves you time and you want to say thanks, a coffee is appreciated:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/hadorn96)
