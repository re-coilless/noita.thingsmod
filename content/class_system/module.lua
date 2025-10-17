---@type Module
local M = {
	name = "Class System",
	description = "Customize the starting character.",
	authors = { "Bruham" },

	OnThingsCalled = function()
		if( ModIsEnabled( "mnee" )) then
			dofile_once( "mods/mnee/lib.lua" )
		else dofile_once( "mods/noita.thingsmod/lib/_penman.lua" ) end
		pen.lib.nxml = dofile_once( "mods/noita.thingsmod/lib/nxml/nxml.lua" )
	end,
	OnPlayerSpawned = function()
		local cosmetics = dofile_once( "mods/noita.thingsmod/content/class_system/_cosmetics.lua" )
		local perks = dofile_once( "mods/noita.thingsmod/content/class_system/_perks.lua" )
		local items = dofile_once( "mods/noita.thingsmod/content/class_system/_items.lua" )
		local classes = dofile_once( "mods/noita.thingsmod/content/class_system/_classes.lua" )

		if( true ) then return end

		--index classes should run through actual index init (or figure out a way to make this better)
		local data = pen.lib.player_builder( hooman, function( hooman, data ) --make sure it actually builds a usable vanilla char
			--setup skin
			return data
		end)
		
		local perks = pen.t.add( pen.t.clone( char_data.perks or section_data.perks ), char_data.perks_add )
		pen.t.loop( perks, function( i, v )
			if( pen.vld( pen.t.get( char_data.perks_remove, v ), true )) then return end
			data = n40.new_perk( v, hooman, data )
		end)
		pen.lib.set_matter_damage( hooman, data )

		--cosmetics

		--break the loop if exceeds the inv size
		local items = pen.t.add( pen.t.clone( char_data.items or section_data.items ), char_data.items_add )
		pen.t.loop( items, function( i, v ) n40.new_item( n40.ITEMS[v], hooman, data ) end)
		
		--custom wands (make sure custom items are supported)
		--custom skins with in-game painting (cb square, hue and alpha)
	end,
}

return M