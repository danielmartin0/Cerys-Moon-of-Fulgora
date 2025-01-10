local override_surface_conditions = require("lib").override_surface_conditions

if mods["maraxsis"] then
	if data.raw.recipe["maraxsis-petroleum-gas-cracking"] then
		override_surface_conditions(data.raw.recipe["maraxsis-petroleum-gas-cracking"], {
			property = "temperature",
			min = 255,
		})
	end

	if data.raw.recipe["rocket-part"].surface_conditions then
		for _, surface_condition in pairs(data.raw.recipe["rocket-part"].surface_conditions) do
			if surface_condition.property == "gravity" and surface_condition.min > 0.1 then
				surface_condition.min = 0.1
			end
		end
	end

	if data.raw.recipe["maraxsis-sublimation"] then
		override_surface_conditions(data.raw.recipe["maraxsis-sublimation"], {
			property = "temperature",
			min = 255,
		})
	end
end
