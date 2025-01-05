local merge = require("lib").merge

data:extend({
	{
		type = "recipe",
		name = "mixed-oxide-fuel-cell",
		category = "crafting-or-fulgoran-cryogenics",
		always_show_made_in = true,
		energy_required = 10,
		enabled = false,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 3 },
			{ type = "item", name = "uranium-235", amount = 1 },
			{ type = "item", name = "uranium-238", amount = 10 },
			{ type = "item", name = "plutonium-239", amount = 9 },
		},
		results = { { type = "item", name = "mixed-oxide-fuel-cell", amount = 1 } },
		allow_productivity = true,
	},

	merge(data.raw.recipe["fission-reactor-equipment"], {
		name = "mixed-oxide-reactor-equipment",
		ingredients = {
			{ type = "item", name = "processing-unit", amount = 200 },
			{ type = "item", name = "low-density-structure", amount = 50 },
			{ type = "item", name = "plutonium-238", amount = 20 },
		},
		results = { { type = "item", name = "mixed-oxide-reactor-equipment", amount = 1 } },
	}),

	merge(data.raw.recipe["nuclear-fuel-reprocessing"], {
		name = "nuclear-waste-solution-centrifuging",
		always_show_made_in = true,
		enabled = false,
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
			{ type = "fluid", name = "nuclear-waste-solution", amount = 40 },
		},
		energy_required = 45,
		results = {
			{ type = "fluid", name = "steam", amount = 40 },
			{ type = "item", name = "uranium-238", amount = 3 },
			{ type = "item", name = "uranium-235", amount = 1, probability = 50 / 100 },
			{ type = "item", name = "plutonium-238", amount = 1, probability = 50 / 100 },
			{ type = "item", name = "plutonium-239", amount = 4 },
		},
		subgroup = "plutonium-processing",
		order = "c-c",
	}),

	merge(data.raw.recipe["sulfuric-acid"], {
		name = "mixed-oxide-cell-reprocessing",
		category = "chemistry-or-cryogenics-or-fulgoran-cryogenics",
		always_show_made_in = true,
		enabled = false,
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
		allow_productivity = true, -- Partial opt-out of plutonium gameplay
		-- crafting_machine_tint = {}
		subgroup = "plutonium-processing",
		order = "c-a",
	}),

	{
		type = "recipe",
		name = "plutonium-rounds-magazine",
		enabled = false,
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
		enabled = false,
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
