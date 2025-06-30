local common = require("common")
local common_data = require("common-data-only")

if settings.startup["cerys-player-constructable-radiative-towers"].value then
	data:extend({
		{
			type = "recipe",
			name = "cerys-radiative-tower",
			category = "crafting",
			energy_required = 6,
			ingredients = {
				{ type = "item", name = "refined-concrete", amount = 20 },
				{ type = "item", name = "steel-plate", amount = 20 },
				{ type = "item", name = "processing-unit", amount = 10 },
			},
			results = { { type = "item", name = "cerys-radiative-tower", amount = 1 } },
			enabled = false,
			surface_conditions = {
				common.AMBIENT_RADIATION_MIN,
			},
		},
	})
end

if data.raw.recipe["maraxsis-holmium-recrystalization"] then -- Relies on a hidden optional dependency on Maraxsis
	if not data.raw.recipe["maraxsis-holmium-recrystalization"].additional_categories then
		data.raw.recipe["maraxsis-holmium-recrystalization"].additional_categories = {}
	end

	data.raw.recipe["maraxsis-holmium-recrystalization"].additional_categories = { "fulgoran-cryogenics" }
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
			energy_required = data.raw.recipe["holmium-plate"].energy_required * 5,
			category = "fulgoran-cryogenics",
			enabled = false,
			auto_recycle = false,
			icons = {
				{
					icon = "__space-age__/graphics/icons/holmium-plate.png",
					icon_size = 64,
				},
				{
					icon = "__space-age__/graphics/icons/fluid/holmium-solution.png",
					icon_size = 64,
					size = 0.5,
					shift = { -8, -8 },
				},
			},
		},
	})
end

data:extend({
	{
		type = "recipe",
		name = "cerys-speed-module-3-from-nitric-acid",
		enabled = false,
		ingredients = {
			{ type = "item", name = "speed-module-2", amount = 4 },
			{ type = "item", name = "advanced-circuit", amount = 4 },
			{ type = "item", name = "processing-unit", amount = 4 },
			{ type = "fluid", name = common_data.NITRIC_ACID_NAME, amount = 15 },
		},
		energy_required = 30,
		results = { { type = "item", name = "speed-module-3", amount = 1 } },
		category = "fulgoran-cryogenics",
		subgroup = "cerys-processes",
		order = "d-d",
		auto_recycle = false,
		icons = {
			{
				icon = "__base__/graphics/icons/speed-module-3.png",
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
	},
	{
		type = "recipe",
		name = "cerys-overclock-module",
		enabled = false,
		ingredients = {
			{ type = "item", name = "speed-module-3", amount = 8 },
			{ type = "item", name = "lithium-plate", amount = 7 },
			{ type = "item", name = "plutonium-238", amount = 7 },
			{ type = "fluid", name = common_data.NITRIC_ACID_NAME, amount = 50 },
		},
		energy_required = 60,
		results = { { type = "item", name = "cerys-overclock-module", amount = 1 } },
		category = "fulgoran-cryogenics",
	},
	{
		type = "recipe",
		name = "cerysian-science-pack",
		always_show_made_in = true,
		category = "fulgoran-cryogenics",
		enabled = false,
		energy_required = 6,
		ingredients = {
			{ type = "item", name = "superconductor", amount = 2 },
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
			{ type = "item", name = "atomic-bomb", amount = 1 },
			{ type = "item", name = "plutonium-239", amount = 100 },
			{ type = "item", name = common_data.LITHIUM_NAME, amount = 10 },
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
			{ type = "item", name = "processing-unit", amount = 10 },
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
		name = "cerys-processing-units-from-nitric-acid",
		auto_recycle = false,
		always_show_made_in = true,
		subgroup = "cerys-processes",
		order = "d-c",
		category = "fulgoran-cryogenics",
		additional_categories = { "cryogenics" },
		enabled = false,
		energy_required = 2,
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
			{ type = "item", name = "superconductor", amount = 8 },
			{ type = "item", name = "steel-plate", amount = 8 },
			{ type = "item", name = "holmium-plate", amount = 16 }, -- For holmium plate qualitycycling
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
			{ type = "item", name = "transport-belt", amount = 6 },
			{ type = "item", name = "advanced-circuit", amount = 30 },
			{ type = "item", name = "copper-plate", amount = 30 },
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
		order = "b-a",
		auto_recycle = false,
		energy_required = 6,
		ingredients = {
			{ type = "item", name = "methane-ice", amount = 50 },
		},
		results = {
			{ type = "fluid", name = "light-oil", amount = 50 },
			{ type = "fluid", name = "methane", amount = 100 },
		},
		allow_productivity = true,
		enabled = false,
		crafting_machine_tint = {
			primary = { r = 194, g = 194, b = 194, a = 1 }, -- methane?
			secondary = { r = 117, g = 85, b = 13, a = 1 }, -- light oil
		},
	},

	{
		type = "recipe",
		name = "cerys-nitrogen-rich-mineral-processing",
		always_show_made_in = true,
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cerys-nitrogen-rich-mineral-processing.png",
		icon_size = 64,
		category = "fulgoran-cryogenics",
		energy_required = 0.5,
		enabled = false,
		ingredients = {
			{ type = "item", name = "cerys-nitrogen-rich-minerals", amount = 1 },
			{ type = "fluid", name = "sulfuric-acid", amount = common.HARD_MODE_ON and 35 or 15 }, -- 1 iron => 50 sulfuric acid.
			{ type = "fluid", name = "water", amount = 35 },
		},
		results = { -- Since these are the biggest way to get these two items, their amounts should ideally balance to their expected usage:
			{ type = "item", name = "iron-ore", amount = 1 },
			{ type = "fluid", name = "ammonia", amount = 30 },
		},
		allow_productivity = true,
		subgroup = "cerys-processes",
		order = "d-a",
		auto_recycle = false,
		crafting_machine_tint = {
			primary = { r = 234, g = 221, b = 9, a = 1 }, -- sulfuric acid
			secondary = { r = 234, g = 221, b = 9, a = 1 }, -- sulfuric acid
		},
	},

	{
		type = "recipe",
		name = "cerys-lubricant-synthesis",
		category = "fulgoran-cryogenics",
		always_show_made_in = true,
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/lubricant-synthesis.png",
		icon_size = 64,
		subgroup = "cerys-processes",
		order = "e-a",
		enabled = false,
		energy_required = 5,
		ingredients = {
			{ type = "fluid", name = "light-oil", amount = 50 },
			{ type = "item", name = "carbon", amount = 10 },
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
			tertiary = { r = 0.647, g = 0.471, b = 0.396, a = 1.000 }, -- TODO: Change
			quaternary = { r = 1.000, g = 0.395, b = 0.127, a = 1.000 }, -- TODO: Change
		},
	},
})
