dofile_once("mods/noita.thingsmod/content/synergies/scripts/utils/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

EntityLoad("mods/noita.thingsmod/content/synergies/entities/ice_burst_effect.xml", x, y)

local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if ( projectile_comp == nil ) then
	return
end

local shooter = ComponentGetValue2( projectile_comp, "mWhoShot" )

local range = 20

RunOnTargets(x, y, range, shooter, function(target)
	LoadGameEffectEntityTo(target, "data/entities/misc/effect_frozen_short.xml")
end)