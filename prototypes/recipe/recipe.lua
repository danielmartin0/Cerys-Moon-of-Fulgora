local common = require("common")
local common_data = require("common-data-only")

data:extend({
	{
		type = "recipe",
		name = "cerys-radiative-heater",
		category = "fulgoran-cryogenics",
		additional_categories = { "crafting" },
		energy_required = 6,
		ingredients = {
			{ type = "item", name = "refined-concrete", amount = 12 },
			{ type = "item", name = "steel-plate", amount = 12 },
			{ type = "item", name = "processing-unit", amount = 8 },
			{ type = "item", name = "plutonium-238", amount = 4 },
		},
		results = { { type = "item", name = "cerys-radiative-heater", amount = 1 } },
		enabled = false,
		surface_conditions = {
			common.AMBIENT_RADIATION_MIN,
		},
	},
})

if data.raw.recipe["maraxsis-holmium-recrystalization"] then -- Relies on a hidden optional dependency on Maraxsis
	if not data.raw.recipe["maraxsis-holmium-recrystalization"].additional_categories then
		data.raw.recipe["maraxsis-holmium-recrystalization"].additional_categories = {}
	end

	data.raw.recipe["maraxsis-holmium-recrystalization"].additional_categories = { "fulgoran-cryogenics" }

	data.raw.recipe["maraxsis-holmium-recrystalization"].icons = {
		{
			icon = "__space-age__/graphics/icons/holmium-plate.png",
			icon_size = 64,
			scale = 0.65,
			draw_background = true,
		},
		{
			icon = "__space-age__/graphics/icons/fluid/holmium-solution.png",
			icon_size = 64,
			scale = 0.45,
			shift = { -13, -13 },
			draw_background = true,
		},
	}

	data.raw.recipe["maraxsis-holmium-recrystalization"].hide_from_signal_gui = false
else
	data:extend({
		{
			type = "recipe",
			name = "maraxsis-holmium-recrystalization", -- We use Maraxsis' prefix so that saves work smoothly whether uninstalling/reinstalling Cerys and Maraxsis. Note that Maraxsis spells it with a single l.
			subgroup = "cerys-processes",
			order = "e-b",
			ingredients = {
				{ type = "fluid", name = "holmium-solution", amount = 50 },
				{ type = "item", name = "holmium-ore", amount = 1 },
			},
			results = {
				{ type = "item", name = "holmium-plate", amount = 5 },
			},
			energy_required = data.raw.recipe["holmium-plate"].energy_required * 10,
			category = "fulgoran-cryogenics",
			enabled = false,
			auto_recycle = false,
			icons = {
				{
					icon = "__space-age__/graphics/icons/holmium-plate.png",
					icon_size = 64,
					scale = 0.65,
					draw_background = true,
				},
				{
					icon = "__space-age__/graphics/icons/fluid/holmium-solution.png",
					icon_size = 64,
					scale = 0.45,
					shift = { -13, -13 },
					draw_background = true,
				},
			},
			hide_from_signal_gui = false,
		},
	})
end

