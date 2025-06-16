local common = require("common")

local CIV_AGE_MY = 1800

local HALF_LIFE_235_MY = 703
local HALF_LIFE_238_MY = 4500

local U235_RATIO = (1 / common.REPROCESSING_U238_TO_U235_RATIO)
	* math.pow(0.5, CIV_AGE_MY / HALF_LIFE_235_MY)
	/ math.pow(0.5, CIV_AGE_MY / HALF_LIFE_238_MY)

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
		energy_required = 0.38,
		ingredients = {
			{ type = "item", name = "cerys-nuclear-scrap", amount = 1 },
		},
		results = {},
	},
})

local RECYCLING_PROBABILITIES_PERCENT = {
	["solid-fuel"] = 25,
	["advanced-circuit"] = 14,
	["uranium-238"] = 4,
	["pipe"] = 1.7, -- Initial pipes and extra initial iron. Pointedly small.
	["transport-belt"] = 1.1, -- Belt cubes and distance transport, initial iron. Pointedly small.
	["heat-pipe"] = 0.7, -- per each: 2.5 steel plate, 5 copper plate
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

log("[CERYS]: U235/U238 ratio is " .. U235_RATIO)
log("[CERYS]: U235 amount is " .. 4 * U235_RATIO)
