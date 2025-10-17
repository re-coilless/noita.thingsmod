local cosmetics = {
    {
        id = "",
        tags = {}, --automatic dependecy check + sorting
        is_locked = false, --hybrid function
        is_hidden = false, --hybrid function

        name = "",
        desc = "",
        type = "Mina",
        icon = "", --png or function
        
        setup_pre = function( class, char_id, cosmetic, cosmetic_id )
        end,
        setup = "", --spritesheet or xml def table or function
        setup_post = function( class, char_id, cosmetic, cosmetic_id )
        end,
    },

    --cape, crown, amulet are cosmetics
}

--<{> MAGIC APPEND MARKER <}>--

return cosmetics