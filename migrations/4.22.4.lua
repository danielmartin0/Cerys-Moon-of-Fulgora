local lib = require("lib")
local rods = require("scripts.charging-rod")

local CHILD_NAMES = {
	"cerys-charging-rod-glow-r",
	"cerys-charging-rod-glow-b",
	"cerys-charging-rod-animation-r",
	"cerys-charging-rod-animation-b",
	"cerys-charging-rod-lamp-blue",
	"cerys-charging-rod-lamp-red",
}

local surface = lib.generated_cerys_surface()

if surface and surface.valid then
	for _, child in pairs(surface.find_entities_filtered({ name = CHILD_NAMES })) do
		if child.valid then
			child.destroy()
		end
	end
end

storage.rod_registrations = {}

for unit_number, rod in pairs(storage.charging_rods or {}) do
	rod.children = {}
	if rod.entity and rod.entity.valid then
		local reg = script.register_on_object_destroyed(rod.entity)
		storage.rod_registrations[reg] = unit_number
	else
		storage.charging_rods[unit_number] = nil
		storage.charging_rod_is_positive[unit_number] = nil
	end
end

if surface and surface.valid then
	for _, entity in pairs(surface.find_entities_filtered({ name = "cerys-charging-rod" })) do
		if entity.valid then
			local rod = storage.charging_rods[entity.unit_number]
			if rod then
				rods.update_rod_lights(entity, rod)
			end
		end
	end
end
