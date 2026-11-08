-- name: Perfect Dark 64
-- description: Perfect Dark weapons in Mario 64. B fires, C-buttons switch weapons, Z aims, R reloads.

-- Load the weapon data table + shared systems.
-- (smlua require: sibling files in the same mod folder.)
require("pd64_data")    -- WEAPONS table (all 43), AMMO pools, switch order, shared player state
require("pd64_fire")    -- hitscan ray, cone check, damage, tracers
require("pd64_hud")     -- crosshair, ammo counter, weapon name
require("pd64_enemies") -- dataDyne soldier behavior (Goomba replacement)
require("pd64_joanna")  -- Joanna Dark player model swap

function pd64_mario_update(m)
    if m.playerIndex ~= 0 then return end -- local player only for input
    local s = pd64_state(m)
    local w = pd64_current_weapon(s)

    -- Timers tick down.
    if s.cooldown > 0 then s.cooldown = s.cooldown - 1 end
    if s.tracerTimer > 0 then s.tracerTimer = s.tracerTimer - 1 end
    if s.reloadTimer > 0 then
        s.reloadTimer = s.reloadTimer - 1
        if s.reloadTimer == 0 then pd64_finish_reload(s) end
    end

    -- Z (hold) = aim. First-person camera + tighter spread; release = back to normal.
    local wantAim = (m.controller.buttonDown & Z_TRIG) ~= 0
    if wantAim ~= s.aiming then
        s.aiming = wantAim
        set_first_person_enabled(wantAim)
        if wantAim and (w.scope or w.id == 3 or w.id == 20 or w.id == 21 or w.id == 26) then
            gFirstPersonCamera.fov = 30 -- scoped zoom (TUNE: verify fov field range in-game)
        elseif wantAim then
            gFirstPersonCamera.fov = 45
        else
            gFirstPersonCamera.fov = 60 -- back to normal (TUNE)
        end
    end

    -- While aiming, C-buttons / D-pad LOOK around (keyboard aim). The mouse
    -- also turns the first-person camera natively. The crosshair itself never
    -- moves — it stays glued to the middle of the screen like a real shooter;
    -- you aim by turning the view, and the crosshair (and your shots) follow it.
    -- Angles are SM64 units (0x8000 = 180 degrees).
    if s.aiming then
        local lookRate = 0x200 -- ~2.8 degrees per frame (TUNE)
        if (m.controller.buttonDown & R_CBUTTONS) ~= 0 or (m.controller.buttonDown & R_JPAD) ~= 0 then
            gFirstPersonCamera.yaw = gFirstPersonCamera.yaw - lookRate -- turn right
        end
        if (m.controller.buttonDown & L_CBUTTONS) ~= 0 or (m.controller.buttonDown & L_JPAD) ~= 0 then
            gFirstPersonCamera.yaw = gFirstPersonCamera.yaw + lookRate -- turn left
        end
        if (m.controller.buttonDown & U_CBUTTONS) ~= 0 or (m.controller.buttonDown & U_JPAD) ~= 0 then
            gFirstPersonCamera.pitch = math.min(gFirstPersonCamera.pitch + lookRate, 0x3000) -- look up
        end
        if (m.controller.buttonDown & D_CBUTTONS) ~= 0 or (m.controller.buttonDown & D_JPAD) ~= 0 then
            gFirstPersonCamera.pitch = math.max(gFirstPersonCamera.pitch - lookRate, -0x3000) -- look down
        end
    end

    -- C-buttons / D-pad switch weapons — only when NOT aiming, because while
    -- aiming the same buttons look around instead.
    if not s.aiming then
        if (m.controller.buttonPressed & R_CBUTTONS) ~= 0 or (m.controller.buttonPressed & D_JPAD) ~= 0 then
            pd64_switch_weapon(m, s, 1)
        elseif (m.controller.buttonPressed & L_CBUTTONS) ~= 0 or (m.controller.buttonPressed & U_JPAD) ~= 0 then
            pd64_switch_weapon(m, s, -1)
        end
    end

    -- R = manual reload.
    if (m.controller.buttonPressed & R_TRIG) ~= 0 then pd64_start_reload(m, s) end

    -- B = fire. Semi-auto weapons fire on press; automatic ones fire while held.
    local firing = false
    if w.autoFire then
        firing = (m.controller.buttonDown & B_BUTTON) ~= 0
    else
        firing = (m.controller.buttonPressed & B_BUTTON) ~= 0
    end
    if firing and s.reloadTimer == 0 and s.cooldown <= 0 then
        if s.mag[w.id] > 0 then
            pd64_fire(m, s, w)
        else
            play_sound(SOUND_GENERAL2_BOBOMB_EXPLOSION, m.pos) -- dry click placeholder (TUNE: use a click sample)
            pd64_start_reload(m, s)
        end
    end
end

hook_event(HOOK_MARIO_UPDATE, pd64_mario_update)
