if mods["any-planet-start"] then
	local planet = settings.startup["aps-planet"].value --[[@as string]]
	if planet == "nauvis" or planet == "none" then
		return
	end

	local discovery_tech = data.raw.technology["moon-discovery-cerys"]

	if planet == "fulgora" then
		for i = #discovery_tech.prerequisites, 1, -1 do
			if discovery_tech.prerequisites[i] == "planet-discovery-fulgora" then
				table.remove(discovery_tech.prerequisites, i)
				break
			end
		end
	end

	for i = #discovery_tech.prerequisites, 1, -1 do
		local prereq = discovery_tech.prerequisites[i]
		if prereq == "nuclear-power" or prereq == "kovarex-enrichment-process" then
			table.remove(discovery_tech.prerequisites, i)
		end
	end

	if data.raw.recipe["heat-exchanger"] then
		table.insert(discovery_tech.effects, {
			type = "unlock-recipe",
			recipe = "heat-exchanger",
		})
	end
	if data.raw.recipe["kovarex-enrichment-process"] then
		table.insert(discovery_tech.effects, {
			type = "unlock-recipe",
			recipe = "kovarex-enrichment-process",
		})
	end
end
