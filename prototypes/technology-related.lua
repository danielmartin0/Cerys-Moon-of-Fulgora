--== In the past this file was imported in data-final-fixes because Cerysian science caused compatibility problems with so many mods. It has now been moved back to data.lua after the 1.0 release. ==--

local common = require("common")
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
		essential = true,
	}),
	cerys_tech({
		science_count = 100,
		name = "cerys-fulgoran-machine-quality-upgrades",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-upgrade-fulgoran-cryogenic-plant-quality",
			},
			{
				type = "unlock-recipe",
				recipe = "cerys-upgrade-fulgoran-crusher-quality",
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
		icon_size = 1000,
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
			count = 3000,
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
				count = common.HARDCORE_ON and 4000 or 1500,
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
		count = 250,
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "space-science-pack", 1 },
		},
		time = 60,
	},
	essential = true,
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

local cerys_lab = merge(data.raw.lab["lab"], {
	name = "cerys-lab",
	inputs = {
		"cerys-science-pack",
		"automation-science-pack",
		"logistic-science-pack",
		"utility-science-pack",
	},
	collision_box = { { -2.15, -1.75 }, { 2.15, 1.75 } },
	selection_box = { { -2.5, -2 }, { 2.5, 2 } },
	minable = { mining_time = 0.2, result = "cerys-lab" },
	surface_conditions = {
		{
			property = "magnetic-field",
			min = 120,
			max = 120,
		},
	},
	energy_usage = "60kW",
	researching_speed = 2,
	frozen_patch = merge(data.raw.lab["lab"].frozen_patch, {
		scale = 0.75,
		shift = util.by_pixel(0, 4),
	}),
	on_animation = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-back.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				shift = util.by_pixel(10, 0),
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
			},
			{
				filename = "__base__/graphics/entity/lab/lab.png",
				width = 194,
				height = 174,
				frame_count = 33,
				line_length = 11,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 1.5),
				scale = 0.68,
			},
			{
				filename = "__base__/graphics/entity/lab/lab-integration.png",
				width = 242,
				height = 162,
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 15.5),
				scale = 0.68,
			},
			{
				filename = "__base__/graphics/entity/lab/lab-light.png",
				blend_mode = "additive",
				draw_as_light = true,
				width = 216,
				height = 194,
				frame_count = 33,
				line_length = 11,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 0),
				scale = 0.68,
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-front-shadow.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				line_length = 1,
				repeat_count = 33,
				shift = util.by_pixel(10, 0),
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-front.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
				shift = util.by_pixel(10, 0),
			},
			{
				filename = "__base__/graphics/entity/lab/lab-shadow.png",
				width = 242,
				height = 136,
				shift = util.by_pixel(13, 11),
				scale = 0.68,
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
				draw_as_shadow = true,
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-shadow.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				shift = util.by_pixel(10, 0),
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
				draw_as_shadow = true,
			},
		},
	},
	off_animation = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-back.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				shift = util.by_pixel(10, 0),
			},
			{
				filename = "__base__/graphics/entity/lab/lab.png",
				width = 194,
				height = 174,
				shift = util.by_pixel(0, 1.5),
				scale = 0.68,
			},
			{
				filename = "__base__/graphics/entity/lab/lab-integration.png",
				width = 242,
				height = 162,
				shift = util.by_pixel(0, 15.5),
				scale = 0.68,
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-front-shadow.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				shift = util.by_pixel(10, 0),
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-front.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				shift = util.by_pixel(10, 0),
			},
			{
				filename = "__base__/graphics/entity/lab/lab-shadow.png",
				width = 242,
				height = 136,
				shift = util.by_pixel(13, 11),
				scale = 0.68,
				draw_as_shadow = true,
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-shadow.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				draw_as_shadow = true,
				shift = util.by_pixel(10, 0),
			},
		},
	},
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cerys-lab-cropped.png", -- Since lab research productivity reads this icon
	icon_size = 64,
	fast_replaceable_group = "nil",
})

data:extend({

	cerys_lab,

	merge(cerys_lab, {
		-- This entity is never placed. It is only in the game to prevent the game from throwing a fit about there being no science lab that can research fulgoran-cryogenics-progress.
		name = "cerys-lab-dummy",
		hidden = true,
		inputs = {
			"fulgoran-cryogenics-progress",
		},
	}),

	merge(data.raw.tool["electromagnetic-science-pack"], {
		name = "cerys-science-pack",
		localised_description = "nil",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cerys-science-pack.png",
		icon_size = 64,
		weight = 1 * 1000 * 1000000, -- Cannot be launched on rocket
		order = "j-a[cerys]",
		default_import_location = "cerys",
	}),
})
