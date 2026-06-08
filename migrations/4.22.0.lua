local lib = require("lib")
local rods = require("scripts.charging-rod")

if not (storage.cerys and storage.cerys.charging_rods) then
	return
end

storage.cerys.rod_registrations = storage.cerys.rod_registrations or {}

local CHILD_NAMES = {
	"cerys-charging-rod-glow-r",
	"cerys-charging-rod-glow-b",
	"cerys-charging-rod-animation-r",
	"cerys-charging-rod-animation-b",
	"cerys-charging-rod-lamp-blue",
	"cerys-charging-rod-lamp-red",
}

local LEGACY_FIELDS = {
	"red_light_entity",
	"blue_light_entity",
	"red_glow_entity",
	"blue_glow_entity",
	"red_lamp_entity",
	"blue_lamp_entity",
}

local surface = lib.generated_cerys_surface()

if surface and surface.valid then
	for _, child in pairs(surface.find_entities_filtered({ name = CHILD_NAMES })) do
		if child.valid then
			child.destroy()
		end
	end
end

for unit_number, rod in pairs(storage.cerys.charging_rods) do
	for _, field in ipairs(LEGACY_FIELDS) do
		rod[field] = nil
	end
	rod.children = {}

	if rod.entity and rod.entity.valid then
		local reg = script.register_on_object_destroyed(rod.entity)
		storage.cerys.rod_registrations[reg] = unit_number

		if rod.entity.name ~= "entity-ghost" then
			rods.update_rod_lights(rod.entity, rod)
		end
	else
		storage.cerys.charging_rods[unit_number] = nil
		storage.cerys.charging_rod_is_positive[unit_number] = nil
	end
end
