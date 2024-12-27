local merge = require("lib").merge

local CIV_AGE_MY = 600

local U235_NATURAL_AMOUNT = 1 - 0.992745
local U238_NATURAL_AMOUNT = 0.992745

local HALF_LIFE_235_MY = 703
local HALF_LIFE_238_MY = 4500

local U235_RATIO = (U235_NATURAL_AMOUNT / U238_NATURAL_AMOUNT)
    * math.pow(0.5, CIV_AGE_MY / HALF_LIFE_235_MY)
    / math.pow(0.5, CIV_AGE_MY / HALF_LIFE_238_MY)

log("Cerys U235/U238 ratio: " .. U235_RATIO)

data:extend({

    merge(data.raw.recipe["scrap-recycling"], {
        name = "cerys-nuclear-scrap-recycling",
        icons = {
            {
                icon = "__quality__/graphics/icons/recycling.png",
            },
            {
                icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/nuclear-scrap.png",
                scale = 0.4,
            },
            {
                icon = "__quality__/graphics/icons/recycling-top.png",
            },
        },
        subgroup = "cerys-processes",
        order = "a-a",
        ingredients = {
            { type = "item", name = "cerys-nuclear-scrap", amount = 1 },
        },
        results = {},
        enabled = false,
    }),
})

local RECYCLING_PROBABILITIES_PERCENT = {
    ["solid-fuel"] = 25,
    ["advanced-circuit"] = 11,
    ["copper-cable"] = 8,    -- initial power poles
    ["uranium-238"] = 6,
    ["stone-brick"] = 2,     -- some of the stone brick for furnaces comes from the reactor excavation
    ["pipe"] = 1.8,          -- Avoid getting softlocked if you clear all the ruins, provide initial iron for iron production chain. Pointedly small.
    ["holmium-plate"] = 0.5, -- 2.5 would be matching fulgora
    ["heat-pipe"] = 0.4,
    ["beacon"] = 0.25,
    ["steam-turbine"] = 0.25,
    ["centrifuge"] = 0.15,
    ["uranium-235"] = 6 * U235_RATIO,
}

for name, percent in pairs(RECYCLING_PROBABILITIES_PERCENT) do
    table.insert(data.raw.recipe["cerys-nuclear-scrap-recycling"].results, {
        type = "item",
        name = name,
        amount = 1,
        probability = percent / 100,
        show_details_in_recipe_tooltip = false,
    })
end
