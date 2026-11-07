-- Joanna Dark as the playable character: a DynOS model swap, same pattern as
-- the bundled koopa-player-model example. Model file must exist first:
--   mods/perfect-dark-64/actors/joanna_geo/  (built in Blender, DynOS format)
-- Until the model exists, this file is a no-op (guarded by the nil check).

local E_MODEL_JOANNA = nil
local ok, id = pcall(smlua_model_util_get_id, "joanna_geo")
if ok and id ~= nil then E_MODEL_JOANNA = id end

local function pd64_joanna_update(m)
    if E_MODEL_JOANNA == nil then return end
    if m.playerIndex == 0 then
        gPlayerSyncTable[0].modelId = E_MODEL_JOANNA
    end
    if gPlayerSyncTable[m.playerIndex].modelId ~= nil then
        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)
    end
end

hook_event(HOOK_MARIO_UPDATE, pd64_joanna_update)
