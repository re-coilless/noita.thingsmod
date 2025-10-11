dofile( "data/scripts/lib/utilities.lua" )
dofile_once("mods/noita.thingsmod/content/synergies/scripts/utils/utilities.lua")

-- stole this from my risk of items mod because lazy lmao

function damage_received( damage, message, entity_thats_responsible, is_fatal  )
	local x, y = EntityGetTransform( GetUpdatedEntityID() )
   	SetRandomSeed( GameGetFrameNum(), x * y )

    local chance = Random(1,100)
    if(chance < 26)then
        local this = GetUpdatedEntityID()

		local x, y = EntityGetTransform( this )

		RunOnTargets(x, y, 100, this, function(target)
			local angle_inc = 0
			local angle_inc_set = false
			
			local length = 400
			
			local ex, ey = EntityGetTransform( target )
			
			if ( ex ~= nil ) and ( ey ~= nil ) then
				angle_inc = 0 - math.atan2( ( ey - y ), ( ex - x ) )
				angle_inc_set = true
			end
			
			local angle = 0
			if angle_inc_set then
				angle = angle_inc + Random( -5, 5 ) * 0.01
			else
				angle = math.rad( Random( 1, 360 ) )
			end

			local vel_x = math.cos( angle ) * length
			local vel_y = 0- math.sin( angle ) * length

			local ukulele_damage = (damage / 100) * 80

			local projectile = shoot_projectile( this, "mods/noita.thingsmod/content/synergies/entities/ukulele_beam.xml", x, y, vel_x, vel_y )

			edit_component( projectile, "ProjectileComponent", function(comp,vars)
				vars.damage = ukulele_damage
				vars.mWhoShot = entity_thats_responsible
				vars.mShooterHerdId = 0
			end)
		end)


    end
end
