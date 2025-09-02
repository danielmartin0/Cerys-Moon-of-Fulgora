if mods["Rocs-Hardcore-Delayed-Tech-Tree"] then
	local discovery_tech = data.raw.technology["moon-discovery-cerys"]
	if discovery_tech then
		for i = #discovery_tech.prerequisites, 1, -1 do
			if discovery_tech.prerequisites[i] == "kovarex-enrichment-process" then
				table.remove(discovery_tech.prerequisites, i)
			end
		end
		local already_has_recipe = false
		for _, effect in ipairs(discovery_tech.effects) do
			if effect.type == "unlock-recipe" and effect.recipe == "kovarex-enrichment-process" then
				already_has_recipe = true
				break
			end
		end
		if not already_has_recipe then
			table.insert(discovery_tech.effects, {
				type = "unlock-recipe",
				recipe = "kovarex-enrichment-process",
			})
		end
	end
end
