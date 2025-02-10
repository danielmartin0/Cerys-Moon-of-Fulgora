local restrict_surface_conditions = require("lib").restrict_surface_conditions

--== Mulana seems to be overriding science packs to have min oxygen of 1, whereas oxygen is afaik supposed to be used to restrict burner items.

for _, pack in pairs(data.raw["tool"]) do
	local recipe = data.raw["recipe"][pack.name]
	if recipe then
		if recipe.surface_conditions then
			for _, surface_condition in pairs(recipe.surface_conditions) do
				if
					surface_condition.property
					and surface_condition.property == "oxygen"
					and surface_condition.min == 1
				then
					surface_condition.min = 0
				end
			end
		end
	end

	if data.raw.recipe["electric-engine-unit-from-carbon"] then
		restrict_surface_conditions(data.raw.recipe["electric-engine-unit-from-carbon"], {
			property = "temperature",
			min = 255,
		})
	end
end
