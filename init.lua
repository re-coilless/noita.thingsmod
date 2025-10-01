local content_library = dofile_once("mods/noita.thingsmod/content.lua")

local function register_callbacks()
	for _, module_id in ipairs(content_library) do
		local mod = dofile_once("mods/noita.thingsmod/content/" .. module_id .. "/module.lua")
		if mod then
			for callback_name, callback_func in pairs(mod) do
				if type(callback_func) ~= "function" then
					goto continue
				end

				local curr_global = _G[callback_name]
				if type(curr_global) == "function" then
					_G[callback_name] = function(...)
						curr_global(...)
						return callback_func(...)
					end
				else
					_G[callback_name] = callback_func
				end

				::continue::
			end
		end
	end
end

register_callbacks()
