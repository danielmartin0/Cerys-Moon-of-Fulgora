-- TODO: Comb through these item categories for broader compatibility improvements.

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
end

if data.raw.recipe["electric-engine-unit-from-carbon"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["electric-engine-unit-from-carbon"], {
		property = "temperature",
		min = 255,
	})
end

-- Prevent burner inserters from being restricted on Cerys:
if data.raw["inserter"]["burner-inserter"] then
	local burner_inserter = data.raw["inserter"]["burner-inserter"]
	if burner_inserter.surface_conditions then
		for i, surface_condition in pairs(burner_inserter.surface_conditions) do
			if surface_condition.property and surface_condition.property == "oxygen" then
				table.remove(burner_inserter.surface_conditions, i)
			end
		end
	end
end
