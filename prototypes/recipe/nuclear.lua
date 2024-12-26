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
	}),
})

local RECYCLING_PROBABILITIES_PERCENT = {
	["solid-fuel"] = 25,
	["advanced-circuit"] = 11,
	["copper-cable"] = 8, -- initial power poles
	["uranium-238"] = 6,
	["stone-brick"] = 2, -- some of the stone brick for furnaces comes from the reactor excavation
	["pipe"] = 1.8, -- Avoid getting softlocked if you clear all the ruins, provide initial iron for iron production chain. Pointedly small.
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

data:extend({
	merge(data.raw.recipe["fission-reactor-equipment"], {
		name = "mixed-oxide-reactor-equipment",
		ingredients = {
			{ type = "item", name = "processing-unit", amount = 200 },
			{ type = "item", name = "low-density-structure", amount = 50 },
			{ type = "item", name = "plutonium-238", amount = 100 },
		},
		results = { { type = "item", name = "mixed-oxide-reactor-equipment", amount = 1 } },
	}),

	merge(data.raw.recipe["nuclear-fuel-reprocessing"], {
		name = "nuclear-waste-solution-centrifuging",
		always_show_made_in = true,
		icons = {
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/nuclear-waste-solution-nitric.png",
				icon_size = 64,
				scale = 0.65,
				shift = { 0, -7 },
				draw_background = true,
			},
			{
				icon = "__base__/graphics/icons/uranium-238.png",
				icon_size = 64,
				scale = 0.45,
				shift = { -18, 26 },
				draw_background = true,
			},
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/plutonium-238.png",
				icon_size = 64,
				scale = 0.45,
				shift = { 18, 26 },
				draw_background = true,
			},
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/plutonium-239.png",
				icon_size = 64,
				scale = 0.5,
				shift = { 0, 26 },
				draw_background = true,
			},
		},
		main_product = "",
		ingredients = {
			{ type = "fluid", name = "nuclear-waste-solution", amount = 200 },
		},
		results = {
			{ type = "fluid", name = "steam", amount = 200 },
			{ type = "item", name = "uranium-238", amount = 2, extra_count_fraction = 60 / 100 },
			{ type = "item", name = "plutonium-238", amount = 1, probability = 10 / 100 },
			{ type = "item", name = "plutonium-239", amount = 1, probability = 30 / 100 }, -- 50% is parity with no productivity boost
		},
		subgroup = "plutonium-processing",
		order = "c-c",
	}),

	merge(data.raw.recipe["sulfuric-acid"], {
		name = "mixed-oxide-cell-reprocessing",
		category = "chemistry-or-cryogenics-or-fulgoran-cryogenics",
		always_show_made_in = true,
		icons = {
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/depleted-mixed-oxide-fuel-cell.png",
				icon_size = 64,
				scale = 0.45,
				shift = { -13, -7 },
				draw_background = true,
			},
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nitric-acid.png",
				icon_size = 64,
				scale = 0.45,
				shift = { 13, -7 },
				draw_background = true,
			},
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/nuclear-waste-solution-nitric.png",
				icon_size = 64,
				scale = 0.5,
				shift = { 0, 12 },
				draw_background = true,
			},
		},
		energy_required = 10,
		main_product = "",
		ingredients = {
			{ type = "item", name = "depleted-mixed-oxide-fuel-cell", amount = 1 },
			{ type = "fluid", name = "nitric-acid", amount = 40 },
		},
		results = {
			{ type = "fluid", name = "nuclear-waste-solution", amount = 40 },
		},
		allow_decomposition = false,
		allow_productivity = true, -- TODO: Check
		-- crafting_machine_tint = {}
		subgroup = "plutonium-processing",
		order = "c-a",
	}),

	{
		type = "recipe",
		name = "mixed-oxide-fuel-cell",
		category = "crafting-or-fulgoran-cryogenics",
		always_show_made_in = true,
		energy_required = 10,
		ingredients = {
			{ type = "item", name = "iron-plate", amount = 10 },
			{ type = "item", name = "uranium-235", amount = 1 },
			{ type = "item", name = "uranium-238", amount = 9 },
			{ type = "item", name = "plutonium-239", amount = 10 },
		},
		results = { { type = "item", name = "mixed-oxide-fuel-cell", amount = 10 } },
		allow_productivity = true,
	},

	{
		type = "recipe",
		name = "plutonium-rounds-magazine",
		energy_required = 10,
		ingredients = {
			{ type = "item", name = "uranium-rounds-magazine", amount = 10 },
			{ type = "item", name = "plutonium-238", amount = 1 },
		},
		results = { { type = "item", name = "plutonium-rounds-magazine", amount = 10 } },
	},

	{
		type = "recipe",
		name = "plutonium-fuel",
		always_show_made_in = true,
		energy_required = 90,
		category = "centrifuging",
		subgroup = "plutonium-processing",
		order = "c-a",
		ingredients = {
			{ type = "item", name = "plutonium-238", amount = 1 },
			{ type = "item", name = "nuclear-fuel", amount = 1 },
		},
		results = { { type = "item", name = "plutonium-fuel", amount = 1 } },
		allow_productivity = true,
	},
})
