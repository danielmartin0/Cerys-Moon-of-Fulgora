local radiative_towers = require("scripts.radiative-tower")
local common = require("common")

if not storage.cerys then
	return
end

local surface = game.surfaces["cerys"]
if not (surface and surface.valid) then
	return
end

local towers = surface.find_entities_filtered({
	name = {
		"cerys-fulgoran-radiative-tower-contracted-container",
	},
})

for _, e in ipairs(towers) do
	if e and e.valid and not storage.radiative_towers.contracted_towers[e.unit_number] then
		game.print("[CERYS]: Fix applied to bugged radiative tower near the reactor.", { color = common.WARN_COLOR })

		radiative_towers.register_radiative_tower_contracted(e)
	end
end
