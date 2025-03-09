local common = require("common")

local CIV_AGE_MY = 2600

local HALF_LIFE_235_MY = 703
local HALF_LIFE_238_MY = 4500

local U235_RATIO = (1 / common.REPROCESSING_U238_TO_U235_RATIO)
	* math.pow(0.5, CIV_AGE_MY / HALF_LIFE_235_MY)
	/ math.pow(0.5, CIV_AGE_MY / HALF_LIFE_238_MY)

log("[CERYS]: U235/U238 ratio is " .. U235_RATIO)

data:extend({
	{
		type = "recipe",
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
		category = "recycling-or-hand-crafting",
		subgroup = "cerys-processes",
		order = "a-a",
		enabled = false,
		auto_recycle = false,
		energy_required = 0.4,
		ingredients = {
			{ type = "item", name = "cerys-nuclear-scrap", amount = 1 },
		},
		results = {},
	},
})

local RECYCLING_PROBABILITIES_PERCENT = {
	["solid-fuel"] = 23,
	["advanced-circuit"] = 12,
	["copper-cable"] = 7, -- initial power poles
	["uranium-238"] = 4,
	["pipe"] = 1.8, -- Initial pipes and extra initial iron. Pointedly small.
	["heat-pipe"] = 1, -- per each: 2.5 steel plate, 5 copper plate
	["transport-belt"] = 0.9, -- Belt cubes and distance transport, initial iron. Pointedly small.
	["holmium-plate"] = 0.5, -- 2.5 would be matching fulgora
	["steam-turbine"] = 0.18, -- per each: 12.5 iron gear, 12.5 copper plate, 5 pipe
	["centrifuge"] = 0.18, -- per each: 25 iron gear, 12.5 steel plate, 25 concrete, 25 red circuit
	["uranium-235"] = 4 * U235_RATIO,
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
