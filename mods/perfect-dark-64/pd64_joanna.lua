-- Joanna Dark as the playable character: a DynOS model swap, same pattern as
-- the bundled koopa-player-model example. Model file:
--   mods/perfect-dark-64/actors/pd64_joanna/  (built in Blender, DynOS format)
--
-- v0.1.1 lesson: smlua_model_util_get_id NEVER returns nil — on failure it
-- logs "Could not find model" and returns E_MODEL_ERROR_MODEL. A nil-only
-- check would load the red ERROR text model, so check both. The lookup stays
-- guarded: if the actor folder is ever missing, this file is a no-op again.

local E_MODEL_JOANNA = nil
do
    local ok, id = pcall(smlua_model_util_get_id, "pd64_joanna_geo")
    if ok and id ~= nil and id ~= E_MODEL_ERROR_MODEL then
        E_MODEL_JOANNA = id
    end
end

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
