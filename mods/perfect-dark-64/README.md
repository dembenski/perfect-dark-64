# Perfect Dark 64 — Lua mod

Perfect Dark characters and weapons in Mario 64, on PC. Fan-made mod built on the sm64coopdx engine.

**Code only — bring your own SM64 ROM.** No Nintendo or Rare/Microsoft files anywhere. Weapon models and sounds are made fresh (Blender / new recordings) — nothing copied from the Perfect Dark ROM. Unofficial fan project, not affiliated with Nintendo, Rare, or Microsoft.

## Controls

- **B** — fire
- **C-buttons / D-pad** — switch weapon (all 43 in the data table; special behaviours land weapon by weapon)
- **Z (hold)** — aim (first-person; scoped weapons zoom)
- **R** — reload

## Status — v1, Falcon 2 first

- `main.lua` — input, weapon switching, reload, aim
- `pd64_data.lua` — all 43 weapons (35 Perfect Dark core + 8 GoldenEye classics)
- `pd64_fire.lua` — hitscan ray + cone check vs soldiers, headshot ×2, tracers
- `pd64_hud.lua` — crosshair, weapon name, ammo, reload, FarSight markers
- `pd64_enemies.lua` — dataDyne soldier (replaces Goomba, 100 HP)
- `pd64_joanna.lua` — Joanna Dark model swap (no-op until `actors/joanna_geo/` exists)

What works first: Falcon 2 fires, soldiers die (4 body shots / 2 headshots), HUD ammo counts down. The other 42 weapons are data rows until their behaviour files land (MagSec 4 burst → CMP-150 auto → Shotgun pellets → Sniper scope, then projectiles, then the exotics).

## Known limits (v1)

- No visible gun in Mario's hand yet, no reload animation, soldiers don't shoot back yet (they walk at you and touch-damage), no dual-wield, no ammo pickups yet.
- Weapon models/sounds are data, not code — they get built fresh in Blender; v1 ships with placeholder sounds.
- Vanilla enemies outside the Goomba replacement are bulletproof until their behaviour is hooked too.
