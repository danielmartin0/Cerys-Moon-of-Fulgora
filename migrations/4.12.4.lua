local lib = require("lib")

local surface = lib.generated_cerys_surface()
if not surface then
	return
end

local cryogenic_plant = require("scripts.cryogenic-plant")
storage.cerys_fulgoran_cryoplants = storage.cerys_fulgoran_cryoplants or {}

local cryoplants = surface.find_entities_filtered({
	name = "cerys-fulgoran-cryogenic-plant",
})

for _, e in pairs(cryoplants) do
	cryogenic_plant.register_cryogenic_plant(e)
end