data:extend({
	{
		type = "recipe",
		name = "cerys-radiation-proof-inserter",
		enabled = false,
		energy_required = 1,
		ingredients = {
			{ type = "item", name = "uranium-238", amount = 1 },
			{ type = "item", name = "inserter", amount = 1 },
		},
		results = { { type = "item", name = "cerys-radiation-proof-inserter", amount = 1 } },
	},
	{
		type = "recipe",
		name = "cerys-space-science-pack-from-methane-ice",
		localised_name = {
			"",
			{ common_data.K2_INSTALLED and "item-name.kr-space-research-data" or "item-name.space-science-pack" },
			{ "cerys.from-methane-ice" },
		},
		icons = {
			{
				icon = common_data.K2_INSTALLED and "__Krastorio2Assets__/icons/cards/space-research-data.png"
					or "__base__/graphics/icons/space-science-pack.png",
				icon_size = 64,
				scale = 0.65,
				shift = { 2, 2 },
				draw_background = true,
			},
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/methane-ice.png",
				icon_size = 64,
				scale = 0.32,
				shift = { -12, -12 },
				draw_background = true,
			},
		},
		enabled = false,
		ingredients = {
			{ type = "item", name = "methane-ice", amount = 1 },
			{ type = "item", name = "carbon", amount = 1 },
			{ type = "item", name = "iron-plate", amount = 2 },
		},
		energy_required = 7.5,
		results = {
			{
				type = "item",
				name = common_data.K2_INSTALLED and "kr-space-research-data" or "space-science-pack",
				amount = 1,
			},
		},
		allow_productivity = true,
		main_product = common_data.K2_INSTALLED and "kr-space-research-data" or "space-science-pack",
		category = "fulgoran-cryogenics",
		subgroup = "science-pack",
		order = "g[space-science-pack]-b[from-methane-ice]",
		always_show_made_in = true,
	},
	{
		type = "recipe",
		name = "cerys-overclock-module",
		enabled = false,
		ingredients = {
			{ type = "item", name = "speed-module-2", amount = 8 },
			{ type = "item", name = "processing-unit", amount = 4 },
			{ type = "item", name = "advanced-circuit", amount = 4 },
			{ type = "fluid", name = common_data.NITRIC_ACID_NAME, amount = 25 },
		},
		energy_required = 120,
		results = { { type = "item", name = "cerys-overclock-module", amount = 1 } },
		category = "fulgoran-cryogenics",
	},
	{
		type = "recipe",
		name = "cerys-radioactive-module-charged",
		enabled = false,
		ingredients = {
			{ type = "item", name = "productivity-module-2", amount = 8 },
			{ type = "item", name = "uranium-235", amount = 4 },
			{ type = "item", name = "superconductor", amount = 4 },
			{ type = "fluid", name = common_data.NITRIC_ACID_NAME, amount = 25 },
		},
		energy_required = 120,
		results = { { type = "item", name = "cerys-radioactive-module-charged", amount = 1 } },
		category = "fulgoran-cryogenics",
	},
	{
		type = "recipe",
		name = "cerysian-science-pack",
		always_show_made_in = true,
		category = "fulgoran-cryogenics",
		enabled = false,
		energy_required = 15,
		ingredients = {
			{ type = "item", name = "holmium-plate", amount = 1 },
			{ type = "item", name = "uranium-238", amount = 5 },
			{ type = "fluid", name = common_data.NITRIC_ACID_NAME, amount = 50 },
			{ type = "item", name = "ancient-structure-repair-part", amount = 1 },
		},
		results = { { type = "item", name = "cerysian-science-pack", amount = 1 } },
		surface_conditions = {
			common.AMBIENT_RADIATION_MIN,
		},
		allow_productivity = true,
	},
	{
		type = "recipe",
		name = "cerys-hydrogen-bomb",
		enabled = false,
		energy_required = 50,
		ingredients = {
			{ type = "item", name = "explosives", amount = 10 },
			{ type = "item", name = "processing-unit", amount = 10 },
			{ type = "item", name = "plutonium-238", amount = 5 },
			{ type = "item", name = "uranium-235", amount = 75 },
			{ type = "item", name = "plutonium-239", amount = 20 },
		},
		results = { { type = "item", name = "cerys-hydrogen-bomb", amount = 1 } },
	},
	{
		type = "recipe",
		name = "cerys-neutron-bomb",
		enabled = false,
		energy_required = 15,
		ingredients = {
			{ type = "item", name = "artillery-shell", amount = 1 },
			{ type = "item", name = common_data.LITHIUM_NAME, amount = 1 },
			{ type = "item", name = "plutonium-239", amount = 5 },
		},
		results = { { type = "item", name = "cerys-neutron-bomb", amount = 1 } },
	},

	{
		type = "recipe",
		name = "plutonium-239",
		category = "cerys-no-machine",
		enabled = false,
		energy_required = 0.1,
		ingredients = {
			{ type = "item", name = "uranium-238", amount = 1 },
		},
		results = { { type = "item", name = "plutonium-239", amount = 1 } },
		always_show_made_in = true,
		hide_from_player_crafting = true,
		allow_decomposition = false,
		always_show_products = true,
		auto_recycle = false,
	},

	{
		type = "recipe",
		name = "cerys-explosives-from-ammonium-nitrate",
		auto_recycle = false,
		always_show_made_in = true,
		subgroup = "cerys-processes",
		order = "d-d",
		category = "fulgoran-cryogenics",
		additional_categories = { "cryogenics", "chemistry" },
		enabled = false,
		energy_required = 5,
		ingredients = {
			{ type = "item", name = "solid-fuel", amount = 1 },
			{ type = "fluid", name = "ammonia", amount = 10 },
			{ type = "fluid", name = common_data.NITRIC_ACID_NAME, amount = 10 },
		},
		results = { { type = "item", name = "explosives", amount = 2 } },
		allow_productivity = true,
		icons = {
			{
				icon = "__base__/graphics/icons/explosives.png",
				icon_size = 64,
				scale = 0.65,
				shift = { 2, 2 },
				draw_background = true,
			},
			{
				icon = "__space-age__/graphics/icons/fluid/ammonia.png",
				icon_size = 64,
				scale = 0.45,
				shift = { -11, -11 },
				draw_background = true,
			},
		},
		crafting_machine_tint = {
			primary = { r = 0.384, g = 0.271, b = 0.792 }, -- nitric acid
			secondary = { r = 38, g = 110, b = 240, a = 1 }, -- ammonia
		},
		hide_from_signal_gui = false,
	},

	{
		type = "recipe",
		name = "cerys-processing-units-from-nitric-acid",
		auto_recycle = false,
		always_show_made_in = true,
		subgroup = "cerys-processes",
		order = "d-c",
		category = "fulgoran-cryogenics",
		additional_categories = { "cryogenics", "electromagnetics" },
		enabled = false,
		energy_required = 5,
		ingredients = {
			{ type = "item", name = "electronic-circuit", amount = 16 },
			{ type = "item", name = "advanced-circuit", amount = 2 },
			{ type = "fluid", name = common_data.NITRIC_ACID_NAME, amount = 5 },
		},
		results = { { type = "item", name = "processing-unit", amount = 1 } },
		allow_productivity = true,
		icons = {
			{
				icon = "__base__/graphics/icons/processing-unit.png",
				icon_size = 64,
				scale = 0.65,
				shift = { 2, 2 },
				draw_background = true,
			},
			{
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nitric-acid.png",
				icon_size = 64,
				scale = 0.45,
				shift = { -11, -11 },
				draw_background = true,
			},
		},
		crafting_machine_tint = {
			primary = { r = 0.384, g = 0.271, b = 0.792 }, -- nitric acid
			secondary = { r = 0.384, g = 0.271, b = 0.792 }, -- nitric acid
		},
		hide_from_signal_gui = false,
	},

	{
		type = "recipe",
		name = "cerys-charging-rod",
		enabled = false,
		category = "fulgoran-cryogenics",
		additional_categories = { "crafting" },
		surface_conditions = {
			common.AMBIENT_RADIATION_MIN,
		},
		energy_required = 5,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 6 },
			{ type = "item", name = "holmium-plate", amount = 12 },
			{ type = "item", name = "copper-cable", amount = 10 },
		},
		results = { { type = "item", name = "cerys-charging-rod", amount = 1 } },
	},

	{
		type = "recipe",
		name = "cerys-nitric-acid",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nitric-acid.png",
		category = "chemistry",
		subgroup = "cerys-processes",
		order = "d-b",
		auto_recycle = false,
		energy_required = 1,
		ingredients = {
			{ type = "fluid", name = "ammonia", amount = 25 },
			{ type = "fluid", name = "water", amount = 25 },
		},
		results = {
			{ type = "fluid", name = common_data.NITRIC_ACID_NAME, amount = 50 },
		},
		allow_productivity = true,
		enabled = false,
		always_show_made_in = true,
		always_show_products = true,
		allow_decomposition = false,
		crafting_machine_tint = {
			primary = { r = 38, g = 110, b = 180, a = 1 }, -- water
			secondary = { r = 38, g = 110, b = 240, a = 1 }, -- ammonia
		},
	},

	{
		type = "recipe",
		name = "cerys-lab",
		energy_required = 5,
		ingredients = {
			{ type = "item", name = "transport-belt", amount = 5 },
			{ type = "item", name = "advanced-circuit", amount = 15 },
			{ type = "item", name = "copper-plate", amount = 40 },
		},
		results = { { type = "item", name = "cerys-lab", amount = 1 } },
		enabled = false,
		surface_conditions = {
			common.AMBIENT_RADIATION_MIN,
		},
	},

	{
		type = "recipe",
		name = "methane-ice-dissociation",
		always_show_made_in = true,
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/methane-ice-dissociation.png",
		icon_size = 64,
		category = "fulgoran-cryogenics",
		subgroup = "cerys-processes",
		order = "c",
		auto_recycle = false,
		energy_required = 16,
		ingredients = {
			{ type = "item", name = "methane-ice", amount = 100 },
		},
		results = {
			{ type = "fluid", name = "light-oil", amount = 100 },
			{ type = "fluid", name = "methane", amount = 200 },
		},
		allow_productivity = true,
		enabled = false,
		crafting_machine_tint = {
			primary = { r = 194, g = 194, b = 194, a = 1 }, -- methane?
			secondary = { r = 117, g = 85, b = 13, a = 1 }, -- light oil
		},
		hide_from_signal_gui = false,
	},

	{
		type = "recipe",
		name = "cerys-nitrogen-rich-mineral-processing",
		always_show_made_in = true,
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cerys-nitrogen-rich-mineral-processing.png",
		icon_size = 64,
		category = "fulgoran-cryogenics",
		energy_required = 2.5,
		enabled = false,
		ingredients = {
			{ type = "item", name = "cerys-nitrogen-rich-minerals", amount = 1 },
			{ type = "fluid", name = "sulfuric-acid", amount = common.HARD_MODE_ON and 120 or 60 }, -- 1 iron => 50 sulfuric acid.
		},
		results = { -- Since these are the biggest way to get these two items, their amounts should ideally balance to their expected usage:
			{ type = "item", name = "iron-ore", amount = 2 },
			{ type = "fluid", name = "ammonia", amount = 40 },
		},
		allow_productivity = true,
		subgroup = "cerys-processes",
		order = "d-a",
		auto_recycle = false,
		crafting_machine_tint = {
			primary = { r = 234, g = 221, b = 9, a = 1 }, -- sulfuric acid
			secondary = { r = 234, g = 221, b = 9, a = 1 }, -- sulfuric acid
		},
		hide_from_signal_gui = false,
	},

	{
		type = "recipe",
		name = "cerys-lubricant-synthesis",
		category = "fulgoran-cryogenics",
		always_show_made_in = true,
		subgroup = "cerys-processes",
		order = "e-a",
		enabled = false,
		energy_required = 10,
		ingredients = {
			{ type = "fluid", name = "light-oil", amount = 50 },
			{ type = "item", name = common_data.LITHIUM_NAME, amount = 5 },
		},
		results = {
			{ type = "fluid", name = "lubricant", amount = 50 },
		},
		allow_productivity = true,
		auto_recycle = false,
		crafting_machine_tint = {
			primary = { r = 0.268, g = 0.723, b = 0.223, a = 1.000 }, -- lubricant
			secondary = { r = 117, g = 85, b = 13, a = 1 }, -- light oil
		},
		icons = {
			{
				icon = "__space-age__/graphics/icons/lithium.png",
				icon_size = 64,
				scale = 0.45,
				shift = { -13, -7 },
				draw_background = true,
			},
			{
				icon = "__base__/graphics/icons/fluid/light-oil.png",
				icon_size = 64,
				scale = 0.45,
				shift = { 13, -7 },
				draw_background = true,
			},
			{
				icon = "__base__/graphics/icons/fluid/lubricant.png",
				icon_size = 64,
				scale = 0.7,
				shift = { 0, 12 },
				draw_background = true,
			},
		},
		hide_from_signal_gui = false,
	},
})

