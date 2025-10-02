local entity_id = GetUpdatedEntityID()
local player_id = EntityGetParent(entity_id)
local children = EntityGetAllChildren(player_id)
for k=1,#children do
    local v = children[k]
    if EntityGetName(v) == "thingsmod_perk_nohit_crits" then
        EntitySetComponentsWithTagEnabled( v, "invincible", true)
    end
end
