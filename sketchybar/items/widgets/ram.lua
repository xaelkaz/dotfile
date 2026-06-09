local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("graph", "widgets.ram", 42, {
    position = "right",
    graph = {
        color = colors.green
    },
    background = {
        height = 22,
        color = {
            alpha = 0
        },
        border_color = {
            alpha = 0
        },
        drawing = true
    },
    icon = {
        string = icons.ram
    },
    label = {
        string = "ram ??%",
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 9.0
        },
        align = "right",
        padding_right = 0,
        width = 0,
        y_offset = 4
    },
    update_freq = 5,
    padding_right = settings.paddings + 6
})

local function update_ram()
    sbar.exec(
        "vm_stat | awk '/Pages free/{f=$3+0} /Pages active/{a=$3+0} /Pages inactive/{i=$3+0} /Pages speculative/{s=$3+0} /Pages wired/{w=$4+0} /Pages occupied by compressor/{c=$5+0} END{u=a+w+c; t=u+f+i+s; if(t>0) printf \"%.0f\", (u/t)*100; else print 0}'",
        function(result)
            local load = tonumber(result) or 0

            local color = colors.green
            if load > 50 then
                if load < 70 then
                    color = colors.yellow
                elseif load < 85 then
                    color = colors.orange
                else
                    color = colors.red
                end
            end

            ram:push({load / 100.})
            ram:set({
                graph = {
                    color = color
                },
                label = "ram " .. load .. "%"
            })
        end)
end

ram:subscribe({"routine", "forced", "system_woke"}, update_ram)

ram:subscribe("mouse.clicked", function(env)
    sbar.exec("open -a 'Activity Monitor'")
end)

sbar.add("bracket", "widgets.ram.bracket", {ram.name}, {
    background = {
        color = colors.bg1,
        border_color = colors.rainbow[#colors.rainbow - 7],
        border_width = 1
    }
})

sbar.add("item", "widgets.ram.padding", {
    position = "right",
    width = settings.group_paddings
})
