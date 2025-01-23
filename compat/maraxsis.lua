local restrict_surface_conditions = require("lib").restrict_surface_conditions
local relax_surface_conditions = require("lib").relax_surface_conditions

if mods["maraxsis"] then
	if data.raw.recipe["maraxsis-petroleum-gas-cracking"] then
		restrict_surface_conditions(data.raw.recipe["maraxsis-petroleum-gas-cracking"], {
			property = "temperature",
			min = 255,
		})
	end

	if data.raw.recipe["rocket-part"].surface_conditions then
		relax_surface_conditions(data.raw.recipe["rocket-part"], {
			property = "gravity",
			min = 0.1,
		})
	end

	if data.raw.recipe["maraxsis-sublimation"] then
		restrict_surface_conditions(data.raw.recipe["maraxsis-sublimation"], {
			property = "temperature",
			min = 255,
		})
	end
end
