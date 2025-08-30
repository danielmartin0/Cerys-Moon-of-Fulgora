local common = require("common")
local lib = require("lib")

local surface = lib.generated_cerys_surface()
if not surface then
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
