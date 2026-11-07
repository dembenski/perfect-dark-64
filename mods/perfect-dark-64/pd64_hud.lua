-- HUD: crosshair, weapon name, ammo, reload state, FarSight markers.
-- Runs in HOOK_ON_HUD_RENDER. Screen is 320x240 HUD units (djui scales it).

local function pd64_hud()
    local m = gMarioStates[0]
    if m == nil then return end
    local s = P and P[0]
    if s == nil then return end
    local w = WEAPONS[s.weapon]

    -- Crosshair: small + at screen center.
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_render_rect(159, 118, 2, 4)
    djui_hud_render_rect(159, 122, 2, 4)
    djui_hud_render_rect(157, 120, 4, 2)
    djui_hud_render_rect(161, 120, 4, 2)

    -- Weapon name + ammo, bottom-left. (TUNE: position for widescreen.)
    djui_hud_set_text_color(255, 255, 255, 255)
    local ammoText = w.name .. "  " .. tostring(s.mag[w.id]) .. " / " .. tostring(s.reserve[w.pool] or 0)
    djui_hud_print_text(ammoText, 20, 210, 1.0, 1.0)
    if s.reloadTimer > 0 then
        djui_hud_print_text("RELOADING...", 20, 195, 1.0, 1.0)
    end
    if s.aiming then
        djui_hud_print_text("AIM", 290, 20, 1.0, 1.0)
    end

    -- Tracer line: screen-center to hit point, 3 frames after each shot.
    if s.tracerTimer > 0 and s.tracerFrom ~= nil and s.tracerTo ~= nil then
        local ok, sp = djui_hud_world_pos_to_screen_pos(s.tracerTo, { x = 0, y = 0, z = 0 })
        if ok then
            djui_hud_set_color(255, 220, 100, 255)
            djui_hud_render_line(160, 120, sp.x, sp.y, 2)
        end
    end

    -- FarSight markers: red diamonds over soldiers, visible through walls.
    if s.weapon == 21 and SOLDIER_BEHAVIOR ~= nil then
        local obj = obj_get_first_with_behavior_id(SOLDIER_BEHAVIOR)
        while obj ~= nil do
            local ok, sp = djui_hud_world_pos_to_screen_pos(
                { x = obj.oPosX, y = obj.oPosY + 150, z = obj.oPosZ }, { x = 0, y = 0, z = 0 })
            if ok then
                djui_hud_set_text_color(255, 60, 60, 255)
                djui_hud_print_text("<>", sp.x - 6, sp.y - 6, 1.0, 1.0)
            end
            obj = obj_get_next_with_same_behavior_id(obj)
        end
    end
end

hook_event(HOOK_ON_HUD_RENDER, pd64_hud)
