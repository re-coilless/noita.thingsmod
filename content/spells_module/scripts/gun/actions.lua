-- some mod seems to cause issues if require is defined, CE?
local _require = require
dofile("mods/noita.thingsmod/require.lua")
local table_utils = require "lib.table_utils.table_utils"

local custom_spellappends = {
	{
		id          = "MONO_CAST",
		id_prepend  = "BURST_2",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1",
		spawn_probability                 = "0.1,0.1",
		author = "Conga Lyne",
		price = 100,
		mana = 0,
		action 		= function()
			do return end
            if ( #deck > 0 ) then
                
                local function isSpellPresent(table_to_search,id)
                    for i=1,#table_to_search do
                        if table_to_search[i] == id then return true end
                    end
                    return false
                end

                local function banishDuplicatespells(table_to_search)
                    local duplicates = {}
                    local table_of_first_appearances = {}
                    local data = {}
                    for k=1,#table_to_search do
                        local pos = k
                        
                        if isSpellPresent(table_of_first_appearances,table_to_search[pos].id) then
                            --discard from deck
                            --Add to discard
                            data = table_to_search[pos]
                            table.insert( duplicates, pos )
                            --table.insert( discarded, data )
                        elseif table_to_search[pos].uses_remaining == nil or table_to_search[pos].uses_remaining ~= 0 then
                            --Add to first appearances
                            table.insert( table_of_first_appearances, table_to_search[pos].id)
                        end
                    end

                    if #duplicates > 0 then
                        for k=1,#duplicates do
                            local pos = #duplicates+1 - k
                            table.insert( discarded, table_to_search[duplicates[pos]] )
                            table.remove( table_to_search, duplicates[pos] )
                        end
                    end
                    return table_to_search
                end

                deck = banishDuplicatespells(deck)
                hand = banishDuplicatespells(hand)
            end

            draw_actions( 1, true ) 
		end,
	},
    {
        id          = "COGWORK_SENTINEL",
        type 		= ACTION_TYPE_PROJECTILE,
        spawn_level                       = "4,5,10", -- WYRM
        spawn_probability                 = "0.05,0.05,0.1", -- WYRM
        author = "Conga Lyne",
        price = 220,
        mana = 120,
        related_projectiles	= {"mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/cogwork_sentinel_projectile.xml", 1},
        pandorium_ignore = true,
        action 		= function()
            if reflecting then
                add_projectile( "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/cogwork_sentinel_projectile.xml" ) --Sentinel's Projectile Filepath
                current_reload_time = current_reload_time + 60
                return
            end

            local c_old = c

            BeginProjectile( "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/trigger_projectile.xml" ) --Dummy
                BeginTriggerDeath()
                    WriteCToDatat(c_old)

                    BeginProjectile( "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/cogwork_sentinel.xml" ) --Sentinel
                    EndProjectile()
                    register_action({
                        --Hacky but functional, I'm probably wildly misusing this -Conga
                        action_description = DontTouch_Data[2],
                        lifetime_add = c_old["lifetime_add"],
                    })
                    SetProjectileConfigs()
                EndTrigger()
            EndProjectile()
            current_reload_time = current_reload_time + 60
        end,
    },
    {
	    id          = "AIR_BLAST",
	    related_projectiles	= {"mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/airblast.xml"},
	    type 		= ACTION_TYPE_STATIC_PROJECTILE,
	    spawn_level                       = "0,1,3,5",
	    spawn_probability                 = "0.5,0.7,0.6,0.4",
        author = "utterrn",
	    price = 120,
	    mana = 10,
	    is_dangerous_blast = true,
	    action 		= function()
	    	add_projectile("mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/airblast.xml")
	    	c.fire_rate_wait = c.fire_rate_wait + 3
	    	c.screenshake = c.screenshake + 0.5
	    end,
    },
    {
	    id          = "SEA_CEMENT",
	    type 		= ACTION_TYPE_MATERIAL,
	    spawn_level                       = "2,3,5", 
	    spawn_probability                 = "0.03,0.08,0.4",
        author = "utterrn",
	    price = 350,
	    mana = 140,
	    max_uses = 3,
	    action 		= function()
		add_projectile("mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/sea_cement.xml")
		c.fire_rate_wait = c.fire_rate_wait + 15
	    end,
    },
    {
		id          = "AIR_RAY_ENEMY",
		related_extra_entities = { "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/hitfx_air_ray_enemy.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5",
		spawn_probability                 = "0.5,0.6,0.4,0.3",
        author = "utterrn",
		price = 100,
		mana = 80,
		max_uses = 20,
		action 		= function()
			c.extra_entities = c.extra_entities .. "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/hitfx_air_ray_enemy.xml,"
			draw_actions( 1, true )
		end,
    },
    {
		id          = "ROCK_SLINGER",
		related_extra_entities = { "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/light_bullet_rock.xml" },
		type = ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- BUCKSHOT
		spawn_probability                 = "1,1,0.9,0.9,0.6", -- BUCKSHOT
        author = "utterrn",
		price = 100,
		mana = 7,
		action = function()
        add_projectile("mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/rock_slinger.xml")
        c.fire_rate_wait = c.fire_rate_wait - 3
        end,
    },

}

for _, v in ipairs(custom_spellappends) do
	local id_lower = v.id:lower()
	v.name = "$noita_thingsmod_spells_module_actionname_" .. id_lower
	v.description = "$noita_thingsmod_spells_module_actiondesc_" .. id_lower
	v.sprite = ("mods/noita.thingsmod/content/spells_module/ui_gfx/gun_actions/%s.png"):format(id_lower)
	v.id = "NOITA_THINGSMOD_" .. v.id
	v.author = v.author or "Every Things Dev Team"
	v.mod = v.mod or "Every Things"
end

table_utils.positional_insert(actions, custom_spellappends)
require = _require
