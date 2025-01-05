local override_surface_conditions = require("lib").override_surface_conditions

if mods["maraxsis"] then
	if data.raw.recipe["maraxsis-petroleum-gas-cracking"] then
		override_surface_conditions(data.raw.recipe["maraxsis-petroleum-gas-cracking"], {
			property = "temperature",
			min = 255,
		})
	end
end
