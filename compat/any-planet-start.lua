if mods["any-planet-start"] then
	local planet = settings.startup["aps-planet"].value --[[@as string]]
	if planet == "nauvis" then
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
		if discovery_tech.prerequisites[i] == "nuclear-power" then
			table.remove(discovery_tech.prerequisites, i)
			break
		end
	end

	table.insert(discovery_tech.effects, {
		type = "unlock-recipe",
		recipe = "heat-exchanger",
	})
end
