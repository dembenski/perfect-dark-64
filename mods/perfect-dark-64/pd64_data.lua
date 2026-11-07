-- Perfect Dark 64 — weapon data + shared player state.
-- One row per weapon. Fields the fire code reads:
--   id, name, pool (ammo pool), magSize, reserveMax, damage (mod HP),
--   fireInterval (frames between shots), autoFire (bool), range (SM64 units),
--   spread (radians of cone half-angle; TUNE in-game), reloadTime (frames),
--   scope (bool: Z-aim zooms), silent (bool: no soldier alert).
-- Stats: ✅ = verified against the Perfect Dark weapons guides (Neoseeker);
-- ~ = approximate, verify in-game. See pd64-weapons-v1-draft.md Part 2.

WEAPONS = {
    -- Pistols (switch 1-8)
    { id = 1,  name = "Falcon 2",           pool = "pistol",    magSize = 8,   reserveMax = 800, damage = 25,  fireInterval = 8,  autoFire = false, range = 3500, spread = 0.02, reloadTime = 60,  scope = false, silent = false },
    { id = 2,  name = "Falcon 2 Silenced",  pool = "pistol",    magSize = 8,   reserveMax = 800, damage = 22,  fireInterval = 8,  autoFire = false, range = 3000, spread = 0.02, reloadTime = 60,  scope = false, silent = true  },
    { id = 3,  name = "Falcon 2 Scoped",    pool = "pistol",    magSize = 8,   reserveMax = 800, damage = 25,  fireInterval = 8,  autoFire = false, range = 5000, spread = 0.01, reloadTime = 60,  scope = true,  silent = false },
    { id = 4,  name = "MagSec 4",           pool = "pistol",    magSize = 9,   reserveMax = 800, damage = 30,  fireInterval = 8,  autoFire = false, range = 3500, spread = 0.02, reloadTime = 60,  scope = false, silent = false }, -- burst handled by magsec4.lua (later)
    { id = 5,  name = "Mauler",             pool = "pistol",    magSize = 20,  reserveMax = 800, damage = 35,  fireInterval = 10, autoFire = false, range = 3000, spread = 0.02, reloadTime = 60,  scope = false, silent = false }, -- charge handled by mauler.lua (later)
    { id = 6,  name = "Phoenix",            pool = "pistol",    magSize = 8,   reserveMax = 800, damage = 30,  fireInterval = 8,  autoFire = false, range = 3500, spread = 0.02, reloadTime = 60,  scope = false, silent = false },
    { id = 7,  name = "DY357 Magnum",       pool = "magnum",    magSize = 6,   reserveMax = 200, damage = 90,  fireInterval = 30, autoFire = false, range = 3500, spread = 0.02, reloadTime = 90,  scope = false, silent = false },
    { id = 8,  name = "DY357-LX",           pool = "magnum",    magSize = 6,   reserveMax = 200, damage = 200, fireInterval = 45, autoFire = false, range = 3500, spread = 0.02, reloadTime = 120, scope = false, silent = false },
    -- SMGs & rifles (switch 9-17)
    { id = 9,  name = "CMP-150",            pool = "smg",       magSize = 32,  reserveMax = 800, damage = 20,  fireInterval = 4,  autoFire = true,  range = 3000, spread = 0.05, reloadTime = 60,  scope = false, silent = false },
    { id = 10, name = "Cyclone",            pool = "smg",       magSize = 50,  reserveMax = 800, damage = 18,  fireInterval = 4,  autoFire = true,  range = 2500, spread = 0.06, reloadTime = 60,  scope = false, silent = false },
    { id = 11, name = "Callisto NTG",       pool = "rifle",     magSize = 20,  reserveMax = 400, damage = 35,  fireInterval = 5,  autoFire = true,  range = 5000, spread = 0.03, reloadTime = 60,  scope = true,  silent = false },
    { id = 12, name = "RC-P120",            pool = "smg",       magSize = 120, reserveMax = 800, damage = 20,  fireInterval = 3,  autoFire = true,  range = 3000, spread = 0.05, reloadTime = 90,  scope = false, silent = false },
    { id = 13, name = "Laptop Gun",         pool = "smg",       magSize = 50,  reserveMax = 800, damage = 20,  fireInterval = 4,  autoFire = true,  range = 3000, spread = 0.05, reloadTime = 60,  scope = false, silent = false },
    { id = 14, name = "Dragon",             pool = "rifle",     magSize = 30,  reserveMax = 400, damage = 30,  fireInterval = 5,  autoFire = true,  range = 5000, spread = 0.03, reloadTime = 60,  scope = false, silent = false },
    { id = 15, name = "K7 Avenger",         pool = "rifle",     magSize = 25,  reserveMax = 400, damage = 35,  fireInterval = 4,  autoFire = true,  range = 5000, spread = 0.03, reloadTime = 60,  scope = false, silent = false },
    { id = 16, name = "AR34",               pool = "rifle",     magSize = 30,  reserveMax = 400, damage = 32,  fireInterval = 5,  autoFire = true,  range = 5000, spread = 0.03, reloadTime = 60,  scope = false, silent = false },
    { id = 17, name = "SuperDragon",        pool = "rifle",     magSize = 30,  reserveMax = 400, damage = 30,  fireInterval = 5,  autoFire = true,  range = 5000, spread = 0.03, reloadTime = 60,  scope = false, silent = false },
    -- Heavy & sniper (switch 18-24)
    { id = 18, name = "Shotgun",            pool = "shotgun",   magSize = 9,   reserveMax = 100, damage = 12,  fireInterval = 40, autoFire = false, range = 900,  spread = 0.12, reloadTime = 90,  scope = false, silent = false }, -- 12 dmg per pellet x 8 pellets; pellets handled by shotgun.lua (later)
    { id = 19, name = "Reaper",             pool = "reaper",    magSize = 100, reserveMax = 800, damage = 15,  fireInterval = 3,  autoFire = true,  range = 3500, spread = 0.05, reloadTime = 90,  scope = false, silent = false },
    { id = 20, name = "Sniper Rifle",       pool = "rifle",     magSize = 8,   reserveMax = 400, damage = 100, fireInterval = 60, autoFire = false, range = 9000, spread = 0.01, reloadTime = 90,  scope = true,  silent = false },
    { id = 21, name = "FarSight XR-20",     pool = "rifle",     magSize = 8,   reserveMax = 400, damage = 100, fireInterval = 60, autoFire = false, range = 9000, spread = 0.01, reloadTime = 90,  scope = true,  silent = false },
    { id = 22, name = "Devastator",         pool = "grenadeRounds", magSize = 4, reserveMax = 40, damage = 150, fireInterval = 45, autoFire = false, range = 6000, spread = 0.03, reloadTime = 90, scope = false, silent = false },
    { id = 23, name = "Rocket Launcher",    pool = "rockets",   magSize = 1,   reserveMax = 3,   damage = 200, fireInterval = 60, autoFire = false, range = 6000, spread = 0.02, reloadTime = 90,  scope = false, silent = false },
    { id = 24, name = "Slayer",             pool = "rockets",   magSize = 1,   reserveMax = 3,   damage = 200, fireInterval = 60, autoFire = false, range = 6000, spread = 0.02, reloadTime = 90,  scope = false, silent = false },
    -- Melee, special & thrown (switch 25-35)
    { id = 25, name = "Combat Knife",       pool = "none",      magSize = 10,  reserveMax = 0,   damage = 50,  fireInterval = 60, autoFire = false, range = 200,  spread = 0.10, reloadTime = 0,   scope = false, silent = false }, -- melee cone + thrown knife; combatknife.lua (later)
    { id = 26, name = "Crossbow",           pool = "bolts",     magSize = 5,   reserveMax = 40,  damage = 60,  fireInterval = 45, autoFire = false, range = 4500, spread = 0.01, reloadTime = 90,  scope = true,  silent = true  },
    { id = 27, name = "Tranquilizer",       pool = "sedatives", magSize = 8,   reserveMax = 200, damage = 5,   fireInterval = 30, autoFire = false, range = 3000, spread = 0.02, reloadTime = 60,  scope = false, silent = true  },
    { id = 28, name = "Laser",              pool = "none",      magSize = 999, reserveMax = 999, damage = 10,  fireInterval = 30, autoFire = false, range = 4000, spread = 0.00, reloadTime = 0,   scope = false, silent = false }, -- infinite ammo
    { id = 29, name = "Grenade",            pool = "grenades",  magSize = 1,   reserveMax = 10,  damage = 150, fireInterval = 45, autoFire = false, range = 1500, spread = 0.02, reloadTime = 0,   scope = false, silent = false },
    { id = 30, name = "Timed Mine",         pool = "mines",     magSize = 1,   reserveMax = 10,  damage = 150, fireInterval = 30, autoFire = false, range = 0,    spread = 0.00, reloadTime = 0,   scope = false, silent = false },
    { id = 31, name = "Proximity Mine",     pool = "mines",     magSize = 1,   reserveMax = 10,  damage = 150, fireInterval = 30, autoFire = false, range = 0,    spread = 0.00, reloadTime = 0,   scope = false, silent = false },
    { id = 32, name = "Remote Mine",        pool = "mines",     magSize = 1,   reserveMax = 10,  damage = 150, fireInterval = 30, autoFire = false, range = 0,    spread = 0.00, reloadTime = 0,   scope = false, silent = false },
    { id = 33, name = "N-Bomb",             pool = "nbomb",     magSize = 1,   reserveMax = 1,   damage = 500, fireInterval = 60, autoFire = false, range = 0,    spread = 0.00, reloadTime = 0,   scope = false, silent = false },
    { id = 34, name = "Psychosis Gun",      pool = "psychosis", magSize = 5,   reserveMax = 20,  damage = 0,   fireInterval = 45, autoFire = false, range = 3000, spread = 0.02, reloadTime = 60,  scope = false, silent = false },
    { id = 35, name = "Unarmed",            pool = "none",      magSize = 0,   reserveMax = 0,   damage = 15,  fireInterval = 24, autoFire = true,  range = 200,  spread = 0.10, reloadTime = 0,   scope = false, silent = false },
    -- GoldenEye classics (switch 36-43) — all approximate, verify vs Perfect Dark X
    { id = 36, name = "PP9i",               pool = "pistol",    magSize = 12,  reserveMax = 800, damage = 25,  fireInterval = 8,  autoFire = false, range = 3000, spread = 0.02, reloadTime = 60,  scope = false, silent = true  },
    { id = 37, name = "CC13",               pool = "rifle",     magSize = 30,  reserveMax = 400, damage = 30,  fireInterval = 5,  autoFire = true,  range = 5000, spread = 0.03, reloadTime = 60,  scope = false, silent = false },
    { id = 38, name = "KL01313",            pool = "smg",       magSize = 30,  reserveMax = 800, damage = 20,  fireInterval = 4,  autoFire = true,  range = 3000, spread = 0.05, reloadTime = 60,  scope = false, silent = false },
    { id = 39, name = "KF7 Special",        pool = "rifle",     magSize = 30,  reserveMax = 400, damage = 30,  fireInterval = 4,  autoFire = true,  range = 5000, spread = 0.03, reloadTime = 60,  scope = false, silent = false },
    { id = 40, name = "ZZT (9mm)",          pool = "smg",       magSize = 32,  reserveMax = 800, damage = 20,  fireInterval = 4,  autoFire = true,  range = 3000, spread = 0.05, reloadTime = 60,  scope = false, silent = false },
    { id = 41, name = "DMC",                pool = "magnum",    magSize = 8,   reserveMax = 200, damage = 90,  fireInterval = 30, autoFire = false, range = 3500, spread = 0.02, reloadTime = 90,  scope = false, silent = false },
    { id = 42, name = "AR53",               pool = "rifle",     magSize = 30,  reserveMax = 400, damage = 32,  fireInterval = 5,  autoFire = true,  range = 5000, spread = 0.03, reloadTime = 60,  scope = false, silent = false }, -- origin unclear; verify vs PDX list before building
    { id = 43, name = "RC-P45",             pool = "smg",       magSize = 80,  reserveMax = 800, damage = 20,  fireInterval = 4,  autoFire = true,  range = 3000, spread = 0.06, reloadTime = 90,  scope = false, silent = false },
}

