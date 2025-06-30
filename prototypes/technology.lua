local common_data = require("common-data-only")
local common = require("common")
local lib = require("lib")
local merge = lib.merge

data:extend({
	{
		type = "technology",
		name = "cerys-speed-module-three",
		localised_description = { "technology-description.speed-module" },
		icon = "__base__/graphics/technology/speed-module-3.png",
		icon_size = 256,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-speed-module-3-from-nitric-acid",
			},
		},
		prerequisites = { "cerysian-science-pack", "speed-module-2" },
		unit = {
			count = 50,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
	{
		type = "technology",
		name = "cerys-overclock-module",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/overclock-module.png",
		icon_size = 1024,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-overclock-module",
			},
		},
		prerequisites = {
			"cerys-speed-module-three",
			"speed-module-2",
		},
		unit = {
			count = 200,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
	{
		type = "technology",
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
	},
	{
		type = "technology",
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
	},
	{
		type = "technology",
		name = "cerysian-science-pack",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerysian-science-pack",
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
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/cerysian-science-pack.png",
		icon_size = 256,
		essential = true,
	},
	{
		type = "technology",
		name = "cerys-charging-rod",
		unit = {
			count = 75,
			ingredients = {
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-charging-rod",
			},
		},
		prerequisites = { "cerysian-science-pack" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/charging-rod.png",
		icon_size = 1000,
		allows_productivity = false,
	},
	{
		type = "technology",
		name = "cerys-advanced-structure-repair",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-fulgoran-reactor-scaffold",
			},
			{
				type = "unlock-recipe",
				recipe = "cerys-upgrade-fulgoran-cryogenic-plant-quality",
			},
			{
				type = "unlock-recipe",
				recipe = "cerys-upgrade-fulgoran-crusher-quality",
			},
		},
		prerequisites = { "cerysian-science-pack" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/advanced-structure-repair.png",
		icon_size = 256,
		unit = {
			count = 250,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
	{
		type = "technology",
		name = "cerys-mixed-oxide-waste-reprocessing",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "mixed-oxide-cell-reprocessing",
			},
			{
				type = "unlock-recipe",
				recipe = "mixed-oxide-waste-centrifuging",
			},
			{
				type = "unlock-recipe",
				recipe = "cerys-uranium-238-recycling",
			},
		},
		prerequisites = { "cerys-advanced-structure-repair" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/nuclear-waste-processing.png",
		icon_size = 256,
		unit = {
			count = 50,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
	{
		type = "technology",
		name = "cerys-lubricant-synthesis",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-lubricant-synthesis",
			},
		},
		prerequisites = { "cerys-advanced-structure-repair" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/lubricant-synthesis.png",
		icon_size = 256,
		unit = {
			count = 150,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
	{
		type = "technology",
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
			"cerys-lubricant-synthesis",
			"cerys-mixed-oxide-waste-reprocessing",
		},
		icons = util.technology_icon_constant_equipment(
			"__Cerys-Moon-of-Fulgora__/graphics/technology/fission-reactor-equipment.png"
		),
		unit = {
			count = 50,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
				{ "utility-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
	{
		type = "technology",
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
			"cerys-applications-of-radioactivity",
			"atomic-bomb",
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/plutonium-weaponry.png",
		icon_size = 256,
		unit = {
			count = 600,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
				{ "utility-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
})

local cargo_drops_base =
	PlanetsLib.cargo_drops_technology_base("cerys", "__Cerys-Moon-of-Fulgora__/graphics/technology/cerys.png", 256)

local is_sandbox_mode = settings.startup["cerys-sandbox-mode"].value

if not is_sandbox_mode then
	cargo_drops_base.effects[#cargo_drops_base.effects + 1] = {
		type = "unlock-recipe",
		recipe = "cerys-construction-robot-recycling",
	}
	cargo_drops_base.effects[#cargo_drops_base.effects + 1] = {
		type = "unlock-recipe",
		recipe = "cerys-exoskeleton-equipment-recycling",
	}

	data:extend({
		merge(cargo_drops_base, {
			prerequisites = { "cerys-applications-of-radioactivity" }, -- Should be on the bottom row
			unit = {
				count = common.HARD_MODE_ON and 3000 or 1000,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack", 1 },
					{ "cerysian-science-pack", 1 },
					{ "utility-science-pack", 1 },
				},
				time = 60,
			},
			allows_productivity = false,
		}),
	})
end

data:extend({
	{
		type = "technology",
		name = "cerys-nice-try-sukaz",
		hidden = true,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "construction-robot-recycling",
			},
			{
				type = "unlock-recipe",
				recipe = "exoskeleton-equipment-recycling",
			},
		},
		prerequisites = { "moon-discovery-cerys" },
		unit = {
			count = 1,
			ingredients = {
				{ "automation-science-pack", 1 },
			},
			time = 60,
		},
		icons = cargo_drops_base.icons,
	},
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
		"productivity-module-2",
		"energy-shield-equipment", -- if removed, solar energy needs to be added
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

local cryogenics_tech = {
	type = "technology",
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
			recipe = "cerys-nitric-acid",
		},
		{
			type = "unlock-recipe",
			recipe = "cerys-processing-units-from-nitric-acid",
		},
		{
			type = "unlock-recipe",
			recipe = common_data.LITHIUM_NAME,
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
	allows_productivity = false,
}

-- if settings.startup["cerys-technology-compatibility-mode"].value then
-- 	cryogenics_tech.unit = nil
-- 	cryogenics_tech.research_trigger = {
-- 		type = "craft-item",
-- 		item = "ancient-structure-repair-part",
-- 		count = common.FIRST_CRYO_REPAIR_RECIPES_NEEDED,
-- 	}
-- end

data:extend({ cryogenics_tech })

if settings.startup["cerys-player-constructable-radiative-towers"].value then
	data:extend({
		{
			type = "technology",
			name = "cerys-radiative-heaters",
			effects = {
				{
					type = "unlock-recipe",
					recipe = "cerys-radiative-tower",
				},
			},
			prerequisites = {
				is_sandbox_mode and "cerys-applications-of-radioactivity" or "planetslib-cerys-cargo-drops",
			},
			icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/radiative-heaters.png",
			icon_size = 200,
			unit = {
				count = 2000,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack", 1 },
					{ "cerysian-science-pack", 1 },
					{ "utility-science-pack", 1 },
				},
				time = 60,
			},
			allows_productivity = false,
		},
	})

	if data.raw.tool["cryogenic-science-pack"] then
		table.insert(data.raw.technology["cerys-radiative-heaters"].unit.ingredients, { "cryogenic-science-pack", 1 })
		if data.raw.technology["cryogenic-science-pack"] then
			table.insert(data.raw.technology["cerys-radiative-heaters"].prerequisites, "cryogenic-science-pack")
		end
	end
end

local holmium_productivity_effects_1 = {}
local holmium_productivity_effects_2 = {}
table.insert(holmium_productivity_effects_1, {
	type = "unlock-recipe",
	recipe = "maraxsis-holmium-recrystalization",
})
if data.raw.recipe["holmium-plate"] then
	table.insert(holmium_productivity_effects_1, {
		type = "change-recipe-productivity",
		recipe = "holmium-plate",
		change = 0.1,
	})
	table.insert(holmium_productivity_effects_2, {
		type = "change-recipe-productivity",
		recipe = "holmium-plate",
		change = 0.1,
	})
end
table.insert(holmium_productivity_effects_1, {
	type = "change-recipe-productivity",
	recipe = "maraxsis-holmium-recrystalization",
	change = 0.1,
})
table.insert(holmium_productivity_effects_2, {
	type = "change-recipe-productivity",
	recipe = "maraxsis-holmium-recrystalization",
	change = 0.1,
})

local engine_productivity_effects = {}
if data.raw.recipe["engine-unit"] then
	table.insert(engine_productivity_effects, {
		type = "change-recipe-productivity",
		recipe = "engine-unit",
		change = 0.1,
	})
end
if data.raw.recipe["electric-engine-unit"] then
	table.insert(engine_productivity_effects, {
		type = "change-recipe-productivity",
		recipe = "electric-engine-unit",
		change = 0.1,
	})
end
if data.raw.recipe["motor"] then
	table.insert(engine_productivity_effects, {
		type = "change-recipe-productivity",
		recipe = "motor",
		change = 0.1,
	})
end
if data.raw.recipe["electric-motor"] then
	table.insert(engine_productivity_effects, {
		type = "change-recipe-productivity",
		recipe = "electric-motor",
		change = 0.1,
	})
end

data:extend({
	{
		type = "technology",
		name = "cerys-holmium-plate-productivity-1",
		icons = util.technology_icon_constant_recipe_productivity(
			"__space-age__/graphics/technology/holmium-processing.png"
		),
		icon_size = 256,
		effects = holmium_productivity_effects_1,
		prerequisites = { "cerys-lubricant-synthesis" },
		unit = {
			count = 250,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		upgrade = true,
	},
	{
		type = "technology",
		name = "cerys-holmium-plate-productivity-2",
		icons = util.technology_icon_constant_recipe_productivity(
			"__space-age__/graphics/technology/holmium-processing.png"
		),
		icon_size = 256,
		effects = holmium_productivity_effects_2,
		prerequisites = { "cerys-holmium-plate-productivity-1" },
		unit = {
			count_formula = "2^(L-1)*200",
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
				{ "utility-science-pack", 1 },
			},
			time = 60,
		},
		max_level = "infinite",
		upgrade = true,
	},
	{
		type = "technology",
		name = "cerys-engine-unit-productivity-1",
		icons = util.technology_icon_constant_recipe_productivity("__base__/graphics/technology/engine.png"),
		effects = engine_productivity_effects,
		prerequisites = { "cerysian-science-pack" },
		unit = {
			count = 50,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		upgrade = true,
	},
	{
		type = "technology",
		name = "cerys-engine-unit-productivity-2",
		icons = util.technology_icon_constant_recipe_productivity("__base__/graphics/technology/engine.png"),
		effects = engine_productivity_effects,
		prerequisites = { "cerys-engine-unit-productivity-1" },
		unit = {
			count = 200,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		upgrade = true,
	},
	{
		type = "technology",
		name = "cerys-engine-unit-productivity-3",
		icons = util.technology_icon_constant_recipe_productivity("__base__/graphics/technology/engine.png"),
		effects = engine_productivity_effects,
		prerequisites = { "cerys-engine-unit-productivity-2" },
		unit = {
			count_formula = "2^(L-2)*500",
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "cerysian-science-pack", 1 },
				{ "utility-science-pack", 1 },
			},
			time = 60,
		},
		max_level = "infinite",
		upgrade = true,
	},
})

if
	settings.startup["cerys-infinite-braking-technology"].value
	and data.raw.technology["braking-force-7"]
	and data.raw.technology["braking-force-7"].max_level ~= "infinite"
then
	data:extend({
		{
			type = "technology",
			name = "braking-force-8",
			icons = util.technology_icon_constant_braking_force("__base__/graphics/technology/braking-force.png"),
			effects = {
				{
					type = "train-braking-force-bonus",
					modifier = 0.15,
				},
			},
			prerequisites = { "braking-force-7" },
			unit = {
				count_formula = "2^(L-7)*" .. data.raw.technology["braking-force-7"].unit.count,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack", 1 },
					{ "chemical-science-pack", 1 },
					{ "production-science-pack", 1 },
					{ "utility-science-pack", 1 },
				},
				time = 60,
			},
			max_level = "infinite",
			upgrade = true,
		},
	})
end
