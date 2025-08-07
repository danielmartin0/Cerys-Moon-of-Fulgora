local common = require("common")
local common_data = require("common-data-only")
local lib = require("lib")
local merge = lib.merge
local find = lib.find

if common_data.K2_INSTALLED then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["utility-science-pack"], common.AMBIENT_RADIATION_MAX)

	table.insert(data.raw.technology["cerys-fulgoran-cryogenics"].effects, {
		type = "unlock-recipe",
		recipe = "cerys-utility-science-pack",
	})
end
