local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

EntityLoad("mods/noita.thingsmod/content/synergies/entities/ice_burst_effect.xml", x, y)

local range = 20

local targets = EntityGetInRadiusWithTag( x, y, range, "mortal" )
if ( targets ~= nil ) then
	local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	if ( projectile_comp ~= nil ) then
		local shooter = ComponentGetValue2( projectile_comp, "mWhoShot" )
		for i, target in ipairs( targets ) do
			if ( target ~= shooter ) then
				LoadGameEffectEntityTo(target, "data/entities/misc/effect_frozen_short.xml")
			end
		end
	end
end