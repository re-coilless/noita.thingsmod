dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal, projectile_id )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	if( damage < 0 ) then return end

	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	
	if ( entity_who_caused == entity_id ) or ( ( EntityGetParent( entity_id ) ~= NULL_ENTITY ) and ( entity_who_caused == EntityGetParent( entity_id ) ) ) then return end

	if script_wait_frames( entity_id, 2 ) then  return  end
	
	local angle = math.rad( Random( 1, 360 ) )
	local angle_random = math.rad( Random( -2, 2 ) )
	local vel_x = 0
	local vel_y = 0
	local length = 900
	local projectile = "mods/noita.thingsmod/content/synergies/entities/electricity.xml"
	
	if ( entity_who_caused ~= nil ) and ( entity_who_caused ~= NULL_ENTITY ) then
		local ex, ey = EntityGetTransform( entity_who_caused )
		
		if ( ex ~= nil ) and ( ey ~= nil ) then
			angle = 0 - math.atan2( ey - y, ex - x )
		end
	end
	
	if ( #projectile > 0 ) then
		local count = Random( 2, 4 )
		for i=1,count do
			local offset = math.rad( Random( -6, 6 ) )
			vel_x = math.cos( angle + angle_random + offset ) * length
			vel_y = 0 - math.sin( angle + angle_random + offset ) * length
			local pid = shoot_projectile( entity_id, projectile, x, y, vel_x, vel_y )
			
			edit_component( pid, "ProjectileComponent", function(comp,vars)
				local dmg = ComponentGetValue2( comp, "damage" ) * 2.0
				ComponentSetValue2( comp, "damage", dmg )
			end)
		end
	end
end
