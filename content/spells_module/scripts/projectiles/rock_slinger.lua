dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local frame = GameGetFrameNum()

-- one-time init
local t_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "VariableStorageComponent", "rock_form_start")
if not t_comp then
  EntityAddComponent2(entity_id, "VariableStorageComponent", {
    _tags = "rock_form_start",
    value_int = frame
  })
  return
end

local start_frame = ComponentGetValue2(t_comp, "value_int")
local delay_frames = 60
if frame - start_frame < delay_frames then return end

-- get player entity
local players = EntityGetWithTag("player_unit")
if #players == 0 then
  EntityKill(entity_id)
  return
end

local player = players[1]
local x, y = EntityGetTransform(entity_id)

-- try to get aiming vector from ControlsComponent
local dir_x, dir_y = 0, 0
local controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
if controls ~= nil then
  dir_x, dir_y = ComponentGetValue2(controls, "mAimingVectorNormalized")
end

-- fallback if aim vector was zero
if dir_x == 0 and dir_y == 0 then
  local mx, my = DEBUG_GetMouseWorld()
  local px, py = EntityGetTransform(player)
  dir_x = mx - px
  dir_y = my - py
  local len = math.sqrt(dir_x^2 + dir_y^2)
  if len ~= 0 then dir_x, dir_y = dir_x / len, dir_y / len end
end

-- fallback to rotation if all else fails
if dir_x == 0 and dir_y == 0 then
  local _, _, rot = EntityGetTransform(entity_id)
  dir_x = math.cos(rot)
  dir_y = math.sin(rot)
end

-- launch the rock
local speed = 700
shoot_projectile_from_projectile(
  entity_id,
  "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/light_bullet_rock.xml",
  x + dir_x * 3, y + dir_y * 3,
  dir_x * speed, dir_y * speed
)

GamePlaySound("data/audio/Desktop/projectiles.bank", "player_projectiles/rock/create", x, y)
EntityKill(entity_id)
