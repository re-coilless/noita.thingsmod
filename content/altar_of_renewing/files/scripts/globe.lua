function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local x, y = EntityGetTransform(entity_who_interacted)
	SetRandomSeed(x, y + GameGetFrameNum())
	local seed = Random(1, 2147483646) + Random(1, 2147483646)
	SetWorldSeed(seed)
	BiomeMapLoad_KeepPlayer(MagicNumbersGetValue("BIOME_MAP"), "data/biome/_pixel_scenes")
end