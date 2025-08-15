local common = require("common")

local surface = common.generated_cerys_surface()
if not surface then
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
