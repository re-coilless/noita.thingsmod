function spawn_altar_of_renewing(x, y, no_spawner_pixels)
	local w = 184
	local h = 96
	local s = ""
	if no_spawner_pixels == true then
		s = "_no_spawner_pixels"
	end
	LoadPixelScene("mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/altar" .. s .. ".png", "mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/altar_visual.png", x - (w / 2), y - h + 1, "", true )
	print("did this shit even run?")
end

function spawn_altar(x, y)
	local h = 30

	EntityLoad("mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/altar.xml", x + 6, y - h + 1)
	print("did this shit even run? 2")
end