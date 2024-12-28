local lib = require("lib")
-- local merge = lib.merge
local cerys_tech = lib.cerys_tech

data:extend({
	cerys_tech({
		name = "cerys-nitrogen-rich-mineral-processing",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-nitrogen-rich-mineral-processing",
			},
		},
		prerequisites = { "moon-discovery-cerys" },
		research_trigger = {
			type = "mine-entity",
			entity = "cerys-nitrogen-rich-minerals",
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/nitrogen-rich-mineral-processing.png",
		icon_size = 256,
	}),
	cerys_tech({
		name = "cerys-nuclear-scrap-recycling",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-nuclear-scrap-recycling",
			},
			{
				type = "unlock-recipe",
				recipe = "recycler",
			},
			-- {
			-- 	type = "unlock-recipe",
			-- 	recipe = "ancient-nuclear-fuel-cell-recycling",
			-- },
			{
				type = "unlock-recipe",
				recipe = "ancient-structure-repair-part",
			},
		},
		prerequisites = { "moon-discovery-cerys" },
		research_trigger = {
			type = "mine-entity",
			entity = "cerys-nuclear-scrap",
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/nuclear-scrap.png",
		icon_size = 256,
	}),
	cerys_tech({
		name = "cerys-fulgoran-cryogenics",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "methane-ice-dissociation",
			},
			{
				type = "unlock-recipe",
				recipe = "superconductor",
			},
			{
				type = "unlock-recipe",
				recipe = "ammonia-rocket-fuel",
			},
			{
				type = "unlock-recipe",
				recipe = "nitric-acid",
			},
			{
				type = "unlock-recipe",
				recipe = "processing-units-from-nitric-acid",
			},
			{
				type = "unlock-recipe",
				recipe = "lithium",
			},
			{
				type = "unlock-recipe",
				recipe = "mixed-oxide-fuel-cell",
			},
		},
		prerequisites = { "cerys-nuclear-scrap-recycling" },
		unit = {
			count = 10,
			ingredients = {
				{ "cerys-science-pack", 1 },
			},
			time = 60,
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/cryogenic-plant.png",
		icon_size = 256,
	}),
	cerys_tech({
		name = "cerys-science-pack",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-science-pack",
			},
			{
				type = "unlock-recipe",
				recipe = "cerys-lab",
			},
		},
		prerequisites = { "cerys-fulgoran-cryogenics", "cerys-nitrogen-rich-mineral-processing" },
		research_trigger = {
			type = "craft-fluid",
			fluid = "methane",
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/cerys-science-pack.png",
		icon_size = 256,
	}),
	cerys_tech({
		unit = {
			count = 50,
			ingredients = {
				{ "cerys-science-pack", 1 },
			},
			time = 60,
		},
		name = "cerys-gas-venting",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "vent-stack",
			},
			{
				type = "unlock-recipe",
				recipe = "flare-stack",
			},
		},
		prerequisites = { "cerys-science-pack" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/gas-venting.png",
		icon_size = 256,
	}),
	cerys_tech({
		science_count = 100,
		name = "cerys-cryogenic-plant-quality-upgrades",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-upgrade-fulgoran-cryogenic-plant-quality",
			},
		},
		prerequisites = { "cerys-science-pack" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/cryogenic-plant-quality.png",
		icon_size = 256,
	}),
	cerys_tech({
		name = "cerys-charging-rod",
		unit = {
			count = 100,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "cerys-science-pack",      1 },
			},
			time = 60,
		},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "charging-rod",
			},
		},
		prerequisites = { "cerys-science-pack" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/charging-rod.png",
		icon_size = 352,
	}),
	cerys_tech({
		science_count = 150,
		name = "cerys-advanced-structure-repair",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-fulgoran-reactor-scaffold",
			},
			{
				type = "unlock-recipe",
				recipe = "plutonium-239",
			},
		},
		prerequisites = { "cerys-science-pack" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/advanced-structure-repair.png",
		icon_size = 767,
	}),
	cerys_tech({
		science_count = 300,
		name = "cerys-plutonium-enhanced-fuel-reprocessing",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "mixed-oxide-cell-reprocessing",
			},
			{
				type = "unlock-recipe",
				recipe = "nuclear-waste-solution-centrifuging",
			},
		},
		prerequisites = { "cerys-advanced-structure-repair", "cerys-gas-venting" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/nuclear-waste-processing.png",
		icon_size = 256,
	}),
	cerys_tech({
		science_count = 500,
		name = "cerys-lubricant-synthesis",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "lubricant-synthesis",
			},
		},
		prerequisites = { "cerys-advanced-structure-repair" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/lubricant-synthesis.png",
		icon_size = 256,
	}),
	cerys_tech({
		unit = {
			count = 2000,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack",   1 },
				{ "cerys-science-pack",      1 },
			},
			time = 60,
		},
		name = "cerys-advanced-plutonium-technology",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "mixed-oxide-reactor-equipment",
			},
			{
				type = "unlock-recipe",
				recipe = "plutonium-rounds-magazine",
			},
			{
				type = "unlock-recipe",
				recipe = "plutonium-fuel",
			},
		},
		prerequisites = {
			"cerys-plutonium-enhanced-fuel-reprocessing",
			"uranium-ammo",
			"fission-reactor-equipment",
			"kovarex-enrichment-process",
			"cerys-lubricant-synthesis",
		},
		icons = util.technology_icon_constant_equipment(
			"__Cerys-Moon-of-Fulgora__/graphics/technology/fission-reactor-equipment.png"
		),
	}),
	{
		type = "technology",
		name = "holmium-plate-productivity-1",
		icons = util.technology_icon_constant_recipe_productivity(
			"__space-age__/graphics/technology/holmium-processing.png"
		),
		icon_size = 256,
		effects = {
			{
				type = "change-recipe-productivity",
				recipe = "holmium-plate",
				change = 0.1,
			},
		},
		prerequisites = { "cerys-advanced-structure-repair" },
		unit = {
			count = 500,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack",   1 },
				{ "cerys-science-pack",      1 },
			},
			time = 60,
		},
		upgrade = true,
	},
	{
		type = "technology",
		name = "holmium-plate-productivity-2",
		icons = util.technology_icon_constant_recipe_productivity(
			"__space-age__/graphics/technology/holmium-processing.png"
		),
		icon_size = 256,
		effects = {
			{
				type = "change-recipe-productivity",
				recipe = "holmium-plate",
				change = 0.1,
			},
		},
		prerequisites = { "holmium-plate-productivity-1" },
		unit = {
			count_formula = "3^(L-1)*500",
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack",   1 },
				{ "cerys-science-pack",      1 },
				{ "utility-science-pack",    1 },
			},
			time = 60,
		},
		max_level = "infinite",
		upgrade = true,
	},
})

