local merge = require("lib").merge

data:extend({
	{
		type = "recipe",
		name = "plutonium-239",
		category = "no-machine",
		enabled = false,
		energy_required = 1,
		ingredients = {
			{ type = "item", name = "uranium-238", amount = 1 },
		},
		results = { { type = "item", name = "plutonium-239", amount = 1 } },
		always_show_made_in = true,
		hide_from_player_crafting = true,
		allow_decomposition = false,
		always_show_products = true,
	},
	{
		type = "recipe",
		name = "processing-units-from-nitric-acid",
		always_show_made_in = true,
		subgroup = "cerys-processes",
		order = "d-c",
		category = "cryogenics-or-fulgoran-cryogenics",
		enabled = false,
		energy_required = 5,
		ingredients = {
			{ type = "item",  name = "electronic-circuit", amount = 20 },
			{ type = "item",  name = "advanced-circuit",   amount = 2 },
			{ type = "fluid", name = "nitric-acid",        amount = 15 },
		},
		results = { { type = "item", name = "processing-unit", amount = 1 } },
		allow_productivity = true,
		icons = {
			{
				icon = "__base__/graphics/icons/processing-unit.png",
				icon_size = 64,
				scale = 0.8,
				shift = { 2, 2 },
				draw_background = true,
			},
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nitric-acid.png",
				icon_size = 64,
				scale = 0.52,
				shift = { -11, -11 },
				draw_background = true,
			},
		},
	},

	{
		type = "recipe",
		name = "charging-rod",
		enabled = false,
		category = "electronics",
		surface_conditions = {
			{
				property = "magnetic-field",
				min = 120,
				max = 120,
			},
			{
				property = "pressure",
				min = 5,
				max = 5,
			},
		},
		energy_required = 4,
		ingredients = {
			{ type = "item", name = "superconductor", amount = 6 }, -- Let's not have them make too many
			{ type = "item", name = "steel-plate",    amount = 12 },
			{ type = "item", name = "copper-cable",   amount = 6 },
		},
		results = { { type = "item", name = "charging-rod", amount = 1 } },
	},

	{
		type = "recipe",
		name = "nitric-acid",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nitric-acid.png",
		category = "chemistry",
		subgroup = "cerys-processes",
		order = "d-b",
		auto_recycle = false,
		energy_required = 1,
		ingredients = {
			{ type = "fluid", name = "ammonia", amount = 40 },
			{ type = "fluid", name = "water",   amount = 10 },
		},
		results = {
			{ type = "fluid", name = "nitric-acid", amount = 50 },
		},
		allow_productivity = false,
		enabled = false,
		always_show_made_in = true,
		always_show_products = true,
		allow_decomposition = false,
		crafting_machine_tint = data.raw.recipe["ammoniacal-solution-separation"].crafting_machine_tint,
	},

	merge(data.raw.recipe["lab"], {
		name = "cerys-lab",
		energy_required = 3,
		ingredients = {
			{ type = "item", name = "transport-belt",  amount = 8 },
			{ type = "item", name = "processing-unit", amount = 10 },
			{ type = "item", name = "iron-plate",      amount = 20 },
		},
		results = { { type = "item", name = "cerys-lab", amount = 1 } },
		enabled = false,
		surface_conditions = {
			{
				property = "magnetic-field",
				min = 120,
				max = 120,
			},
			{
				property = "pressure",
				min = 5,
				max = 5,
			},
		},
	}),

	merge(data.raw.recipe["electromagnetic-science-pack"], {
		name = "cerys-science-pack",
		always_show_made_in = true,
		category = "fulgoran-cryogenics",
		enabled = false,
		energy_required = 2,
		ingredients = {
			{ type = "item",  name = "superconductor", amount = 1 },
			{ type = "item",  name = "uranium-238",    amount = 6 },
			{ type = "fluid", name = "nitric-acid",    amount = 50 },
			{ type = "fluid", name = "methane",        amount = 50 },
		},
		results = { { type = "item", name = "cerys-science-pack", amount = 1 } },
		surface_conditions = {
			{
				property = "magnetic-field",
				min = 120,
				max = 120,
			},
			{
				property = "pressure",
				min = 5,
				max = 5,
			},
		},
	}),

	{
		type = "recipe",
		name = "methane-ice-dissociation",
		always_show_made_in = true,
		icons = {
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/methane-ice.png",
				icon_size = 64,
				scale = 0.5,
				shift = { 0, -8 },
				draw_background = true,
			},
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/methane.png",
				icon_size = 64,
				icon_mipmaps = 4,
				scale = 0.4,
				shift = { -15, 13 },
				draw_background = true,
			},
			{
				icon = "__base__/graphics/icons/fluid/light-oil.png",
				icon_size = 64,
				scale = 0.4,
				shift = { 15, 13 },
				draw_background = true,
			},
		},
		category = "fulgoran-cryogenics",
		subgroup = "cerys-processes",
		order = "b-a",
		auto_recycle = false,
		energy_required = 1 / 2,
		ingredients = {
			{ type = "item", name = "methane-ice", amount = 30 },
		},
		results = {
			{ type = "fluid", name = "light-oil", amount = 30 },
			{ type = "fluid", name = "methane",   amount = 30 },
		},
		allow_productivity = true,
		enabled = false,
		crafting_machine_tint = {                               -- TODO: Change. From fluoroketone
			primary = { r = 0.365, g = 0.815, b = 0.334, a = 1.000 }, -- #5dcf55ff
			secondary = { r = 0.772, g = 0.394, b = 0.394, a = 1.000 }, -- #c46464ff
			tertiary = { r = 0.116, g = 0.116, b = 0.111, a = 1.000 }, -- #1d1d1cff
			quaternary = { r = 0.395, g = 0.717, b = 0.563, a = 1.000 }, -- #64b68fff
		},
	},

	merge(data.raw.recipe["lubricant"], {
		name = "lubricant-synthesis",
		always_show_made_in = true,
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/lubricant-synthesis.png",
		icon_size = 64,
		subgroup = "cerys-processes",
		order = "e-a",
		enabled = false,
		energy_required = 3,
		ingredients = {
			{ type = "fluid", name = "light-oil", amount = 50 },
			{ type = "fluid", name = "methane",   amount = 10 },
			{ type = "item",  name = "carbon",    amount = 10 },
			{ type = "item",  name = "lithium",   amount = 5 },
		},
		results = {
			{ type = "fluid", name = "lubricant", amount = 50 },
		},
		auto_recycle = false,
	}),

	merge(data.raw.recipe["battery"], {
		name = "cerys-nitrogen-rich-mineral-processing",
		always_show_made_in = true,
		icons = {
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nitrogen-rich-minerals.png",
				icon_size = 64,
				scale = 0.4,
				shift = { 0, -9 },
				draw_background = true,
			},
			{
				icon = "__base__/graphics/icons/iron-ore.png",
				scale = 0.4,
				shift = { -12, 9 },
				draw_background = true,
			},
			{
				icon = "__space-age__/graphics/icons/fluid/ammonia.png",
				scale = 0.4,
				shift = { 12, 9 },
				draw_background = true,
			},
		},
		category = "fulgoran-cryogenics",
		energy_required = 1 / 2,
		enabled = false,
		ingredients = {
			{ type = "item",  name = "cerys-nitrogen-rich-minerals", amount = 1 },
			{ type = "fluid", name = "sulfuric-acid",                amount = 20 }, -- 1 iron is needed to make 50 sulfuric acid. Therefore, less than 50 sulfuric acid should make 1 iron.
			{ type = "fluid", name = "water",                        amount = 30 },
		},
		results = {
			{ type = "item",  name = "iron-ore", amount = 1 },
			{ type = "fluid", name = "ammonia",  amount = 50 },
		},
		allow_productivity = true,
		subgroup = "cerys-processes",
		order = "d-a",
		auto_recycle = false,
	}),
})