AMMO_POOL_MAX = { pistol = 800, smg = 800, rifle = 400, magnum = 200, shotgun = 100,
                  reaper = 800, grenadeRounds = 40, rockets = 3, sedatives = 200,
                  bolts = 40, grenades = 10, mines = 10, nbomb = 1, psychosis = 20 }

-- Enemy health (mod HP). Soldier = Goomba replacement, Trooper = Koopa replacement.
ENEMY_HP = { soldier = 100, trooper = 150, blonde = 600 }

-- Weapon sound sample (nil until a real .wav is shipped in sounds/; see pd64_fire.lua).
FALCON2_SOUND = nil

-- Shared per-player weapon state. Lives here (not in main.lua) so every file
-- in the mod can read it. Single-player first; gPlayerSyncTable carries it in co-op.
P = {} -- P[playerIndex] = { weapon, mag, reserve, cooldown, reloadTimer, aiming, tracerTimer, tracerFrom, tracerTo, lastHitY, lastHitHeight, lastHitBaseY }

function pd64_state(m)
    local s = P[m.playerIndex]
    if s == nil then
        s = { weapon = 1, mag = {}, reserve = {}, cooldown = 0, reloadTimer = 0, aiming = false, tracerTimer = 0 }
        for _, w in ipairs(WEAPONS) do
            s.mag[w.id] = w.magSize
            s.reserve[w.pool] = s.reserve[w.pool] or 0
        end
        -- Start with the Falcon 2 loaded and a little pistol ammo, like PD's opening.
        s.reserve["pistol"] = 64
        P[m.playerIndex] = s
    end
    return s