data:extend({
	lib.cerys_tech({
		name = "cerys-cargo-drops",
		effects = {
			{
				type = "nothing",
				effect_description = { "cerys.cargo-drops-tech-description" },
			},
		},
		prerequisites = { "cerys-lubricant-synthesis" }, -- Note that the dependence on advanced plutonium tech might force the player to leave the moon before performing drops.
		unit = {
			count = 2000,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack",   1 },
				{ "cerys-science-pack",      1 },
				{ "utility-science-pack",    1 },
			},
			time = 60,
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/cerys-cargo-drops.png",
		icon_size = 520,
	}),
})

local discovery_tech = {
	type = "technology",
	name = "moon-discovery-cerys",
	icons = {
		{
			icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/cerys.png",
			icon_size = 256,
		},
		{
			icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/constant-moon.png",
			icon_size = 128,
			scale = 0.5,
			shift = { 50, 50 },
		},
	},
	icon_size = 256,
	effects = {
		{
			type = "unlock-space-location",
			space_location = "cerys",
			use_icon_overlay_constant = false, -- This prevents the 'planet' symbol from appearing over the effect icon.
		},
	},
	prerequisites = {
		"planet-discovery-fulgora",
		"nuclear-power",
		"quality-module-2",
		"energy-shield-equipment",
	},
	unit = {
		count = 500,
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack",   1 },
			{ "chemical-science-pack",   1 },
			{ "space-science-pack",      1 },
		},
		time = 60,
	},
}

data:extend({ discovery_tech })
