---@diagnostic disable: undefined-global
extra_modifiers["thingsmod_nohit_crits"] = function()
    shot_effects.recoil_knockback = 0
    c.damage_critical_chance = c.damage_critical_chance + 100
end