end

function pd64_current_weapon(s) return WEAPONS[s.weapon] end

function pd64_switch_weapon(m, s, dir)
    -- Cancel a reload when switching, like PD does.
    s.reloadTimer = 0
    s.weapon = ((s.weapon - 1 + dir) % #WEAPONS) + 1
    s.cooldown = 12 -- brief switch delay
    local nw = pd64_current_weapon(s)
    play_sound(SOUND_MENU_CLICK_CHANGE_VIEW, m.pos)
    djui_popup_create(nw.name, 1)
end

function pd64_start_reload(m, s)
    local w = pd64_current_weapon(s)
    if s.reloadTimer > 0 then return end
    if s.mag[w.id] >= w.magSize then return end
    if (s.reserve[w.pool] or 0) <= 0 then return end
    s.reloadTimer = w.reloadTime or 60 -- frames; ~1s default (TUNE per weapon)
    play_sound(SOUND_GENERAL_COIN, m.pos) -- placeholder click; replace with a reload sample
end

function pd64_finish_reload(s)
    local w = pd64_current_weapon(s)
    local need = w.magSize - s.mag[w.id]
    local take = math.min(need, s.reserve[w.pool] or 0)
    s.mag[w.id] = s.mag[w.id] + take
    s.reserve[w.pool] = s.reserve[w.pool] - take
    s.reloadTimer = 0
end
