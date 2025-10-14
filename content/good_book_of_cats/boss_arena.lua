local original_EntityLoad = EntityLoad

function EntityLoad(name, ...)
    if name == "data/entities/animals/boss_centipede/sampo.xml" then
        name = "mods/noita.thingsmod/content/good_book_of_cats/entities/book.xml"
    end
    return original_EntityLoad(name, ...)
end
