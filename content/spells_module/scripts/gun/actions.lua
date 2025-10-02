custom_spellappends = {
	{
		id          = "MONO_CAST",
        id_prepend  = "BURST_2",
		name 		= "$spell_thingsmod_mono_cast_name",
		description = "$spell_thingsmod_mono_cast_desc",
        sprite 		= "mods/noita.thingsmod/content/spells_module/ui_gfx/gun_actions/mono_cast.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sea_acid_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1",
		spawn_probability                 = "0.1,0.1",
        author = "Conga Lyne",
		price = 100,
		mana = 0,
		action 		= function()
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
    --[[
    ]]--
    {
        id          = "COGWORK_SENTINEL",
        name 		= "$spell_thingsmod_cogwork_sentinel_name",
        description = "$spell_thingsmod_cogwork_sentinel_desc",
        sprite 		= "mods/noita.thingsmod/content/spells_module/ui_gfx/gun_actions/cogwork_sentinel.png",
        sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
        related_projectiles	= {"mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/cogwork_sentinel_projectile.xml", 1},
        type 		= ACTION_TYPE_PROJECTILE,
        spawn_level                       = "4,5,10", -- WYRM
        spawn_probability                 = "0.05,0.05,0.1", -- WYRM
        author = "Conga Lyne",
        price = 220,
        mana = 120,
        pandorium_ignore = true,
        action 		= function()
            if reflecting then
                Reflection_RegisterProjectile( "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/cogwork_sentinel_projectile.xml" ) --Sentinel's Projectile Filepath
                current_reload_time = current_reload_time + 20
                return
            end

            c_old = c

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
}



function append_thingsmod_spells()
    for k=1,#custom_spellappends do
        local v = custom_spellappends[k]
        v.id = "NOITA_THINGSMOD_" .. v.id
        v.author    = v.author  or "Mod Name Dev Team"
        v.mod       = v.mod     or "Mod Name Mod"
        if v.id_append == nil and v.id_prepend == nil then
            table.insert(actions,v)
        else
            for z=1,#actions
            do c = actions[z]
                if c.id == v.id_prepend then
                    table.insert(actions,z,v)
                    break
                elseif c.id == v.id_append or z == #actions then
                    table.insert(actions,z + 1,v)
                    break
                end
            end
        end
    end
end

if actions ~= nil then
    append_thingsmod_spells()
end


--Modifying Vanilla spells
--Recursion = Greek letters
--Iteration = divide by

--Function for modifying existing spells
function modify_existing_spell(spell_id, parameter_to_modify, new_value)
	for i, spell in ipairs(actions) do
		if spell.id == spell_id then
			spell[parameter_to_modify] = new_value
			break
		end
	end
end

function spell_rebalances()
    if actions_to_edit == nil then return end
    for i=1,#actions do -- fast as fuck boi
        if actions_to_edit[actions[i].id] and (true == true or actions_to_edit[actions[i].id].mandatory_addition) then
            for key, value in pairs(actions_to_edit[actions[i].id]) do
                actions[i][key] = value
            end
            actions[i]['thingsmod_reworked'] = true
        end
    end
end

if actions ~= nil then
    spell_rebalances()
end
