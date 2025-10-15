dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform(entity_id)

-- store time since spawn
local delay_frames = 30 -- about half a second
local data = EntityGetFirstComponentIncludingDisabled(entity_id, "VariableStorageComponent", "rock_slinger_timer")

if data == nil then
	EntityAddComponent2(entity_id, "VariableStorageComponent", {
		_tags="rock_slinger_timer",
		value_int=GameGetFrameNum()
	})
	return
end

local start_frame = ComponentGetValue2(data, "value_int")
local now = GameGetFrameNum()

if now - start_frame < delay_frames then
	-- hover animation (optional wiggle)
	EntityApplyTransform(entity_id, x, y + math.sin(now * 0.2) * 0.2)
	return
end

-- after delay, launch forward
local vel_x, vel_y = GameGetVelocityCompVelocity(entity_id)
if math.abs(vel_x) + math.abs(vel_y) < 1 then
	local wand_x, wand_y, wand_rot = EntityGetTransform(GetUpdatedEntityRootID(entity_id))
	local speed = 180
	local dir_x = math.cos(wand_rot)
	local dir_y = math.sin(wand_rot)
	edit_component(entity_id, "VelocityComponent", function(comp)
		ComponentSetValueVector2(comp, "mVelocity", dir_x * speed, dir_y * speed)
	end)
end
