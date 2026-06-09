local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local hn_orange = 0xffff6600
local popup_width = 600
local max_stories = 5

local stories = {}
local current_index = 1

local hn = sbar.add("item", "widgets.hackernews", {
    position = "right",
    scroll_texts = false,
    icon = {
        string = icons.hackernews,
        color = hn_orange,
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 14.0
        },
        padding_right = 6
    },
    label = {
        string = "loading...",
        max_chars = 35,
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Regular"],
            size = 12.0
        }
    },
    update_freq = 600,
    popup = {
        align = "center"
    }
})

local popup_items = {}
for i = 1, max_stories do
    popup_items[i] = sbar.add("item", "widgets.hackernews.popup." .. i, {
        position = "popup." .. hn.name,
        scroll_texts = false,
        icon = {
            string = i .. ".",
            width = 25,
            align = "left",
            color = hn_orange,
            font = {
                family = settings.font.numbers,
                style = settings.font.style_map["Bold"]
            }
        },
        label = {
            string = "...",
            width = "dynamic",
            align = "left"
        }
    })
end

local function render_bar()
    if #stories == 0 then
        return
    end
    local s = stories[current_index]
    if s and s.title then
        hn:set({
            label = {
                string = s.title
            }
        })
    end
end

local function render_popup()
    for i = 1, max_stories do
        local s = stories[i]
        if s then
            popup_items[i]:set({
                label = {
                    string = string.format("[%d up | %d cmt] %s", s.score or 0, s.descendants or 0, s.title or "")
                }
            })
        end
    end
end

local function fetch_stories()
    sbar.exec("curl -s 'https://hacker-news.firebaseio.com/v0/topstories.json'", function(ids_table)
        if type(ids_table) ~= "table" or #ids_table == 0 then
            return
        end

        stories = {}
        local pending = math.min(max_stories, #ids_table)
        for i = 1, pending do
            local id = ids_table[i]
            local idx = i
            sbar.exec(string.format("curl -s 'https://hacker-news.firebaseio.com/v0/item/%s.json'", tostring(id)),
                function(item)
                    if type(item) == "table" then
                        stories[idx] = {
                            id = tostring(id),
                            title = item.title,
                            url = item.url,
                            score = item.score,
                            descendants = item.descendants
                        }
                    end
                    pending = pending - 1
                    if pending == 0 then
                        current_index = 1
                        render_bar()
                        render_popup()
                    end
                end)
        end
    end)
end

hn:subscribe({"forced", "routine"}, fetch_stories)

hn:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "right" then
        local drawing = hn:query().popup.drawing
        hn:set({
            popup = {
                drawing = "toggle"
            }
        })
        if drawing == "off" then
            render_popup()
        end
    elseif env.BUTTON == "other" then
        local s = stories[current_index]
        if s and s.id then
            sbar.exec(string.format("open 'https://news.ycombinator.com/item?id=%s'", s.id))
        end
    else
        if #stories > 0 then
            current_index = (current_index % #stories) + 1
            render_bar()
        end
    end
end)

hn:subscribe("mouse.exited.global", function()
    hn:set({
        popup = {
            drawing = false
        }
    })
end)

for i = 1, max_stories do
    popup_items[i]:subscribe("mouse.clicked", function(env)
        local s = stories[i]
        if s then
            local target = s.url
            if not target or target == "" then
                target = string.format("https://news.ycombinator.com/item?id=%s", s.id)
            end
            sbar.exec(string.format("open '%s'", target))
        end
        hn:set({
            popup = {
                drawing = false
            }
        })
    end)
end

sbar.add("bracket", "widgets.hackernews.bracket", {hn.name}, {
    background = {
        color = colors.bg1,
        border_color = hn_orange,
        border_width = 1
    }
})

sbar.add("item", "widgets.hackernews.padding", {
    position = "right",
    width = settings.group_paddings
})

fetch_stories()
