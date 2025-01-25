for _, technology in pairs(data.raw.technology) do
	local processing_unit_productivity_change = 0
	local scrap_recycling_productivity_change = 0

	if technology.effects then
		for _, effect in ipairs(technology.effects) do
			if effect.type == "change-recipe-productivity" and effect.recipe == "processing-unit" then
				processing_unit_productivity_change = processing_unit_productivity_change + effect.change
			end

			if effect.type == "change-recipe-productivity" and effect.recipe == "scrap-recycling" then
				scrap_recycling_productivity_change = scrap_recycling_productivity_change + effect.change
			end
		end

		if processing_unit_productivity_change ~= 0 then
			table.insert(technology.effects, {
				type = "change-recipe-productivity",
				recipe = "processing-units-from-nitric-acid",
				change = processing_unit_productivity_change,
			})
		end

		if scrap_recycling_productivity_change ~= 0 then
			table.insert(technology.effects, {
				type = "change-recipe-productivity",
				recipe = "cerys-nuclear-scrap-recycling",
				change = scrap_recycling_productivity_change,
			})
		end
	end
end

--== Flare stack ==--

data.raw.technology["flare-stack-item-venting-electric-tech"].enabled = false
data.raw.technology["flare-stack-item-venting-tech"].enabled = false
data.raw.technology["flare-stack-fluid-venting-tech"].prerequisites = { "cerys-science-pack" }
data.raw.technology["flare-stack-fluid-venting-tech"].unit = {
	count = 50,
	ingredients = {
		{ "cerys-science-pack", 1 },
	},
	time = 60,
}
