# HoverIlvl

Shows the item level of other players directly in the tooltip when you hover over them.

## Features

- Adds an `Item Level: NNN` line to the player tooltip
- Uses the official client inspect system (`NotifyInspect` / `C_PaperDollInfo.GetInspectItemLevel`)
- 120-second cache so the server is not flooded with inspect requests
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

Retail — The War Within (Interface 11.0.2+).

## License

MIT. See [LICENSE](LICENSE).
