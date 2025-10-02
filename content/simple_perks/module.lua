local nxml = dofile_once("mods/Apotheosis/lib/nxml.lua")
local module_filepath = "mods/noita.thingsmod/content/simple_perks/"

return {
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
		do
			local path = "data/entities/player_base.xml"
				local xml = nxml.parse(ModTextFileGetContent(path))
				xml:add_child(nxml.parse([[
				<LuaComponent
				script_damage_about_to_be_received="mods/noita.thingsmod/content/simple_perks/scripts/perks/take_damage.lua"
				execute_every_n_frame="-1"
				execute_times="-1"
				remove_after_executed="0"
				>
				</LuaComponent>
				]]))
			ModTextFileSetContent(path, tostring(xml))
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
