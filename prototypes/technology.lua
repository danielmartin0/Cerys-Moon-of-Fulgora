local common = require("common")
local lib = require("lib")
local merge = lib.merge

data:extend({
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
		name = "cerys-fulgoran-cryogenics",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "methane-ice-dissociation",
			},
			{
				type = "unlock-recipe",
				recipe = "cerys-space-science-pack-from-methane-ice",
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
				recipe = "cerys-explosives-from-ammonium-nitrate",
			},
			{
				type = "unlock-recipe",
				recipe = "superconductor",
			},
			{
				type = "unlock-recipe",
				recipe = "lithium",
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
	},
	{
		type = "technology",
		name = "cerysian-science-pack",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-lab",
			},
			{
				type = "unlock-recipe",
				recipe = "cerysian-science-pack",
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
		name = "cerys-electromagnetic-tooling",
		unit = {
			count = 20,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "space-science-pack", 1 },
			},
			time = 60,
		},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-charging-rod",
			},
			{
				type = "unlock-recipe",
				recipe = "cerys-solar-ghost-maker",
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
			count = 120,
			ingredients = {
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
			{
				type = "unlock-recipe",
				recipe = "cerys-uranium-235-recycling",
			},
		},
		prerequisites = { "cerys-reactor-fuel" },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/nuclear-waste-processing.png",
		icon_size = 256,
		unit = {
			count = 75,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
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
			count = 100,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
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
		},
		prerequisites = {
			"cerys-mixed-oxide-waste-reprocessing",
		},
		icons = util.technology_icon_constant_equipment(
			"__Cerys-Moon-of-Fulgora__/graphics/technology/fission-reactor-equipment.png"
		),
		unit = {
			count = 100,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "space-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
	{
		type = "technology",
		name = "cerys-mixed-oxide-reactors",
		icons = util.technology_icon_constant_recipe_productivity(
			"__Cerys-Moon-of-Fulgora__/graphics/technology/mixed-oxide-reactor.png"
		),
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
			"cerys-lubricant-synthesis",
			"cerys-reactor-fuel",
		},
		unit = {
			count = 2000,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "space-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
		order = "z",
	},
	{
		type = "technology",
		name = "cerys-radioactive-module",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/radioactive-module.png",
		icon_size = 1024,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-radioactive-module-charged",
			},
			{
				type = "unlock-recipe",
				recipe = "cerys-radioactive-module-recharging",
			},
			{
				type = "unlock-recipe",
				recipe = "cerys-radiation-proof-inserter",
			},
		},
		prerequisites = {
			"cerysian-science-pack",
		},
		unit = {
			count = 200,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "space-science-pack", 1 },
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
			"cerysian-science-pack",
		},
		unit = {
			count = 50,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
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
				recipe = "cerys-neutron-bomb",
			},
			-- {
			-- 	type = "unlock-recipe",
			-- 	recipe = "atomic-bomb",
			-- },
			{
				type = "unlock-recipe",
				recipe = "cerys-hydrogen-bomb",
			},
		},
		prerequisites = {
			"cerys-electromagnetic-tooling",
			"cerys-mixed-oxide-waste-reprocessing",
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/plutonium-weaponry.png",
		icon_size = 256,
		unit = {
			count = 500,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "space-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
})

local CARGO_DROPS_PREREQS = { "cerys-plutonium-weaponry", "cerys-lubricant-synthesis" }

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
			prerequisites = CARGO_DROPS_PREREQS,
			research_trigger = {
				type = "send-item-to-orbit",
				item = "cerys-hydrogen-bomb",
			},
			localised_name = {
				"cerys.cargo-drops-tech-name",
			},
			localised_description = {
				"cerys.cargo-drops-tech-description",
			},
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
	-- Adjusted later if any-planet-start is installed:
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

