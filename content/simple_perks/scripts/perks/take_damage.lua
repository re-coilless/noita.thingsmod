dofile_once("data/scripts/status_effects/status_list.lua")
---@diagnostic disable shuts up diagnostics here
local function BuildStainIDs()
    -- Cache stain IDs
    local stain_ids = {}
    if stain_ids.bloody == nil or stain_ids.slimy == nil then
        dofile("data/scripts/status_effects/status_list.lua")
        for sindex = 1, #status_effects do
            stain_ids[status_effects[sindex].id] = sindex
        end
    end
    return stain_ids
end

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    local entity_id = GetUpdatedEntityID()

    local ndmg = damage
    if tonumber(GlobalsGetValue( "PERK_PICKED_NOITA_THINGSMOD_WET_ARMOR_PICKUP_COUNT", "0" )) > 0 and damage > 0 then
        StainIDs = StainIDs or BuildStainIDs()
        local statuscomp = EntityGetFirstComponentIncludingDisabled(entity_id, "StatusEffectDataComponent")
        local stains = ComponentGetValue2(statuscomp, "stain_effects")
        local stain_count = 0
        for k=1, #status_effects do
            if (stains[StainIDs[status_effects[k].id]] or 0) > 0 then
                stain_count = stain_count + 1
            end
        end

        stain_count = stain_count + (tonumber(GlobalsGetValue( "PERK_PICKED_NOITA_THINGSMOD_WET_ARMOR_PICKUP_COUNT", "0" )) - 1)
    
        local hitboxcomps = EntityGetComponentIncludingDisabled(entity_id,"HitboxComponent")
        ndmg = (ndmg * math.min(1/(2^stain_count),1))

        --Debug Data
        --print(table.concat({"multiplier is ",tostring(math.min(1/(2^stain_count),1))}))
        --print(table.concat({"ndmg is ",ndmg}))
        --print(table.concat({"stain_count is ",stain_count}))
    end

    if tonumber(GlobalsGetValue( "PERK_PICKED_NOITA_THINGSMOD_NOHIT_CRITS_PICKUP_COUNT", "0" )) > 0 and damage > 0 then
        local children = EntityGetAllChildren(entity_id)
        local found = false
        for k=1,#children do
            local v = children[k]
            if EntityGetName(v) == "thingsmod_perk_nohit_crits" then
                EntitySetComponentsWithTagEnabled( v, "invincible", false )
            elseif EntityGetName(v) == "thingsmod_perk_nohit_crits_cd" then
                local comp = EntityGetFirstComponentIncludingDisabled(v,"GameEffectComponent")
                ComponentSetValue2(comp,"frames",3600)
                found = true
            end
        end

        if found == false then 
            local x,y = EntityGetTransform(entity_id)
            local timer = EntityLoad("mods/noita.thingsmod/content/simple_perks/entities/misc/perks/nohit_crits_cooldown.xml",x,y)
            EntityAddChild(entity_id,timer)
        end
    end

    return ndmg, critical_hit_chance
end
