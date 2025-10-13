local items = dofile_once("mods/component-explorer/spawn_data/items.lua")

table.insert(items,
    {
        file = "mods/noita.thingsmod/content/good_book_of_cats/entities/book.xml",
        item_name = "The Good Book of Cats",
        origin = "noita.thingsmod",
        tags = "teleportable_NOT,sampo_or_boss,this_is_sampo"
    }
)