data:extend({
	{
		type = "technology",
		name = common.FULGORAN_TOWER_MINING_TECH_NAME,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "cerys-radiative-tower",
			},
			{
				type = "nothing",
				recipe = "cerys-radiative-tower",
				effect_description = {
					"cerys.mining-radiative-towers",
				},
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/radiative-tower.png",
				icon_size = 64,
			},
		},
		prerequisites = is_sandbox_mode and CARGO_DROPS_PREREQS or {
			"planetslib-cerys-cargo-drops",
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/radiative-heaters.png",
		icon_size = 200,
		unit = {
			count = 2000,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "space-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
})

if data.raw.tool["cryogenic-science-pack"] then
	table.insert(
		data.raw.technology[common.FULGORAN_TOWER_MINING_TECH_NAME].unit.ingredients,
		{ "cryogenic-science-pack", 1 }
	)
	if data.raw.technology["cryogenic-science-pack"] then
		table.insert(
			data.raw.technology[common.FULGORAN_TOWER_MINING_TECH_NAME].prerequisites,
			"cryogenic-science-pack"
		)
	end
end

local holmium_productivity_effects = {}
if data.raw.recipe["holmium-plate"] then
	table.insert(holmium_productivity_effects, {
		type = "change-recipe-productivity",
		recipe = "holmium-plate",
		change = 0.1,
	})
end
table.insert(holmium_productivity_effects, {
	type = "change-recipe-productivity",
	recipe = "maraxsis-holmium-recrystalization",
	change = 0.1,
})

data:extend({
	{
		type = "technology",
		name = "cerys-holmium-plate-productivity-1",
		icons = util.technology_icon_constant_recipe_productivity(
			"__space-age__/graphics/technology/holmium-processing.png"
		),
		icon_size = 256,
		effects = holmium_productivity_effects,
		prerequisites = { "cerysian-science-pack" },
		unit = {
			count = 10,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
			},
			time = 60,
		},
		upgrade = true,
		order = "z-a",
	},
	{
		type = "technology",
		name = "cerys-holmium-recrystalization",
		icon = "__space-age__/graphics/technology/holmium-processing.png",
		icon_size = 256,
		effects = { {
			type = "unlock-recipe",
			recipe = "maraxsis-holmium-recrystalization",
		} },
		prerequisites = { "cerys-holmium-plate-productivity-1" },
		unit = {
			count = 40,
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
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
		effects = holmium_productivity_effects,
		prerequisites = { "cerys-holmium-plate-productivity-1" },
		unit = {
			count_formula = "2^(L-2)*100",
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "space-science-pack", 1 },
			},
			time = 60,
		},
		max_level = "infinite",
		upgrade = true,
	},
})

local engine_productivity_effects = {}
for _, recipe_name in ipairs({
	"engine-unit",
	"electric-engine-unit",
	"motor",
	"electric-motor",
	"vgal-advanced-circuit-electric-engine-unit",
	"vgal-plastic-bar-electric-engine-unit",
	"vgal-low-density-structure-engine-unit",
	"vgal-lubricant-engine-unit",
	"casting-engine-unit",
}) do
	if data.raw.recipe[recipe_name] then
		table.insert(engine_productivity_effects, {
			type = "change-recipe-productivity",
			recipe = recipe_name,
			change = 0.1,
		})
	end
end

