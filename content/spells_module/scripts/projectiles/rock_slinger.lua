dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local frame = GameGetFrameNum()

-- one-time init
local start_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "VariableStorageComponent", "rock_form_start")
if not start_comp then
	EntityAddComponent2(entity_id, "VariableStorageComponent", {
		_tags = "rock_form_start",
		value_int = frame
	})
	-- give each rock a unique orbit angle
	local angle = ((GameGetFrameNum() % 60) / 60) * (2 * math.pi)
	EntityAddComponent2(entity_id, "VariableStorageComponent", {
		_tags = "rock_form_angle",
		value_float = angle
	})
	return
end

local start_frame = ComponentGetValue2(start_comp, "value_int")
local delay_frames = 60 -- hover duration

-- get player + wand
local players = EntityGetWithTag("player_unit")
if #players == 0 then EntityKill(entity_id) return end
local player = players[1]
local inventory = EntityGetFirstComponentIncludingDisabled(player, "Inventory2Component")
if not inventory then return end
local wand = ComponentGetValue2(inventory, "mActiveItem")
if wand == nil or wand == 0 then return end

-- find wand position
local wand_x, wand_y, wand_rot = EntityGetTransform(wand)
local base_x = wand_x + math.cos(wand_rot) * 12
local base_y = wand_y + math.sin(wand_rot) * 12

-- stored unique orbit angle
local angle_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "VariableStorageComponent", "rock_form_angle")
local angle = 0
if angle_comp then angle = ComponentGetValue2(angle_comp, "value_float") end

-- offset in circle
local radius = 10
local offset_x = math.cos(angle) * radius
local offset_y = math.sin(angle) * radius
local rot_cos, rot_sin = math.cos(wand_rot), math.sin(wand_rot)
local rotated_x = offset_x * rot_cos - offset_y * rot_sin
local rotated_y = offset_x * rot_sin + offset_y * rot_cos
local x = base_x + rotated_x
local y = base_y + rotated_y

local proj_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ProjectileComponent")

-- ✨ Hover phase
if frame - start_frame < delay_frames then
	EntitySetTransform(entity_id, x, y, wand_rot)
	if proj_comp then
		ComponentSetValue2(proj_comp, "speed_min", 0)
		ComponentSetValue2(proj_comp, "speed_max", 0)
	end
	return
end

-- 💥 STEP 2: Launch once
if not EntityHasTag(entity_id, "rock_launched") then
	EntityAddTag(entity_id, "rock_launched")

	-- Aim direction
	local dir_x, dir_y = 0, 0
	local controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
	if controls then
		dir_x, dir_y = ComponentGetValue2(controls, "mAimingVectorNormalized")
	end

	if dir_x == 0 and dir_y == 0 then
		dir_x, dir_y = math.cos(wand_rot), math.sin(wand_rot)
	end

	local len = math.sqrt(dir_x * dir_x + dir_y * dir_y)
	if len == 0 then
		dir_x, dir_y = 1, 0
	else
		dir_x, dir_y = dir_x / len, dir_y / len
	end

	-- === Properly launch the projectile ===
	local speed = 700

	local proj_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ProjectileComponent")
	local vel_comp  = EntityGetFirstComponentIncludingDisabled(entity_id, "VelocityComponent")

	if vel_comp then
		-- Give it real velocity
		ComponentSetValue2(vel_comp, "mVelocity", dir_x * speed, dir_y * speed)
	end

	if proj_comp then
		-- Make sure the ProjectileComponent wakes up and obeys physics
		ComponentSetValue2(proj_comp, "speed_min", speed)
		ComponentSetValue2(proj_comp, "speed_max", speed)
		ComponentSetValue2(proj_comp, "velocity_sets_scale", 1)
		ComponentSetValue2(proj_comp, "damage", 0.12)
		ComponentSetValue2(proj_comp, "lifetime", 40)

		-- Reset lifetime and trigger internal movement state
		EntitySetComponentIsEnabled(entity_id, proj_comp, false)
		EntitySetComponentIsEnabled(entity_id, proj_comp, true)
	end

	GamePlaySound("data/audio/Desktop/projectiles.bank", "player_projectiles/rock/create", x, y)
end
