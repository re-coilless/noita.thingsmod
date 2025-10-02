---@diagnostic disable: lowercase-global
---To use, make sure that your context does
---```lua
---dofile_once("mods/noita.thingsmod/require.lua")
---```
---at the start.
function require(modname)
	return dofile_once(("mods/noita.thingsmod/%s.lua"):format(modname:gsub("%.", "/")))
end

---The current module
---@type string
NOITATHINGS_MODULE = "example"

---Converts a filepath like `scripts/whatever.lua` to `mods/noita.thingsmod/content/MODULE_ID/scripts/whatever.lua`
---
---To use, make sure that your context does
---```lua
---dofile_once("mods/noita.thingsmod/require.lua")
---NOITATHINGS_MODULE = "example" -- if you are in the init content this is done for you
---```
---at the start.
function modpath(relative_path)
	return ("mods/noita.thingsmod/content/%s/%s"):format(NOITATHINGS_MODULE, relative_path)
end
