local common = require("common")
local lib = require("lib")

if mods["maraxsis"] then
	if data.raw.recipe["maraxsis-petroleum-gas-cracking"] then
		PlanetsLib.restrict_surface_conditions(
			data.raw.recipe["maraxsis-petroleum-gas-cracking"],
			common.AMBIENT_RADIATION_MAX
		)
	end

	PlanetsLib.relax_surface_conditions(data.raw.recipe["rocket-part"], common.GRAVITY_MIN)

	if data.raw.recipe["maraxsis-sublimation"] then
		PlanetsLib.restrict_surface_conditions(data.raw.recipe["maraxsis-sublimation"], common.AMBIENT_RADIATION_MAX)
	end

	if data.raw["fusion-generator"]["maraxsis-oversized-steam-turbine"] then
		PlanetsLib.remove_surface_condition(
			data.raw["fusion-generator"]["maraxsis-oversized-steam-turbine"],
			common.AMBIENT_RADIATION_MAX
		)
	end

	if data.raw["fusion-generator"]["muluna-cycling-steam-turbine"] then
		PlanetsLib.remove_surface_condition(
			data.raw["fusion-generator"]["muluna-cycling-steam-turbine"],
			common.AMBIENT_RADIATION_MAX
		)
	end

	-- if
	-- 	settings.startup["cerys-gate-drive-module-behind-maraxsis"].value and data.raw.tool["hydraulic-science-pack"]
	-- then
	-- 	table.insert(data.raw.technology["cerys-drive-module"].unit.ingredients, { "hydraulic-science-pack", 1 })
	-- 	data.raw.technology["cerys-drive-module"].unit.count = 1000
	-- 	table.insert(data.raw.technology["cerys-drive-module"].prerequisites, "hydraulic-science-pack")
	-- 	if data.raw.technology["planetslib-cerys-cargo-drops"] then
	-- 		table.insert(data.raw.technology["cerys-drive-module"].prerequisites, "planetslib-cerys-cargo-drops")
	-- 	end
	-- 	table.insert(data.raw.lab["cerys-lab"].inputs, "hydraulic-science-pack")
	-- end
end
