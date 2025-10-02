function spawn_altar_of_renewing(x, y, no_spawner_pixels)
	local w = 184
	local h = 96
	local s = ""
	if no_spawner_pixels == true then
		s = "_no_spawner_pixels"
	end
	LoadPixelScene("mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/altar" .. s .. ".png", "mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/altar_visual.png", x - (w / 2), y - h + 1, "", true )
end

function spawn_altar(x, y)
	
end