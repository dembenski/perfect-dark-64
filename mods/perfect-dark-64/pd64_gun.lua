-- Falcon 2 viewmodel: the DynOS gun model, held in Mario's hand.
-- DRAFT — not yet tested in-game (the game runs on Michael's laptop).
--
-- How it works: the gun is spawned ONCE as a child of Mario
-- (spawn_sync_object parents it to Mario and it inherits his yaw), then
-- every frame we set its parent-relative position (the hand offset) and its
-- relative yaw/pitch. When the selected weapon is NOT a Falcon 2 variant
-- the model is swapped to E_MODEL_NONE so the gun disappears; it comes back
-- the moment a Falcon 2 is selected again. No viewmodel API exists in Lua,
-- so a real spawned object following Mario is the only route.
--
-- Model file must exist first:
--   mods/perfect-dark-64/actors/pd64_falcon2/  (Blender + Fast64 export)
-- Until the model exists, this file is a no-op (guarded by the checks below).
--
-- ORIENTATION (verified from the exported geo.inc.c, not guessed):
--   Fast64 exports Blender +Y (the direction the gun points in the .blend)
--   as SM64 -Z. So with the gun spawned at Mario's yaw, the barrel would
--   point BACKWARDS. The +0x8000 yaw below turns it around so the barrel
--   points where Mario faces. If the gun ever points the wrong way in-game,
--   this 0x8000 is the first thing to check.

local E_MODEL_FALCON2 = nil
do
    -- v0.1.1 lesson: smlua_model_util_get_id NEVER returns nil — on failure
    -- it logs "Could not find model" and returns E_MODEL_ERROR_MODEL. A
    -- nil-only check would load the red ERROR text model, so check both.
    local ok, id = pcall(smlua_model_util_get_id, "pd64_falcon2_geo")
    if ok and id ~= nil and id ~= E_MODEL_ERROR_MODEL then
        E_MODEL_FALCON2 = id
    end
end

-- Falcon 2 variants that this model stands in for (see pd64_data.lua).
local FALCON2_IDS = { [1] = true, [2] = true, [3] = true }

-- Hand offset, in Mario-local space (SM64 units). +X = Mario's right,
-- +Y = up, +Z = forward. TUNE in-game: move it until the grip sits in
-- Mario's hand and the barrel clears his shoulder in first person.
local HAND_RIGHT = 35
local HAND_UP = 105
local HAND_FORWARD = 45

local id_bhvPDGun = hook_behavior(id_bhvStaticObject, OBJ_LIST_DEFAULT, true,
    function(obj)
        obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    end,
    function(obj) end)

local gunObj = nil
local gunVisible = false

local function pd64_gun_is_falcon2(s)
    return FALCON2_IDS[pd64_current_weapon(s).id] == true
end

local function pd64_gun_setup(obj)
    obj.oParentRelativePosX = HAND_RIGHT
    obj.oParentRelativePosY = HAND_UP
    obj.oParentRelativePosZ = HAND_FORWARD
    obj.oFaceAngleYaw = 0x8000 -- barrel is modelled along -Z; turn it forward
    obj.oFaceAnglePitch = 0
    obj.oFaceAngleRoll = 0
end

local function pd64_gun_spawn(m)
    if E_MODEL_FALCON2 == nil then return end
    gunObj = spawn_sync_object(id_bhvPDGun, E_MODEL_FALCON2,
        m.pos.x, m.pos.y, m.pos.z, pd64_gun_setup)
    gunVisible = true
end

function pd64_gun_update(m, s)
    if E_MODEL_FALCON2 == nil then return end
    if m.playerIndex ~= 0 then return end -- local player's gun only

    -- Re-find the gun if the stored handle went stale, respawn if it's gone.
    if gunObj == nil then
        gunObj = obj_get_first_with_behavior_id(id_bhvPDGun)
        if gunObj == nil then
            pd64_gun_spawn(m)
            return
        end
        gunVisible = true
    end

    -- Show only for Falcon 2 variants; hide for every other weapon.
    local wantVisible = pd64_gun_is_falcon2(s)
    if wantVisible ~= gunVisible then
        if wantVisible then
            obj_set_model_extended(gunObj, E_MODEL_FALCON2)
        else
            obj_set_model_extended(gunObj, E_MODEL_NONE)
        end
        gunVisible = wantVisible
    end
    if not wantVisible then return end

    -- Per-frame follow: hand offset + yaw correction, every frame, so the
    -- gun tracks Mario through turns, jumps and (roughly) animations.
    -- A fixed body-relative offset can't track the hand through every
    -- animation frame — that is the known v1 limit, not a bug.
    gunObj.oParentRelativePosX = HAND_RIGHT
    gunObj.oParentRelativePosY = HAND_UP
    gunObj.oParentRelativePosZ = HAND_FORWARD
    gunObj.oFaceAngleYaw = 0x8000
    if s.aiming then
        -- Pitch the barrel with the first-person camera while aiming.
        -- TUNE: flip the sign if the barrel pitches the wrong way in-game.
        gunObj.oFaceAnglePitch = gFirstPersonCamera.pitch
    else
        gunObj.oFaceAnglePitch = 0
    end
end

-- Hookup (add to main.lua next to the other requires):
--   require("pd64_gun")
--   ... inside pd64_mario_update, after the aim block:
--   pd64_gun_update(m, s)
