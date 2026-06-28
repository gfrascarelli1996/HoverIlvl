# HoverIlvl

Shows the item level of other players directly in the tooltip when you hover over them.

## Features

- Adds an `Item Level: NNN` line to the player tooltip
- Number is colored by quality relative to your own item level (orange = higher, purple = on par, blue/green/white = lower)
- Persistent cache (default 7 days): known players' ilvl shows instantly, no extra inspect needed
- Optional floating group/raid panel, hidden by default — listed by class color with ilvl per member
- Settings panel + slash commands (`/hoverilvl`, `/hilvl`, `/hilvl show|hide|reset`)
- Uses the official client inspect system (`NotifyInspect` / `C_PaperDollInfo.GetInspectItemLevel`) with throttle/dedupe so the server isn't spammed
- Plays nice with other inspect-based addons (calls `ClearInspectPlayer` when done)
- Tooltip auto-refreshes as soon as inspect data arrives

## Installation

Via CurseForge / Wago / WowUp — search for **HoverIlvl**.

Manual: copy the `HoverIlvl` folder into `World of Warcraft\_retail_\Interface\AddOns\`.

## Limitations

These are client-side limits, not addon bugs:

- Only works on players in your faction/group, visible, and within inspect range
- The first hover on a player shows the ilvl after ~0.3–1s (server response time)
- Does not work on enemies in arenas (Blizzard blocks `CanInspect`)

## Supported version

Retail — Midnight (Interface 12.0.7+).

## License

MIT. See [LICENSE](LICENSE).

## Support development

HoverIlvl is free and always will be. If it saves you time and you want to say thanks, a coffee is appreciated:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/hadorn96)
