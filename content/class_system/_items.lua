local items = {
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
        tip = function( item, item_id ) --shows default wand tip if left as nil
        end,

        setup_pre = function( class, char_id, item, item_id )
        end,
        setup = "", --xml or wand def table or function
        setup_post = function( class, char_id, item, item_id )
        end,
    },
}

--<{> MAGIC APPEND MARKER <}>--

return items