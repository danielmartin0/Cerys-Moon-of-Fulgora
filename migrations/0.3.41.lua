local surface = game.surfaces["cerys"]
if not surface or not surface.valid then
	return
end

for _, entity in pairs(surface.find_entities_filtered({ name = "cerys-fulgoran-cryogenic-plant-wreck" })) do
	if entity and entity.valid then
		entity.minable_flag = false
		entity.destructible = false
	end
end

for _, entity in pairs(surface.find_entities_filtered({ name = "cerys-fulgoran-cryogenic-plant" })) do
	if entity and entity.valid then
		entity.minable_flag = false
		entity.destructible = false
	end
end