if common_data.K2_INSTALLED then
	data:extend({
		{
			type = "recipe",
			name = "kr-cerysian-research-data",
			always_show_made_in = true,
			category = "fulgoran-cryogenics",
			enabled = false,
			energy_required = 20,
			ingredients = data.raw.recipe["cerysian-science-pack"].ingredients,
			results = { { type = "item", name = "kr-cerysian-research-data", amount = 1 } },
			surface_conditions = {
				common.AMBIENT_RADIATION_MIN,
			},
			allow_productivity = true,
		},
	})

	-- Overwrite the science pack recipe:
	data.raw.recipe["cerysian-science-pack"] = nil
	data:extend({
		{
			type = "recipe",
			name = "cerysian-science-pack",
			localised_name = {
				"cerys.kr-cerysian-tech-card",
			},
			always_show_made_in = true,
			enabled = false,
			energy_required = 20,
			ingredients = {
				{ type = "item", name = "kr-cerysian-research-data", amount = 5 },
				{ type = "item", name = "kr-blank-tech-card", amount = 5 },
			},
			results = {
				{ type = "item", name = "cerysian-science-pack", amount = 5 },
			},
			surface_conditions = {
				common.AMBIENT_RADIATION_MIN,
			},
			allow_productivity = true,
		},
	})
end
