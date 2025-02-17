if mods["maraxsis"] then
	if data.raw.recipe["maraxsis-petroleum-gas-cracking"] then
		PlanetsLib.restrict_surface_conditions(data.raw.recipe["maraxsis-petroleum-gas-cracking"], {
			property = "temperature",
			min = 255,
		})
	end

	if data.raw.recipe["rocket-part"].surface_conditions then
		PlanetsLib.relax_surface_conditions(data.raw.recipe["rocket-part"], {
			property = "gravity",
			min = 0.1,
		})
	end

	if data.raw.recipe["maraxsis-sublimation"] then
		PlanetsLib.restrict_surface_conditions(data.raw.recipe["maraxsis-sublimation"], {
			property = "temperature",
			min = 255,
		})
	end
end
