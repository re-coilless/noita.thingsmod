local perks = {
    {
        id = "",
        tags = {}, --automatic dependecy check + sorting
        is_locked = false, --hybrid function
        is_hidden = false, --hybrid function

        name = "",
        desc = "",
        tier = "Baseline", --Trivial, Baseline, Hardcore, Absurd, Special
        
        value = 0,
        icon = "", --png or function

        setup_pre = function( class, char_id, perk )
        end,
        setup = "", --vanilla id or function 
        setup_post = function( class, char_id, perk )
        end,
    },
}

--<{> MAGIC APPEND MARKER <}>--

return perks