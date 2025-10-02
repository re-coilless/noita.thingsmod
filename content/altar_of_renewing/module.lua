return {
	name = "Altar of Renewing",
	description = "Altar that resets the world with a new seed. Surely this will have no repercussions.",
	authors = "Evaisa",
	OnModPreInit = function () 
		ModLuaFileAppend("data/scripts/biomes/coalmine.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/coalmine.lua")
		ModLuaFileAppend("data/scripts/biomes/excavationsite.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/excavationsite.lua")
		ModLuaFileAppend("data/scripts/biomes/crypt.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/crypt.lua")
		ModLuaFileAppend("data/scripts/biomes/pyramid.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/pyramid.lua")
		ModLuaFileAppend("data/scripts/biomes/rainforest.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/rainforest.lua")
		ModLuaFileAppend("data/scripts/biomes/snowcastle.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/snowcastle.lua")
		ModLuaFileAppend("data/scripts/biomes/snowcave.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/snowcave.lua")
		ModLuaFileAppend("data/scripts/biomes/vault.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/vault.lua")
		if ModIsEnabled("VolcanoBiome") then
			ModLuaFileAppend("mods/VolcanoBiome/files/biome/inside.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/volcanobiome.lua")
		end
		if ModIsEnabled("biome-plus") then
			ModLuaFileAppend("data/scripts/biomes/mod/blast_pit.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/blast_pit.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/floodcave.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/floodcave.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/frozen_passages.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/frozen_passages.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/holy_temple.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/holy_temple.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/rainforest_wormy.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/rainforest_wormy.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/robofactory.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/robofactory.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/snowvillage.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/snowvillage.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/swamp.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/swamp.lua")
		end
		if ModIsEnabled("noitavania") then
			ModLuaFileAppend("data/scripts/biomes/coalmine_alt.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/coalmine_alt.lua")
		end
	end
}
