dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local frame = GameGetFrameNum()

-- one-time init
local t_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "VariableStorageComponent", "rock_form_start")
if t_comp == nil then
  EntityAddComponent2(entity_id, "VariableStorageComponent", {
    _tags    = "rock_form_start",
    value_int = frame
  })
  return
end

local start_frame = ComponentGetValue2(t_comp, "value_int")
local delay_frames = 24  -- ~0.4s at 60 FPS (tweak to match your animation)
if frame - start_frame < delay_frames then
  return
end

-- Launch projectile once
-- Use our own transform (inherits aim rotation from cast)
local x, y, rot = EntityGetTransform(entity_id)
local dir_x, dir_y = math.cos(rot), math.sin(rot)
local speed = 220

-- Spawn the rock with ownership and correct damage bookkeeping
-- (utilities.lua provides this helper)
shoot_projectile_from_projectile(entity_id,"mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/airblast.xml",x + dir_x * 3, y + dir_y * 3,dir_x * speed, dir_y * speed
)

-- (Optional) play a fire sound
GamePlaySound("data/audio/Desktop/projectiles.bank", "player_projectiles/rock/create", x, y)

-- self-destruct
EntityKill(entity_id)
