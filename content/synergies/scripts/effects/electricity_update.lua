local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
SetRandomSeed( GameGetFrameNum(), x + y + entity );
if velocity ~= nil then
    local zap_frame = GetValueNumber("zap_frames", 0)--EntityAdjustVariable( entity, "gkbrkn_zap_frames", "float", 0.0, function(value) return tonumber(value) + 1; end ) or 0;
    zap_frame = zap_frame + 1;
	local vx, vy = ComponentGetValue2( velocity, "mVelocity");
    local scale = math.min( 1, 0.25 * zap_frame * 0.5 );
    local angle = math.atan2( vy, vx ) + (Random() - 0.5) * math.pi * scale;
    local magnitude = math.sqrt( vx * vx + vy * vy );
    ComponentSetValue2( velocity, "mVelocity", math.cos( angle ) * magnitude, math.sin( angle ) * magnitude );
end