local module_filepath = "mods/noita.thingsmod/content/spells_module/"

return {
	name = "Spells Module",
	description = "Adds new spells to the game.",
	authors = "Conga Lyne",
	OnModPreInit = function () 

	end,
	OnModInit = function ()
		--Ensure this flag is never enabled
		RemoveFlagPersistent("this_should_never_spawn")

		local translations = ModTextFileGetContent("data/translations/common.csv")
		local new_translations = ModTextFileGetContent(module_filepath .. "translations.csv")
		translations = translations .. "\n" .. new_translations .. "\n"
		translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
		ModTextFileSetContent("data/translations/common.csv", translations)

		ModLuaFileAppend("data/scripts/gun/gun_actions.lua", module_filepath .. "scripts/gun/actions.lua")

		ModLuaFileAppend("data/scripts/gun/gun.lua", module_filepath .. "scripts/gun/gun.lua")
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
