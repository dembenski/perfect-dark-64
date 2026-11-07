-- Hitscan firing: ray vs level geometry + cone check vs soldier objects.
-- Lua CANNOT raycast against objects, so enemies are found by scanning for
-- soldier-behavior objects inside a cone around the shot direction.

-- Global (not local) on purpose: pd64_hud.lua reads it for FarSight markers.
SOLDIER_BEHAVIOR = nil -- set by pd64_enemies.lua after hook_behavior returns the id

function pd64_register_soldier_behavior(id) SOLDIER_BEHAVIOR = id end

-- Ray origin: Mario's eye. Direction: facing yaw, plus first-person pitch while aiming.
local function pd64_ray(m, s, w)
    local ox = m.pos.x
    local oy = m.pos.y + 120.0 -- eye height (TUNE: Mario is ~160 units tall)
    local oz = m.pos.z
    local yaw, pitch
    if s.aiming then
        yaw = gFirstPersonCamera.yaw
        pitch = gFirstPersonCamera.pitch
    else
        yaw = m.faceAngle.y
        pitch = 0
    end
    -- SM64 angles: 0x8000 = 180 degrees. Convert to radians for math.sin/cos.
    local yawRad = yaw * (math.pi / 0x8000)
    local pitchRad = pitch * (math.pi / 0x8000)
    local dx = math.sin(yawRad) * math.cos(pitchRad)
    local dy = math.sin(pitchRad)
    local dz = math.cos(yawRad) * math.cos(pitchRad)
    return ox, oy, oz, dx, dy, dz
end

-- Distance from a point to the ray, and along-ray distance. Returns (along, across).
local function pd64_ray_point(ox, oy, oz, dx, dy, dz, px, py, pz)
    local vx, vy, vz = px - ox, py - oy, pz - oz
    local along = vx * dx + vy * dy + vz * dz
    local cx, cy, cz = ox + dx * along, oy + dy * along, oz + dz * along
    local across = math.sqrt((px - cx) ^ 2 + (py - cy) ^ 2 + (pz - cz) ^ 2)
    return along, across
end

function pd64_fire(m, s, w)
    local ox, oy, oz, dx, dy, dz = pd64_ray(m, s, w)

    -- 1) Wall distance: ray vs level geometry. FarSight skips this (shoots through walls).
    local wallDist = w.range
    if w.id ~= 21 then -- 21 = FarSight XR-20
        local hit = collision_find_surface_on_ray(ox, oy, oz, dx, dy, dz, 10.0)
        if hit ~= nil and hit.hitPos ~= nil then
            wallDist = math.sqrt((hit.hitPos.x - ox) ^ 2 + (hit.hitPos.y - oy) ^ 2 + (hit.hitPos.z - oz) ^ 2)
        end
    end

    -- 2) Enemy scan: nearest soldier inside the cone and closer than the wall.
    local spread = w.spread
    if s.aiming then spread = spread * 0.5 end -- aiming tightens the cone
    local bestObj, bestAlong = nil, wallDist
    if SOLDIER_BEHAVIOR ~= nil then
        local obj = obj_get_first_with_behavior_id(SOLDIER_BEHAVIOR)
        while obj ~= nil do
            -- Soldier center: pos + half its height.
            local cy = obj.oPosY + (obj.hitboxHeight or 100) * 0.5
            local along, across = pd64_ray_point(ox, oy, oz, dx, dy, dz, obj.oPosX, cy, obj.oPosZ)
            -- Cone test: across-distance must fit inside (spread * along) + target radius.
            if along > 0 and along < bestAlong and across < (spread * along + 60.0) then
                bestObj, bestAlong = obj, along
                s.lastHitY = cy
                s.lastHitHeight = obj.hitboxHeight or 100
                s.lastHitBaseY = obj.oPosY
            end
            obj = obj_get_next_with_same_behavior_id(obj)
        end
    end

    -- 3) Hit point for the tracer (enemy, wall, or max range).
    local hx, hy, hz = ox + dx * wallDist, oy + dy * wallDist, oz + dz * wallDist
    if bestObj ~= nil then
        hx, hy, hz = bestObj.oPosX, s.lastHitY, bestObj.oPosZ
        -- Headshot: hit in the top 25% of the target's height = double damage.
        local dmg = w.damage
        if s.lastHitY > s.lastHitBaseY + s.lastHitHeight * 0.75 then dmg = dmg * 2 end
        pd64_damage_soldier(bestObj, dmg)
    end
    s.tracerFrom = { x = ox, y = oy, z = oz }
    s.tracerTo = { x = hx, y = hy, z = hz }
    s.tracerTimer = 3 -- tracer visible for 3 frames

    -- 4) Sound + ammo + cooldown.
    -- TUNE: ship real .wav samples in the mod's sounds/ folder; audio_sample_load at startup.
    if FALCON2_SOUND ~= nil then
        audio_sample_play(FALCON2_SOUND, m.pos, 1.0)
    else
        play_sound(SOUND_ACTION_TERRAIN_JUMP, m.pos) -- placeholder pop (replace!)
    end
    s.mag[w.id] = s.mag[w.id] - 1
    s.cooldown = w.fireInterval
end

-- Damage a soldier: decrement its custom health field; die at 0.
function pd64_damage_soldier(obj, dmg)
    if obj.oPDHealth == nil then return end
    obj.oPDHealth = obj.oPDHealth - dmg
    if obj.oPDHealth <= 0 then
        play_sound(SOUND_OBJ_ENEMY_DEATH_HIGH, obj.oPosX and { x = obj.oPosX, y = obj.oPosY, z = obj.oPosZ } or nil)
        obj_mark_for_deletion(obj)
    end
end
