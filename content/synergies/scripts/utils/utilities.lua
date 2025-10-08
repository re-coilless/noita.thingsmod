function GetTargets(x, y, radius, self)
	local targets_table = {}
	local targets = EntityGetInRadiusWithTag( x, y, radius, "homing_target" )
	if ( targets ~= nil ) then
		for i, target in ipairs( targets ) do
			if ( target ~= self ) then
				table.insert( targets_table, target )
			end
		end
	end
	return targets_table
end

function RunOnTargets(x, y, radius, self, func)
	local targets = EntityGetInRadiusWithTag( x, y, radius, "homing_target" )
	if ( targets ~= nil ) then
		for i, target in ipairs( targets ) do
			if ( target ~= self ) then
				func(target)
			end
		end
	end
end

function AddShotEffect(entity_id, effect)
	EntityAddComponent( entity_id, "ShotEffectComponent", 
	{
		_tags = "perk_component",
		extra_modifier = effect,
	} )
end

function RemoveShotEffect(entity_id, effect)
	local comps = EntityGetComponent( entity_id, "ShotEffectComponent", "perk_component" )
	if( comps ~= nil ) then
		for i,comp in ipairs(comps) do
			local em = ComponentGetValue2( comp, "extra_modifier" )
			if( em == effect ) then
				EntityRemoveComponent( entity_id, comp )
			end
		end
	end
end