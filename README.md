# HoverIlvl

Mostra l'item level dei giocatori direttamente nel tooltip quando ci passi sopra con il cursore.

## Funzionalità

- Aggiunge una riga `Item Level: NNN` al tooltip dei giocatori
- Usa il sistema di inspect ufficiale del client (`NotifyInspect` / `C_PaperDollInfo.GetInspectItemLevel`)
- Cache da 120 secondi per non sovraccaricare il server con richieste di inspect
- Compatibile con altri addon che usano l'inspect (chiama `ClearInspectPlayer` al termine)
- Tooltip si auto-aggiorna quando i dati di inspect arrivano

## Installazione

Tramite CurseForge / Wago / WowUp — cerca **HoverIlvl**.

Manuale: copia la cartella `HoverIlvl` in `World of Warcraft\_retail_\Interface\AddOns\`.

## Limiti

- Funziona solo su player nella stessa fazione/gruppo, visibili e in range di inspect (limite del client, non dell'addon)
- Il primo hover su un player mostra l'ilvl dopo ~0.3–1s (tempo di risposta del server)
- Non funziona su nemici in arena (Blizzard blocca `CanInspect`)

## Versione supportata

Retail — The War Within (Interface 11.0.2+).

## Licenza

MIT. Vedi [LICENSE](LICENSE).
