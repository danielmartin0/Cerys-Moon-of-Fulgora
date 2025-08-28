for _, technology in pairs(data.raw.technology) do
	local processing_unit_productivity_change = 0
	local scrap_recycling_productivity_change = 0
	local cerys_chips_productivity_change = 0
	local cerys_scrap_productivity_change = 0

	if technology.effects then
		for _, effect in ipairs(technology.effects) do
			if effect.type == "change-recipe-productivity" and effect.recipe == "processing-unit" then
				processing_unit_productivity_change = processing_unit_productivity_change + effect.change
			end

			if effect.type == "change-recipe-productivity" and effect.recipe == "scrap-recycling" then
				scrap_recycling_productivity_change = scrap_recycling_productivity_change + effect.change
			end

			if
				effect.type == "change-recipe-productivity"
				and effect.recipe == "cerys-processing-units-from-nitric-acid"
			then
				cerys_chips_productivity_change = cerys_chips_productivity_change + effect.change
			end

			if effect.type == "change-recipe-productivity" and effect.recipe == "cerys-scrap-recycling" then
				cerys_scrap_productivity_change = cerys_scrap_productivity_change + effect.change
			end
		end

		if processing_unit_productivity_change ~= 0 and cerys_chips_productivity_change == 0 then
			table.insert(technology.effects, {
				type = "change-recipe-productivity",
				recipe = "cerys-processing-units-from-nitric-acid",
				change = processing_unit_productivity_change,
			})
		end

		if scrap_recycling_productivity_change ~= 0 and cerys_scrap_productivity_change == 0 then
			table.insert(technology.effects, {
				type = "change-recipe-productivity",
				recipe = "cerys-nuclear-scrap-recycling",
				change = scrap_recycling_productivity_change,
			})
		end
	end
end

--== Flare stack ==--

if settings.startup["cerys-disable-flare-stack-item-venting"].value then
	data.raw.technology["flare-stack-item-venting-electric-tech"].enabled = false
	data.raw.technology["flare-stack-item-venting-tech"].enabled = false
end

data.raw.technology["flare-stack-fluid-venting-tech"].prerequisites = { "cerysian-science-pack" }
data.raw.technology["flare-stack-fluid-venting-tech"].unit = {
	count = 10,
	ingredients = {
		{ "cerysian-science-pack", 1 },
	},
	time = 60,
}
data.raw.technology["flare-stack-fluid-venting-tech"].allows_productivity = false

--== Prevent hidden prerequisites on Moon Discovery Cerys ==--

local tech = data.raw.technology["moon-discovery-cerys"]
if tech and tech.prerequisites then
	local valid_prereqs = {}
	for _, prereq_name in ipairs(tech.prerequisites) do
		local prereq_tech = data.raw.technology[prereq_name]
		if prereq_tech and not prereq_tech.hidden then
			table.insert(valid_prereqs, prereq_name)
		end
	end
	tech.prerequisites = valid_prereqs
end

--== Remove duplicate productivity effects from cerys technologies ==--

for _, technology in pairs(data.raw.technology) do
	if technology.name and string.sub(technology.name, 1, 6) == "cerys-" and technology.effects then
		local unique_effects = {}
		local seen_recipes = {}

		for _, effect in ipairs(technology.effects) do
			if effect.type == "change-recipe-productivity" and effect.recipe then
				if not seen_recipes[effect.recipe] then
					table.insert(unique_effects, effect)
					seen_recipes[effect.recipe] = true
				end
			else
				table.insert(unique_effects, effect)
			end
		end
		technology.effects = unique_effects
	end
end
