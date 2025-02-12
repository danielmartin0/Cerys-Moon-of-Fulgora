local surface = game.surfaces["cerys"]
if not surface or not surface.valid then
	return
end

local crusher = require("scripts.crusher")
storage.cerys_fulgoran_crushers = storage.cerys_fulgoran_crushers or {}

local crushers = surface.find_entities_filtered({
	name = "cerys-fulgoran-crusher",
})

for _, e in pairs(crushers) do
	crusher.register_crusher(e)
end