data:extend({

	{
		type = "technology",
		name = "cerys-engine-unit-productivity-1",
		icons = util.technology_icon_constant_recipe_productivity("__base__/graphics/technology/engine.png"),
		effects = engine_productivity_effects,
		prerequisites = { "cerysian-science-pack" },
		unit = {
			count = 10,
			ingredients = {
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		upgrade = true,
		order = "z-b",
	},
	{
		type = "technology",
		name = "cerys-engine-unit-productivity-2",
		icons = util.technology_icon_constant_recipe_productivity("__base__/graphics/technology/engine.png"),
		effects = engine_productivity_effects,
		prerequisites = { "cerys-engine-unit-productivity-1" },
		unit = {
			count_formula = "2^(L-2)*100",
			ingredients = {
				{ "cerysian-science-pack", 1 },
				{ "logistic-science-pack", 1 },
			},
			time = 60,
		},
		max_level = "infinite",
		upgrade = true,
	},
})

local fuel_productivity_effects = {}
for _, recipe in pairs(data.raw.recipe) do
	if recipe.results and #recipe.results == 1 and recipe.results[1].type == "item" then
		local result_name = recipe.results[1].name

		if result_name and data.raw.item[result_name] and data.raw.item[result_name].fuel_category then
			local fuel_category = data.raw.item[result_name].fuel_category

			if fuel_category == "nuclear-mixed-oxide" or fuel_category == "nuclear" or fuel_category == "fusion" then
				table.insert(fuel_productivity_effects, {
					type = "change-recipe-productivity",
					recipe = recipe.name,
					change = 0.1,
				})
			end
		end
	end
end

data:extend({
	{
		type = "technology",
		name = "cerys-reactor-fuel",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/mixed-oxide-fuel-cell.png",
		icon_size = 256,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "mixed-oxide-fuel-cell",
			},
		},
		prerequisites = {
			"cerysian-science-pack",
		},
		unit = {
			count = 30,
			ingredients = {
				{ "cerysian-science-pack", 1 },
			},
			time = 60,
		},
		allows_productivity = false,
	},
	-- {
	-- 	type = "technology",
	-- 	name = "cerys-reactor-fuel-productivity-1",
	-- 	icons = util.technology_icon_constant_recipe_productivity(
	-- 		"__Cerys-Moon-of-Fulgora__/graphics/technology/mixed-oxide-reactor.png"
	-- 	),
	-- 	effects = fuel_productivity_effects,
	-- 	prerequisites = { "cerys-advanced-structure-repair" },
	-- 	unit = {
	-- 		count = 100,
	-- 		ingredients = {
	-- 			{ "cerysian-science-pack", 1 },
	-- 			{ "logistic-science-pack", 1 },
	-- 		},
	-- 		time = 60,
	-- 	},
	-- 	upgrade = true,
	-- },
	-- {
	-- 	type = "technology",
	-- 	name = "cerys-reactor-fuel-productivity-2",
	-- 	icons = util.technology_icon_constant_recipe_productivity(
	-- 		"__Cerys-Moon-of-Fulgora__/graphics/technology/mixed-oxide-reactor.png"
	-- 	),
	-- 	effects = fuel_productivity_effects,
	-- 	prerequisites = { "cerys-reactor-fuel-productivity-1" },
	-- 	unit = {
	-- 		count_formula = "3^(L-1)*100",
	-- 		ingredients = {
	-- 			{ "cerysian-science-pack", 1 },
	-- 			{ "logistic-science-pack", 1 },
	-- 			{ "chemical-science-pack", 1 },
	-- 		},
	-- 		time = 60,
	-- 	},
	-- 	max_level = "infinite",
	-- 	upgrade = true,
	-- },
})

if not settings.startup["cerys-disable-secret-cell-productivity-tech-for-legacy-saves"].value then
	data:extend({
		{
			type = "technology",
			name = "cerys-legacy-reactor-fuel-productivity",
			icons = util.technology_icon_constant_recipe_productivity(
				"__Cerys-Moon-of-Fulgora__/graphics/technology/mixed-oxide-fuel-cell.png"
			),
			effects = {
				{
					type = "change-recipe-productivity",
					recipe = "mixed-oxide-fuel-cell",
					change = 1,
				},
			},
			prerequisites = { "cerys-reactor-fuel" },
			unit = {
				count = 1,
				ingredients = {},
				time = 1,
			},
		},
		{
			type = "technology",
			name = "cerys-z-disable-legacy-tech-when-researched", -- A trick to prevent enable-all-technology commands from enabling the legacy tech.
			icons = util.technology_icon_constant_recipe_productivity(
				"__Cerys-Moon-of-Fulgora__/graphics/technology/mixed-oxide-fuel-cell.png"
			),
			hidden = true,
			effects = {},
			prerequisites = { "cerys-legacy-reactor-fuel-productivity" },
			unit = {
				count = 1,
				ingredients = {},
				time = 1,
			},
		},
	})
end

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
