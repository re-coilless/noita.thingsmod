local nxml = require "lib/nxml/nxml"
local module_filepath = "mods/noita.thingsmod/content/simple_perks/"

---@type Module
local M = {
	name = "Conga Stuff",
	description = "Adds stuff",
	authors = "Conga Lyne",
	OnModPreInit = function () 
		for k=1,30 do
			print("aaaaaaaaaaaaaaaaaaaaaaa")
		end
	end,
	OnModInit = function () 
		-- Custom Perk support injection
		ModLuaFileAppend("data/scripts/perks/perk_list.lua", module_filepath .. "scripts/perks/custom_perks.lua")

		--Appending extra modifiers
		ModLuaFileAppend("data/scripts/gun/gun_extra_modifiers.lua", module_filepath .. "scripts/gun/gun_extra_populator.lua")

		--Player Editor
		for content in nxml.edit_file("data/entities/player_base.xml") do
			content:add_child(
				nxml.new_element("LuaComponent", {
					script_damage_about_to_be_received = "mods/noita.thingsmod/content/simple_perks/scripts/perks/take_damage.lua",
					execute_every_n_frame = -1,
					execute_times = -1,
					remove_after_executed = false,
				})
			)
		end
	end,

	OnModPostInit = function () 

	end,

	OnPlayerSpawned = function ( player_entity ) 

	end,

	OnPlayerDied = function ( player_entity ) 

	end,

	OnWorldInitialized = function () 

	end,

	OnWorldPreUpdate = function () 

	end,

	OnWorldPostUpdate = function () 

	end,

	OnBiomeConfigLoaded = function () 

	end,

	OnMagicNumbersAndWorldSeedInitialized = function () 
		
	end,

	OnPausedChanged = function ( is_paused, is_inventory_pause ) 

	end,

	OnModSettingsChanged = function () 

	end,

	OnPausePreUpdate = function () 

	end
}

return M
