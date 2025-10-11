extra_modifiers.frost_blast = function()
	c.extra_entities = c.extra_entities .. "mods/noita.thingsmod/content/synergies/entities/ice_burst.xml,"
	c.damage_ice_add = c.damage_ice_add + 0.2
end

extra_modifiers.ukulele = function()
	c.extra_entities = c.extra_entities .. "mods/noita.thingsmod/content/synergies/entities/ukulele_hitfx.xml,"
end

extra_modifiers.ricochet = function()
	c.extra_entities = c.extra_entities .. "mods/noita.thingsmod/content/synergies/entities/zero_gravity_spells.xml,"
	c.bounces = math.max(c.bounces, 1) * 3
end