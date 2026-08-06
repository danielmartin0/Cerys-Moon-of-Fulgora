local common_data = require("common-data-only")
local common = require("common")

local CIV_AGE_MY = 2200

local HALF_LIFE_235_MY = 703
local HALF_LIFE_238_MY = 4500

local U235_RATIO = (1 / common.REPROCESSING_U238_TO_U235_RATIO)
	* 2 ^ (CIV_AGE_MY / HALF_LIFE_238_MY - CIV_AGE_MY / HALF_LIFE_235_MY)

data:extend({
	{
		type = "recipe",
		name = "cerys-nuclear-scrap-recycling",
		icons = {
			{
				icon = "__recycler__/graphics/icons/recycling.png",
			},
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/nuclear-scrap.png",
				scale = 0.4,
			},
			{
				icon = "__recycler__/graphics/icons/recycling-top.png",
			},
		},
		categories = { "recycling", "hand-crafting" },
		subgroup = "cerys-processes",
		order = "a-b[nuclear-scrap-recycling]",
		enabled = false,
		auto_recycle = false,
		energy_required = 0.38,
		ingredients = {
			{ type = "item", name = "cerys-nuclear-scrap", amount = 1 },
		},
		results = {},
	},
})

local U238_AMOUNT = 5

local RECYCLING_PROBABILITIES_PERCENT = {
	["solid-fuel"] = 25,
	["advanced-circuit"] = 10,
	["uranium-238"] = U238_AMOUNT,
	["pipe"] = 1.9, -- Initial pipes and extra initial iron.
	["transport-belt"] = 1.4, -- Belt cubes and distance transport, initial iron.
	["holmium-plate"] = 1, -- 2.5 would be matching fulgora
	["heat-pipe"] = 0.8, -- per each: 2.5 steel plate, 5 copper plate
	["steam-turbine"] = 0.17, -- per each: 12.5 iron gear, 12.5 copper plate, 5 pipe
	["centrifuge"] = 0.17, -- per each: 25 iron gear, 12.5 steel plate, 25 concrete, 25 red circuit
	["uranium-235"] = U238_AMOUNT * U235_RATIO,
}

if common_data.K2_INSTALLED then
	RECYCLING_PROBABILITIES_PERCENT["low-density-structure"] = 0.8
end

local SORTED_RECYCLING_PROBABILITIES_PERCENT = {}
do
	for k, v in pairs(RECYCLING_PROBABILITIES_PERCENT) do
		table.insert(SORTED_RECYCLING_PROBABILITIES_PERCENT, { k, v })
	end
	table.sort(SORTED_RECYCLING_PROBABILITIES_PERCENT, function(a, b)
		if a[2] ~= b[2] then
			return a[2] > b[2]
		end
		return a[1] < b[1]
	end)
end

local EDGE_EPSILON_PERCENT = 1e-9 -- values can otherwise show as 1.89% instead of 1.90%.

local cumulative_percent = 0.0
for _, pair in ipairs(SORTED_RECYCLING_PROBABILITIES_PERCENT) do
	local name, percent = pair[1], pair[2]
	local min_percent = cumulative_percent
	cumulative_percent = cumulative_percent + percent + EDGE_EPSILON_PERCENT

	table.insert(data.raw.recipe["cerys-nuclear-scrap-recycling"].results, {
		type = "item",
		name = name,
		amount = 1,
		shared_probability = { min = min_percent / 100, max = cumulative_percent / 100 },
		show_details_in_recipe_tooltip = false,
	})
end

log("[CERYS]: U235/U238 ratio is " .. U235_RATIO)
log("[CERYS]: U235 amount is " .. U238_AMOUNT * U235_RATIO)
