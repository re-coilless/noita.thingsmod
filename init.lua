local content_library = dofile_once("mods/noita.thingsmod/content.lua")

local callback_names = {
  "OnBiomeConfigLoaded",
  "OnCountSecrets",
  "OnMagicNumbersAndWorldSeedInitialized",
  "OnModInit",
  "OnModPostInit",
  "OnModPreInit",
  "OnModSettingsChanged",
  "OnPausePreUpdate",
  "OnPausedChanged",
  "OnPlayerDied",
  "OnWorldInitialized",
  "OnWorldPostUpdate",
  "OnWorldPreUpdate",
}

local function do_callback(callback_name, ...)
	for _, module_id in ipairs(content_library) do
		local mod = dofile_once("mods/noita.thingsmod/content/" .. module_id .. "/module.lua")
		if mod and mod[callback_name] then
			local success, error_msg = pcall(mod[callback_name], ...)
			if not success then
				print(mod.name .. " Error: " .. error_msg)
			end
		end
	end
end

for _, callback_name in ipairs(callback_names) do
	_G[callback_name] = function(...)
		do_callback(callback_name, ...)
  	end
end

function OnPlayerSpawned(...)
	do_callback("OnPlayerSpawned", ...)
	local flag = "NOITA_THINGSMOD_PLAYER_SPAWN_DONE"
	if GameHasFlagRun(flag) then return end
	GameAddFlagRun(flag)
	do_callback("OnPlayerFirstSpawned", ...)
end
