---@type string[]
local modules = dofile_once("mods/noita.thingsmod/content.lua")

local extra_translations = ""

for _, module in ipairs(modules) do
	local translations_path = ("mods/noita.thingsmod/content/%s/translations.csv"):format(module)
	if not ModDoesFileExist(translations_path) then goto continue end
	local new_translations = ModTextFileGetContent(translations_path)
	local prefix = ("noita_thingsmod_%s_"):format(module)
	extra_translations = extra_translations
		.. "\n"
		.. new_translations
			:gsub("^,en[^\n]*", "")
			:gsub("^\n*", "\n")
			:gsub("\n", "\n" .. prefix)
			:gsub(prefix .. "$", "\n")
		.. "\n"
	::continue::
end

local translations = ModTextFileGetContent("data/translations/common.csv")
translations = translations .. extra_translations
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)

local function do_callback(callback_name, ...)
	for _, module in ipairs(modules) do
		local mod = dofile_once("mods/noita.thingsmod/content/" .. module .. "/module.lua")
		if mod and mod[callback_name] then
			local success, error_msg = pcall(mod[callback_name], ...)
			if not success then print(mod.name .. " Error: " .. error_msg) end
		end
	end
end

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
	"OnPlayerSpawned",
	"OnWorldInitialized",
	"OnWorldPostUpdate",
	"OnWorldPreUpdate",
}

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
