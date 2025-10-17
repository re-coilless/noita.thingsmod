local classes = {
    {
        id = "",
        tags = {}, --automatic dependecy check + sorting
        is_locked = false, --hybrid function
        is_hidden = false, --hybrid function

        name = "",
        desc = "",
        type = "Mina", --for cosmetic checks
        tier = "Baseline", --Trivial, Baseline, Hardcore, Absurd, Special
        icon = "", --png or function
        
        skin = "", --map or function
        setup_pre = function( class, char_id )
        end,
        ctrl = function( class, char_id ) --runs every frame
        end,
        setup_post = function( class, char_id )
        end,

        cosmetics = {},
        perks = {},
        items = {},

        --settings
        --stats
    },

    --[BASIC] (two wands, two items; each class is unlocked upon reaching the corresponding biome)
    --Surface (normal start)
    --Mines (light)
    --Coal Pits (mining)
    --Snowy Depths (fire)
    --Hiisi Base (explosions)
    --Underground Jungle (homing)
    --The Vault (electricity)
    --Temple of the Art (melee)
    --The Laboratory (alchemy)
    
    --[ADVANCED] (random one is unlocked each time after beating the game)
    --Greed Beast (gains and uses insane amounts of gold, also haunted by the greed demon)
    --Battlemage (slow single shot wand builds that function like guns with lots of explosions)
    --Speed Freak (kills by movement, thanks Copi)
    --Envy Posessed (start with a single persistent wisp that you upgrade by casting modifier spells, casting any other projectile turns the wisp hostile and buffs it)
    --Lukki Abomination (normal lukki that has an ability to hold two exta wands if Index is installed)
    --[Index] Hiisi Commando (assault rifle and shotgun, only two wand slots but 6 item slots)
    --[Index] Pilgrim (no wand/spell slots but 12 item slots that are all filled at the start, thanks Copi)
    --[Index] Monk (no wand/spell slots and only a single items slot that is filled with a controllable tablet, also telekinesis perk)

    --add debug class that only appears if run through dev.exe
}

-- parent = "", --weighted chances of being selected

--<{> MAGIC APPEND MARKER <}>--

return classes