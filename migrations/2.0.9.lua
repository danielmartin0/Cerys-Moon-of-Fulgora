if not storage.cerys then
	return
end

for _, force in pairs(game.forces) do
	if force.technologies["cerys-fulgoran-cryogenics"].researched then
		force.recipes["cerys-discover-fulgoran-cryogenics"].enabled = false
	end
end
