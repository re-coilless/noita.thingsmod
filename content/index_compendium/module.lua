return {
	name = "Index Compendium",
	description = "A bunch of fancy HermeS Index stuff.",
	authors = "Bruham",
	
	OnThingsCalled = function( modules ) print("test1") return true end,
	OnWorldPreUpdate = function() print("test2") end,
}