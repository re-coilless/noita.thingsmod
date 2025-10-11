local entity_names = {
	"$animal_homunculus",
	"$perk_lukki_minion",
}

local entity_tags = {
	"tiny_ghost",
	"hungry_ghost",
	"angry_ghost",
	"ghostly_ghost"
}

local player = GetUpdatedEntityID()
local x, y = EntityGetTransform(player)

local function should_get_shielded(entity_id)

	local entity_name = EntityGetName(entity_id) or ""
	for _, name in ipairs(entity_names) do
		if entity_name == name then
			return true
		end
	end

	for _, tag in ipairs(entity_tags) do
		if EntityHasTag(entity_id, tag) and EntityGetRootEntity(entity_id) == player then
			return true
		end
	end
	
	return false
end

local nearby_friends = EntityGetInRadius(x, y, 150)
-- add children of player
local player_children = EntityGetAllChildren(player) or {}
for _, child in ipairs(player_children) do
	table.insert(nearby_friends, child)
end

for _, entity_id in ipairs(nearby_friends or {}) do
	if entity_id ~= player and should_get_shielded(entity_id) then
		local children = EntityGetAllChildren(entity_id) or {}
		local has_shield = false
		for _, child in ipairs(children) do
			if EntityHasTag(child, "energy_shield") then
				-- increase lifetime by 60 frames instead
				local lifetime_comp = EntityGetFirstComponent(child, "LifetimeComponent")
				if lifetime_comp ~= nil then
					local lifetime = ComponentGetValue2(lifetime_comp, "lifetime")
					ComponentSetValue2(lifetime_comp, "lifetime", lifetime + 60)
					-- set kill frame
					ComponentSetValue2(lifetime_comp, "kill_frame", GameGetFrameNum() + 60)
					has_shield = true
				end
			end
		end

		if not has_shield then
			local ex, ey = EntityGetTransform(entity_id)
			local shield = EntityLoad("mods/noita.thingsmod/content/synergies/entities/shield.xml", ex, ey)
			EntityAddChild(entity_id, shield)
		end
	end
end