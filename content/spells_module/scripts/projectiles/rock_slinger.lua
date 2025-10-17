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

  -- assign a fixed orbit angle so each rock forms in a different place
  local angle = ((GameGetFrameNum() % 60) / 60) * (2 * math.pi)
  EntityAddComponent2(entity_id, "VariableStorageComponent", {
    _tags = "rock_form_angle",
    value_float = angle
  })

  return
end

local start_frame = ComponentGetValue2(t_comp, "value_int")
local delay_frames = 60

-- find the player
local players = EntityGetWithTag("player_unit")
if #players == 0 then EntityKill(entity_id) return end
local player = players[1]

--  STEP 1: FOLLOW WAND POSITION
-- find the active wand the player is holding
local inventory = EntityGetFirstComponentIncludingDisabled(player, "Inventory2Component")
if inventory then
  local wand = ComponentGetValue2(inventory, "mActiveItem")
  if wand ~= nil and wand ~= 0 then
    local wand_x, wand_y, wand_rot = EntityGetTransform(wand)

    -- get stored unique angle for this rock
    local angle_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "VariableStorageComponent", "rock_form_angle")
    local angle = 0
    if angle_comp then
      angle = ComponentGetValue2(angle_comp, "value_float")
    end

    -- base wand muzzle
    local base_x = wand_x + math.cos(wand_rot) * 12
    local base_y = wand_y + math.sin(wand_rot) * 12

    -- offset once (locked angle)
    local radius = 10
    local offset_x = math.cos(angle) * radius
    local offset_y = math.sin(angle) * radius

    -- rotate offset with wand facing
    local rot_cos, rot_sin = math.cos(wand_rot), math.sin(wand_rot)
    local rotated_x = offset_x * rot_cos - offset_y * rot_sin
    local rotated_y = offset_x * rot_sin + offset_y * rot_cos

    local muzzle_x = base_x + rotated_x
    local muzzle_y = base_y + rotated_y

    EntitySetTransform(entity_id, muzzle_x, muzzle_y, wand_rot)
  end
end

--  STEP 2: wait for animation delay
if frame - start_frame < delay_frames then
  return
end

-- STEP 3: aim direction
local dir_x, dir_y = 0, 0
local controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")

if controls then
  dir_x, dir_y = ComponentGetValue2(controls, "mAimingVectorNormalized")
end

-- If ControlsComponent gives no direction, use mouse fallback
if dir_x == 0 and dir_y == 0 then
  local mx, my = DEBUG_GetMouseWorld()
  local px, py = EntityGetTransform(player)
  dir_x, dir_y = mx - px, my - py
end

-- ✅ Normalize or use wand facing as fallback
local len = math.sqrt(dir_x * dir_x + dir_y * dir_y)
if len == 0 then
  -- use wand facing if we have no valid aim vector
  local _, _, wand_rot = EntityGetTransform(wand)
  dir_x, dir_y = math.cos(wand_rot), math.sin(wand_rot)
else
  dir_x, dir_y = dir_x / len, dir_y / len
end

--  STEP 4: fire projectile
local x, y = EntityGetTransform(entity_id)
local speed = 700
shoot_projectile_from_projectile(
  entity_id,
  "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/light_bullet_rock.xml",
  x + dir_x * 3, y + dir_y * 3,
  dir_x * speed, dir_y * speed
)

GamePlaySound("data/audio/Desktop/projectiles.bank", "player_projectiles/rock/create", x, y)
EntityKill(entity_id)
