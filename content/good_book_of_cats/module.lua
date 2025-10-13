local gui_options = require "lib.gui.gui_options"
local nxml = require "lib.nxml.nxml"

---@type Module
local M = {
    name = "The Good Book of Cats",
    description = "Adds the Good Book of Cats",
    authors = { "dextercd" },
}

local gui

local cats = {
    {
        img = "mods/noita.thingsmod/cats/skittle.png",
        name = "Skittle"
    },
    {
        img = "mods/noita.thingsmod/cats/evil_beast.png",
        name = "Evil Beast",
    },
    {
        img = "mods/noita.thingsmod/cats/alesx_droolemoji.png",
        name = "Alex",
    },
    {
        img = "mods/noita.thingsmod/cats/james.png",
        name = "James",
    },
    {
        img = "mods/noita.thingsmod/cats/monty.png",
        name = "Monty",
    },
    {
        img = "mods/noita.thingsmod/cats/roger.png",
        name = "Roger",
    },
    {
        img = "mods/noita.thingsmod/cats/ella.png",
        name = "Ella",
    },
    {
        img = "mods/noita.thingsmod/cats/rip_princess.png",
        name = "Princess",
    },
}

function M.OnModInit()
    gui = GuiCreate()

    for content in nxml.edit_file("data/entities/animals/boss_centipede/boss_centipede.xml") do
        content:create_child("SpriteComponent", {
            image_file="mods/noita.thingsmod/content/good_book_of_cats/gfx/kolmi_ears.png",
            offset_y=tostring(48 + 24),
            offset_x="48",
            z_index="1",
        })
        content:create_child("SpriteComponent", {
            image_file="mods/noita.thingsmod/content/good_book_of_cats/gfx/kolmi_whiskers.png",
            offset_y=tostring(48 + 24),
            offset_x="48",
            z_index="0.8",
        })
    end

    ModLuaFileAppend("data/scripts/biomes/boss_arena.lua", "mods/noita.thingsmod/content/good_book_of_cats/boss_arena.lua")
end

local page_nr = 1

local text_offset = 5

local function draw_cat(cat, x, y, width)
    GuiIdPushString(gui, "CAT" .. cat.img)
    local cat_width, cat_height = GuiGetImageDimensions(gui, cat.img)
    local scale = width / cat_width

    GuiImage(gui, 0, x, y, cat.img, 1, scale)

    local height = cat_height * scale
    local text_x = x + text_offset
    local text_y = y + height + text_offset
    GuiColorSetForNextWidget(gui, 0.1, 0.1, 0.1, 1)
    GuiText(gui, text_x, text_y, cat.name)
    GuiIdPop(gui)
end

local function was_clicked()
    local clicked = GuiGetPreviousWidgetInfo(gui)
    return clicked
end

local function was_hovered()
    local _, _, hovered = GuiGetPreviousWidgetInfo(gui)
    return hovered
end

-- Couldn't figure out how to center text on a GuiImageButton
local btn_hovered = {}
local function draw_book_button(name, x, y)
    GuiIdPushString(gui, "BUTTON" .. name)

    local scale = btn_hovered[name] and 1.25 or 1
    local clicked = false

    -- x/y correction when scale is increased so that the increase is centered
    local img_width, img_height = GuiGetImageDimensions(gui, "mods/noita.thingsmod/content/good_book_of_cats/gfx/button.png", scale)
    if scale ~= 1 then
        local orig_width, orig_height = GuiGetImageDimensions(gui, "mods/noita.thingsmod/content/good_book_of_cats/gfx/button.png")

        x = x - (img_width - orig_width) / 2
        y = y - (img_height - orig_height) / 2
    end

    -- button image
    GuiImage(gui, 0, x, y, "mods/noita.thingsmod/content/good_book_of_cats/gfx/button.png", 100, scale)
    btn_hovered[name] = was_hovered()
    clicked = was_clicked()

    -- button text
    local text_width, text_height = GuiGetTextDimensions(gui, name, scale)
    local text_x = x + img_width / 2 - text_width / 2
    local text_y = y + img_height / 2 - text_height / 2
    GuiText(gui, text_x, text_y, name, scale)
    btn_hovered[name] = btn_hovered[name] or was_hovered()
    clicked = clicked or was_clicked()

    GuiIdPop(gui)
    return clicked
end

local function draw_book()
    local ui_width, ui_height = GuiGetScreenDimensions(gui)
    local img_width, img_height = GuiGetImageDimensions(gui, "mods/noita.thingsmod/content/good_book_of_cats/gfx/book_ui.png")

    local scale = ui_height / img_height * 0.9
    local book_y = ui_height * 0.05
    local book_x = (ui_width - img_width * scale) / 2

    GuiZSet(gui, 500)
    GuiImage(gui, 220, book_x, book_y, "mods/noita.thingsmod/content/good_book_of_cats/gfx/book_ui.png", 1, scale)
    GuiZSet(gui, 300)

    local book_width = img_width * scale
    local book_height = img_height * scale

    local page_width = book_width * 0.5
    local picture_width = page_width * 0.7

    if cats[page_nr] then
        draw_cat(cats[page_nr], ui_width * 0.5 - picture_width - 11, book_y + 45, picture_width)
    end

    if cats[page_nr+1] then
        draw_cat(cats[page_nr+1], ui_width * 0.5 + 24, book_y + 60, picture_width)
    end

    local button_width, button_height = GuiGetImageDimensions(gui, "mods/noita.thingsmod/content/good_book_of_cats/gfx/button.png")

    if page_nr > 1 and draw_book_button("Back", book_x, book_y + book_height - button_height) then
        page_nr = page_nr - 2
    end

    if page_nr + 1 < #cats and draw_book_button("Next", book_x + book_width - button_width, book_y + book_height - button_height - 10) then
        page_nr = page_nr + 2
    end
end

function M.OnWorldPreUpdate()
    GuiStartFrame(gui)
    GuiOptionsAdd(gui, gui_options.NoPositionTween)
    if GameGetIsGamepadConnected() then
        GuiOptionsAdd(gui, gui_options.NonInteractive)
    end

    if not GameHasFlagRun("NOITA_THINGSMOD_CAT_BOOK_HELD") then
        return
    end

    draw_book()
end

return M
