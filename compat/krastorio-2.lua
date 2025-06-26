local common = require("common")
local common_data = require("common-data-only")
local lib = require("lib")
local merge = lib.merge
local find = lib.find

if common_data.K2_INSTALLED then
	data:extend({
		merge(data.raw.recipe["utility-science-pack"], {
			name = "cerys-utility-science-pack",
			ingredients = {
				{ type = "item", name = "low-density-structure", amount = 5 },
				{ type = "item", name = "processing-unit", amount = 5 },
				{ type = "item", name = "electric-engine-unit", amount = 5 },
				{ type = "item", name = "kr-blank-tech-card", amount = 10 },
			},
			results = { { type = "item", name = "utility-science-pack", amount = 5 } },
			category = "fulgoran-cryogenics",
			subgroup = "cerys-processes",
			order = "k",
		}),
	})

	PlanetsLib.restrict_surface_conditions(data.raw.recipe["utility-science-pack"], common.AMBIENT_RADIATION_MAX)

	table.insert(data.raw.technology["cerys-fulgoran-cryogenics"].effects, {
		type = "unlock-recipe",
		recipe = "cerys-utility-science-pack",
	})

	data.raw.recipe["cerys-charging-rod"].ingredients = {
		{ type = "item", name = "superconductor", amount = 8 },
		{ type = "item", name = "kr-steel-beam", amount = 8 },
		{ type = "item", name = "holmium-plate", amount = 16 }, -- For holmium plate qualitycycling
	}

	data.raw.recipe["cerys-fulgoran-reactor-scaffold"].ingredients = {
		{ type = "item", name = "kr-steel-beam", amount = 400 },
		{ type = "item", name = "refined-concrete", amount = 400 },
		{ type = "item", name = "processing-unit", amount = 50 },
	}

	data.raw.recipe["cerys-nitric-acid"].ingredients = {
		{ type = "fluid", name = "ammonia", amount = 50 },
		{ type = "fluid", name = "kr-oxygen", amount = 50 },
	}
	data.raw.recipe["cerys-nitric-acid"].results = {
		{ type = "fluid", name = "kr-nitric-acid", amount = 50 },
		{ type = "fluid", name = "kr-nitrogen", amount = 50 },
	}
	data.raw.recipe["cerys-nitric-acid"].category = "fulgoran-cryogenics"
	data.raw.recipe["cerys-nitric-acid"].localised_name = { "cerys.nitric-acid-by-ammonia-oxidation" }
	data.raw.recipe["cerys-nitric-acid"].energy_required = 0.5

	if
		not find(data.raw.recipe["cerys-hydrogen-bomb"].ingredients, function(ingredient)
			return ingredient.type == "fluid" and ingredient.name == "kr-hydrogen"
		end)
	then
		table.insert(
			data.raw.recipe["cerys-hydrogen-bomb"].ingredients,
			{ type = "fluid", name = "kr-hydrogen", amount = 25 }
		)
		data.raw.recipe["cerys-hydrogen-bomb"].category = "chemistry"
	end
end
