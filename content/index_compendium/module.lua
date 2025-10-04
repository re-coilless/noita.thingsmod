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
			--if( disabled_modules[ "good_book_of_cats" ]) then return end
			--Katydid pic: https://fieldsofmistria.wiki.gg/wiki/Singing_Katydid
			--Caterpillar pic: https://fieldsofmistria.wiki.gg/wiki/Inchworm
			--Book UI: https://www.deviantart.com/thisguy1045/art/Minecraft-Mod-Book-GUI-346997700

			local book_markers = { "<Entity name=\"cat_book\">", "\"\n.-></ItemComponent>" }
			local book_path = "mods/noita.thingsmod/content/good_book_of_cats/entities/book.xml"
			local book_file = string.gsub( pen.magic_read( book_path ), book_markers[1], "<Entity name=\"cat_book\" tags=\"forgeable\">" )
			book_file = string.gsub( book_file, book_markers[2], "You feel like throwing it into a forge... \"\n   ></ItemComponent>" )
			pen.magic_write( book_path, book_file )

			local pic_marker = "mods/noita%.thingsmod/content/good_book_of_cats/gfx/book%.png"
			book_file = string.gsub( book_file, pic_marker, "mods/noita.thingsmod/content/index_compendium/files/cats/item_K.png" )
			pen.magic_write( "mods/noita.thingsmod/content/index_compendium/files/cats/item_K.xml", book_file )

			local forge_marker = "\nif converted then"
			local forge_path = "data/scripts/buildings/forge_item_convert.lua"
			local forge_file = pen.magic_read( forge_path )
			forge_file = string.gsub( forge_file, forge_marker, [[
				local cats = EntityGetWithName( "cat_book" ) or 0
				if( cats > 0 ) then
					local id = cats
					local is_free = EntityGetRootEntity( id ) == id
					local shape_file = ComponentGetValue2( EntityGetFirstComponentIncludingDisabled( id, "PhysicsImageShapeComponent" ), "image_file" )
					local is_cats = shape_file == "mods/noita.thingsmod/content/good_book_of_cats/gfx/book.png"
					if( is_free and is_cats ) then
						local x,y = EntityGetTransform( id )
						local new_id = EntityLoad( "mods/noita.thingsmod/content/index_compendium/files/cats/item_K.xml", x, y )
						EntityKill( id )

						local info_comp = EntityGetFirstComponentIncludingDisabled( new_id, "UIInfoComponent" )
						local abil_comp = EntityGetFirstComponentIncludingDisabled( new_id, "AbilityComponent" )
						local item_comp = EntityGetFirstComponentIncludingDisabled( new_id, "ItemComponent" )
						local pic_comp = EntityGetFirstComponentIncludingDisabled( new_id, "SpriteComponent" )
						local lua_comp = EntityGetFirstComponentIncludingDisabled( new_id, "LuaComponent" )
						
						local name = "The Good Book of Kats"
						ComponentSetValue2( info_comp, "name", name )
						ComponentSetValue2( abil_comp, "ui_name", name )
						ComponentSetValue2( item_comp, "item_name", name )
						ComponentSetValue2( item_comp, "ui_description", "It seems the forging has failed...\nDon't worry though, you can still salvage this with a little bit of emerald magic." )

						EntityRemoveComponent( new_id, lua_comp )
						EntityRemoveTag( new_id, "forgeable" )

						EntityAddComponent2( new_id, "VariableStorageComponent", {
							name = "on_tooltip",
							value_string = "mods/noita.thingsmod/content/index_compendium/files/cats/tip.lua",
						})

						converted = true
					end
				end]]..forge_marker )
			pen.magic_write( forge_path, forge_file )

			--GBK + Tablet -> BBC
			--BBC gets converted only after the Kat book has been picked by player
			--add on_slot script to kat book that searches for tablets in inventory (normal_tablet) and then gives itself forgeable tag
			
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
		EntityLoad( "data/entities/buildings/forge_item_check.xml", x + 10, y )
		EntityLoad( "data/entities/items/books/book_00.xml", x - 50, y )
	end,
}

return M