local entity = GetUpdatedEntityID();

local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
if velocity ~= nil then
    ComponentSetValue2( velocity, "gravity_y", 0 );
end

local projectile_comp = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile_comp ~= nil then
	ComponentSetValue2( projectile_comp, "bounce_at_any_angle", true );
	ComponentSetValue2( projectile_comp, "bounce_always", true );
	ComponentSetValue2( projectile_comp, "bounce_energy", 1 );
end