if mods["maraxsis"] then
	if data.raw.recipe["maraxsis-petroleum-gas-cracking"] then
		data.raw.recipe["maraxsis-petroleum-gas-cracking"].surface_conditions = {
			{
				property = "temperature",
				min = 255,
			},
		}
	end
end
