local content_library = dofile_once("mods/noita.thingsmod/content.lua")

local function register_callbacks()
	for _, module_id in ipairs(content_library) do
		local mod = dofile_once("mods/noita.thingsmod/content/" .. module_id .. "/module.lua")
		if mod.callbacks then
			for callback_name, callback_func in pairs(mod.callbacks) do
				_G[callback_name] = callback_func
			end
		end
	end
end
register_callbacks()