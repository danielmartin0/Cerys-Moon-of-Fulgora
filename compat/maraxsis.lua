local common = require("common")
local lib = require("lib")

if mods["maraxsis"] then
	if data.raw.recipe["maraxsis-petroleum-gas-cracking"] then
		PlanetsLib.restrict_surface_conditions(
			data.raw.recipe["maraxsis-petroleum-gas-cracking"],
			common.TEMPERATURE_MIN
		)
	end

	if data.raw.recipe["rocket-part"].surface_conditions then
		PlanetsLib.relax_surface_conditions(data.raw.recipe["rocket-part"], common.GRAVITY_MIN)
	end

	if data.raw.recipe["maraxsis-sublimation"] then
		PlanetsLib.restrict_surface_conditions(data.raw.recipe["maraxsis-sublimation"], common.TEMPERATURE_MIN)
	end

	if data.raw["fusion-generator"]["maraxsis-oversized-steam-turbine"] then
		PlanetsLib.remove_surface_condition(
			data.raw["fusion-generator"]["maraxsis-oversized-steam-turbine"],
			common.MAGNETIC_FIELD_MAX
		)
	end

	if data.raw["fusion-generator"]["muluna-cycling-steam-turbine"] then
		PlanetsLib.remove_surface_condition(
			data.raw["fusion-generator"]["muluna-cycling-steam-turbine"],
			common.MAGNETIC_FIELD_MAX
		)
	end
end
