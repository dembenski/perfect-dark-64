-- dataDyne soldier: replaces the Goomba. Same shape as the bundled
-- behavior-replace-goomba.lua example, plus PD health + alert behavior.

define_custom_obj_fields({
    oPDHealth = 'f32',
    oPDSleepTimer = 'f32',   -- Tranquilizer: > 0 = asleep
    oPDCharmedTimer = 'f32', -- Psychosis Gun: > 0 = fights for Joanna
    oPDTargetYaw = 'f32',
})

local function bhv_pd_soldier_init(obj)
    obj.oFlags = (OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO | OBJ_FLAG_COMPUTE_DIST_TO_MARIO
        | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)
    local floor = find_floor_height(obj.oPosX, obj.oPosY + 200.0, obj.oPosZ)
    obj.oPosY = floor
    obj.oMoveFlags = obj.oMoveFlags | OBJ_MOVE_ON_GROUND
    -- TUNE: swap the model for the dataDyne soldier DynOS model when it exists.
    obj.oAnimations = gObjectAnimations.goomba_seg8_anims_0801DA4C
    obj.oHomeX, obj.oHomeY, obj.oHomeZ = obj.oPosX, obj.oPosY, obj.oPosZ
    obj.oWallHitboxRadius = 40.0
    obj.oGravity = -4.0
    obj.oBounciness = -0.5
    obj.oDragStrength = 10.0
    obj.oFriction = 10.0
    obj.oPDHealth = 100
    obj.oPDSleepTimer = 0
    obj.oPDCharmedTimer = 0
    obj.oDeathSound = SOUND_OBJ_ENEMY_DEATH_HIGH
    obj.oInteractType = INTERACT_DAMAGE -- touch = damage to Mario (v1 melee soldier)
    obj.oDamageOrCoinValue = 1
    obj.hitboxRadius = 60
    obj.hitboxHeight = 150
    obj.hurtboxRadius = 50
    obj.hurtboxHeight = 140
    obj.oDrawingDistance = 6000
    network_init_object(obj, true, { 'oPDHealth', 'oPDSleepTimer', 'oPDCharmedTimer' })
end

local function bhv_pd_soldier_loop(obj)
    -- Asleep (tranquilizer): lie still, count down.
    if obj.oPDSleepTimer > 0 then
        obj.oPDSleepTimer = obj.oPDSleepTimer - 1
        return
    end
    -- Charmed (psychosis): stand still for now — v1.1 makes charmed soldiers
    -- chase the nearest OTHER soldier. (Needs the trooper scan; see draft Part 5.)
    if obj.oPDCharmedTimer > 0 then
        obj.oPDCharmedTimer = obj.oPDCharmedTimer - 1
        return
    end

    local player = nearest_player_to_object(obj)
    local dist = dist_between_objects(obj, player)
    local angle = obj_angle_to_object(obj, player)

    -- Cloak check: RC-P120 secondary makes soldiers ignore Mario.
    if gPlayerSyncTable[0] ~= nil and gPlayerSyncTable[0].pd64Cloaked then
        return -- stand still; Mario is invisible to us (v1 version of the cloak)
    end

    cur_obj_init_animation_with_accel_and_sound(0, 5.0)
    cur_obj_update_floor_and_walls()
    obj.oPDTargetYaw = angle
    cur_obj_rotate_yaw_toward(obj.oPDTargetYaw, 0x200)
    -- Walk at Mario when close; patrol (stand) when far. (TUNE speeds.)
    local speed = 0
    if dist < 2500 then speed = 60.0 end
    obj_forward_vel_approach(speed, 0.4)
    cur_obj_move_standard(-78)
end

-- Replace Goomba with the soldier. Returns the new behavior id for the fire code.
local id_bhvPDSoldier = hook_behavior(id_bhvGoomba, OBJ_LIST_PUSHABLE, true,
    bhv_pd_soldier_init, bhv_pd_soldier_loop)
pd64_register_soldier_behavior(id_bhvPDSoldier)
