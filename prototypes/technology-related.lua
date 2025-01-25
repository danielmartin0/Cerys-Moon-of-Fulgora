--== In the past this file was imported in data-final-fixes because Cerysian science caused compatibility problems with so many mods. It has now been moved back to data.lua after the 1.0 release. ==--

local lib = require("lib")
local merge = lib.merge
local cerys_tech = lib.cerys_tech

data:extend({
	{
		type = "recipe",
		name = "cerys-science-pack",
		always_show_made_in = true,
		category = "fulgoran-cryogenics",
		enabled = false,
		energy_required = 2,
		ingredients = {
			{ type = "item", name = "superconductor", amount = 1 },
			{ type = "item", name = "uranium-238", amount = 6 },
			{ type = "fluid", name = "nitric-acid", amount = 50 },
			{ type = "fluid", name = "ammonia", amount = 50 },
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
		allow_productivity = true,
	},

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
			{
				type = "unlock-recipe",
				recipe = "ancient-structure-repair-part",
			},
			{
				type = "unlock-recipe",
				recipe = "plutonium-239",
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
				{ "cerys-science-pack", 1 },
			},
			time = 60,
		},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-charging-rod",
			},
		},
		prerequisites = { "cerys-science-pack" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/charging-rod.png",
		icon_size = 256,
	}),
	cerys_tech({
		science_count = 150,
		name = "cerys-advanced-structure-repair",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-fulgoran-reactor-scaffold",
			},
		},
		prerequisites = { "cerys-science-pack" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/advanced-structure-repair.png",
		icon_size = 256,
	}),
	cerys_tech({
		science_count = 250,
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
			{
				type = "unlock-recipe",
				recipe = "coal-synthesis",
			},
		},
		prerequisites = { "cerys-advanced-structure-repair", "flare-stack-fluid-venting-tech" },
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
			count = 1000,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerys-science-pack", 1 },
			},
			time = 60,
		},
		name = "cerys-applications-of-radioactivity",
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
			-- {
			-- 	type = "unlock-recipe",
			-- 	recipe = "plutonium-cannon-shell",
			-- },
			-- {
			-- 	type = "unlock-recipe",
			-- 	recipe = "explosive-plutonium-cannon-shell",
			-- },
		},
		prerequisites = {
			"cerys-plutonium-enhanced-fuel-reprocessing",
			"uranium-ammo",
			"fission-reactor-equipment",
			"kovarex-enrichment-process",
		},
		icons = util.technology_icon_constant_equipment(
			"__Cerys-Moon-of-Fulgora__/graphics/technology/fission-reactor-equipment.png"
		),
	}),
	cerys_tech({
		unit = {
			count = 4000,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerys-science-pack", 1 },
				{ "utility-science-pack", 1 },
			},
			time = 60,
		},
		name = "cerys-plutonium-weaponry",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-hydrogen-bomb",
			},
			{
				type = "unlock-recipe",
				recipe = "cerys-neutron-bomb",
			},
		},
		prerequisites = {
			"cerys-lubricant-synthesis",
			"cerys-applications-of-radioactivity",
			"atomic-bomb",
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/plutonium-weaponry.png",
		icon_size = 256,
	}),
	cerys_tech({
		unit = {
			count = 750,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerys-science-pack", 1 },
			},
			time = 60,
		},
		name = "cerys-mixed-oxide-reactor",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-mixed-oxide-reactor",
			},
			{
				type = "unlock-recipe",
				recipe = "lithium-plate",
			},
		},
		prerequisites = {
			"cerys-plutonium-enhanced-fuel-reprocessing",
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/reactor-tech.png",
		icon_size = 256,
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
		prerequisites = { "cerys-advanced-structure-repair", "cerys-lubricant-synthesis" },
		unit = {
			count = 400,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerys-science-pack", 1 },
				{ "utility-science-pack", 1 },
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
			count_formula = "3^(L-1)*400",
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerys-science-pack", 1 },
				{ "utility-science-pack", 1 },
			},
			time = 60,
		},
		max_level = "infinite",
		upgrade = true,
	},
})

data:extend({
	merge(
		PlanetsLib.cargo_drops_technology_base("cerys", "__Cerys-Moon-of-Fulgora__/graphics/technology/cerys.png", 256),
		{
			prerequisites = { "cerys-lubricant-synthesis" },
			unit = {
				count = 1500,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack", 1 },
					{ "cerys-science-pack", 1 },
					{ "utility-science-pack", 1 },
				},
				time = 60,
			},
		}
	),
})

local discovery_tech = {
	type = "technology",
	name = "moon-discovery-cerys",
	icons = PlanetsLib.technology_icons_moon("__Cerys-Moon-of-Fulgora__/graphics/technology/cerys.png"),
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
		"kovarex-enrichment-process",
		"quality-module-2",
		"productivity-module-2",
		"energy-shield-equipment",
		"effect-transmission",
	},
	unit = {
		count = 500,
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "space-science-pack", 1 },
		},
		time = 60,
	},
}

data:extend({ discovery_tech })

local cryogenics_tech = cerys_tech({
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
			{ "fulgoran-cryogenics-progress", 1 },
		},
		time = 60,
	},
	icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/cryogenic-plant.png",
	icon_size = 256,
})

if settings.startup["cerys-technology-compatibility-mode"].value then
	cryogenics_tech.unit = nil
	cryogenics_tech.research_trigger = {
		type = "craft-item",
		item = "ancient-structure-repair-part",
	}
end

data:extend({ cryogenics_tech })
