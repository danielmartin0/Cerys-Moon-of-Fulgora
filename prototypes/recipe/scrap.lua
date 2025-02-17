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
	["advanced-circuit"] = 11,
	["copper-cable"] = 7, -- initial power poles
	["uranium-238"] = 6,
	["stone-brick"] = 2, -- some of the stone brick for furnaces comes from the reactor excavation
	["pipe"] = 1.4, -- Initial pipes and extra iron for iron production chain. Pointedly small.
	["transport-belt"] = 0.9, -- Belt cubes and distance transport, initial iron. Pointedly small.
	["holmium-plate"] = 0.5, -- 2.5 would be matching fulgora
	["heat-pipe"] = 0.35,
	["steam-turbine"] = 0.2,
	["centrifuge"] = 0.2,
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
