local common_data = require("common-data-only")
local common = require("common")

data:extend({
	{
		type = "recipe",
		name = "cerys-mixed-oxide-reactor",
		category = "crafting",
		energy_required = 10,
		enabled = false,
		ingredients = {
			{ type = "item", name = "refined-concrete", amount = 500 },
			{ type = "item", name = "copper-plate", amount = 500 },
			{ type = "item", name = "processing-unit", amount = 500 },
			{ type = "item", name = "lithium-plate", amount = 500 },
		},
		results = { { type = "item", name = "cerys-mixed-oxide-reactor", amount = 1 } },
		requester_paste_multiplier = 1,
	},

	{
		type = "recipe",
		name = "mixed-oxide-fuel-cell",
		category = "crafting",
		always_show_made_in = true,
		energy_required = 10,
		enabled = false,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 5 },
			{ type = "item", name = "uranium-235", amount = 1 },
			{ type = "item", name = "uranium-238", amount = 10 },
			{ type = "item", name = "plutonium-239", amount = 9 },
		},
		results = { { type = "item", name = "mixed-oxide-fuel-cell", amount = 1 } },
		allow_productivity = true,
	},

	{
		type = "recipe",
		name = "mixed-oxide-reactor-equipment",
		enabled = false,
		energy_required = 10,
		ingredients = {
			{ type = "item", name = "processing-unit", amount = 200 },
			{ type = "item", name = "low-density-structure", amount = 50 },
			{ type = "item", name = "plutonium-238", amount = 20 },
		},
		results = { { type = "item", name = "mixed-oxide-reactor-equipment", amount = 1 } },
	},

	{
		type = "recipe",
		name = "mixed-oxide-waste-centrifuging",
		always_show_made_in = true,
		enabled = false,
		auto_recycle = false,
		category = "centrifuging",
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
			{ type = "fluid", name = "mixed-oxide-waste-solution", amount = 50 },
		},
		energy_required = 45,
		results = {
			{ type = "fluid", name = "steam", amount = 50, temperature = 150 },
			{ type = "item", name = "uranium-235", amount = 1, probability = 50 / 100 },
			{ type = "item", name = "uranium-238", amount = (50 / 100 * common.REPROCESSING_U238_TO_U235_RATIO) },
			{ type = "item", name = "plutonium-238", amount = 1 },
			{ type = "item", name = "plutonium-239", amount = 5 },
		},
		subgroup = "plutonium-processing",
		order = "c-c",
		crafting_machine_tint = {
			primary = { r = 0.384, g = 0.271, b = 1 },
			secondary = { r = 0.384, g = 0.271, b = 1 },
		},
		allow_decomposition = false,
		allow_productivity = true,
	},

	{
		type = "recipe",
		name = "mixed-oxide-cell-reprocessing",
		category = "chemistry",
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
			{ type = "fluid", name = common_data.NITRIC_ACID_NAME, amount = 20 },
		},
		results = {
			{ type = "fluid", name = "mixed-oxide-waste-solution", amount = 20 },
		},
		allow_decomposition = false,
		allow_productivity = true,
		subgroup = "plutonium-processing",
		order = "c-a",
		crafting_machine_tint = {
			primary = { r = 0.384, g = 0.271, b = 0.792 }, -- nitric acid
			secondary = { r = 0.384, g = 0.271, b = 0.792 }, -- nitric acid
			tertiary = { r = 0.384, g = 0.271, b = 0.792 }, -- nitric acid
			quaternary = { r = 0.384, g = 0.271, b = 0.792 }, -- nitric acid
		},
	},

	{
		type = "recipe",
		name = "plutonium-rounds-magazine",
		enabled = false,
		energy_required = 10 * 10,
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
		energy_required = 5,
		enabled = false,
		category = "fulgoran-cryogenics",
		subgroup = "plutonium-processing",
		order = "c-a",
		ingredients = {
			{ type = "item", name = "plutonium-238", amount = 1 },
			{ type = "item", name = "nuclear-fuel", amount = 1 },
		},
		results = { { type = "item", name = "plutonium-fuel", amount = 1 } },
		allow_productivity = true,
	},

	-- {
	-- 	type = "recipe",
	-- 	name = "plutonium-cannon-shell",
	-- 	enabled = false,
	-- 	energy_required = 12,
	-- 	ingredients = {
	-- 		{ type = "item", name = "uranium-cannon-shell", amount = 1 },
	-- 		{ type = "item", name = "plutonium-238", amount = 1 },
	-- 	},
	-- 	results = { { type = "item", name = "plutonium-cannon-shell", amount = 1 } },
	-- },

	-- {
	-- 	type = "recipe",
	-- 	name = "explosive-plutonium-cannon-shell",
	-- 	enabled = false,
	-- 	energy_required = 12,
	-- 	ingredients = {
	-- 		{ type = "item", name = "explosive-uranium-cannon-shell", amount = 1 },
	-- 		{ type = "item", name = "plutonium-238", amount = 1 },
	-- 	},
	-- 	results = { { type = "item", name = "explosive-plutonium-cannon-shell", amount = 1 } },
	-- },
})
