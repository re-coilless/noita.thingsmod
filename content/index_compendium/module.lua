---@type Module
local M = {
	name = "Index Compendium",
	description = "A bunch of fancy HermeS Index stuff.",
	authors = { "Bruham" },
	
	OnThingsCalled = function( modules )
		if( ModIsEnabled( "index_core" )) then
			dofile_once( "mods/index_core/files/_lib.lua" )
		else return true end
	end,
	OnModInit = function()
		pen.hallway( function()
			if( disabled_modules[ "good_book_of_cats" ]) then return end
			--Katydid pic: https://fieldsofmistria.wiki.gg/wiki/Singing_Katydid
			--Caterpillar pic: https://fieldsofmistria.wiki.gg/wiki/Inchworm
			--Book UI: https://www.deviantart.com/thisguy1045/art/Minecraft-Mod-Book-GUI-346997700

			local book_marker = "\"\n.-></ItemComponent>"
			local book_path = "mods/noita.thingsmod/content/good_book_of_cats/entities/book.xml"
			local book_file = pen.magic_read( book_path )
			book_file = string.gsub( book_file, book_marker, "You feel like throwing it into a forge... \"\n   ></ItemComponent>" )
			pen.magic_write( book_path, book_file )

			local forge_marker = "\nif converted then\nGameTriggerMusicFadeOutAndDequeueAll%( 3%.0 %)\nGameTriggerMusicEvent%( \"music/oneshot/dark_01\", true, pos_x, pos_y %)\nend"
			local forge_path = "data/scripts/buildings/forge_item_convert.lua"
			local forge_file = pen.magic_read( forge_path )
			forge_file = string.gsub( forge_file, forge_marker, [[
				for _,id in pairs( EntityGetInRadiusWithTag( pos_x, pos_y, 70, "tablet" )) do
					local is_free = EntityGetRootEntity( id ) == id
					local shape_comp = EntityGetFirstComponentIncludingDisabled( id, "PhysicsImageShapeComponent" )
					local shape_file = ComponentGetValue2( shape_comp, "image_file" )
					local is_cats = shape_file == "mods/noita.thingsmod/content/good_book_of_cats/gfx/book.png"
					if( is_free and is_cats ) then
						local x,y = EntityGetTransform( id )
						local new_id = EntityLoad( "mods/noita.thingsmod/content/good_book_of_cats/entities/book.xml", x, y )
						EntityKill( id )

						local info_comp = EntityGetFirstComponentIncludingDisabled( new_id, "UIInfoComponent" )
						local abil_comp = EntityGetFirstComponentIncludingDisabled( new_id, "AbilityComponent" )
						local item_comp = EntityGetFirstComponentIncludingDisabled( new_id, "ItemComponent" )
						local shape_comp = EntityGetFirstComponentIncludingDisabled( new_id, "PhysicsImageShapeComponent" )
						local pic_comp = EntityGetFirstComponentIncludingDisabled( new_id, "SpriteComponent" )
						local lua_comp = EntityGetFirstComponentIncludingDisabled( new_id, "LuaComponent" )
						
						local name = "The Good Book of Kats"
						ComponentSetValue2( info_comp, "name", name )
						ComponentSetValue2( abil_comp, "ui_name", name )
						ComponentSetValue2( item_comp, "item_name", name )
						ComponentSetValue2( item_comp, "ui_description", "It seems the forging has failed...\nDon't worry though, you can still salvage this with a little bit of emerald magic." )
						
						local pic = "mods/noita.thingsmod/content/index_compendium/files/cats/item_K.png"
						ComponentSetValue2( shape_comp, "image_file", pic )
						ComponentSetValue2( item_comp, "ui_sprite", pic )
						ComponentSetValue2( pic_comp, "image_file", pic )

						EntityRemoveComponent( new_id, lua_comp )

						converted = true
					end
				end]]..forge_marker )
			pen.magic_write( forge_path, forge_file )

			--GBK + Tablet in inv -> BBC
			--BBC gets converted only after the Kat book has been picked by player
			
			--The Best Book of Cats "A book containing pictures of cats. So very precious."
			--disclaimer that not all photos are accurate (some species are incredibly hard to source good pictures of in both forms)
			--pet counter that is stored in the settings
			--page flipping sound
		end)

		pen.hallway( function()
			if( not( ModIsEnabled( "spoopy_inv" ))) then return end
		end)
	end,
	
	OnPlayerSpawned = function( hooman )
		local x, y = EntityGetTransform( hooman )
		EntityLoad( "data/entities/buildings/forge_item_check.xml", x - 10, y )
	end,
}

return M