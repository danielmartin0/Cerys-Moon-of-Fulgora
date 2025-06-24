local radiative_towers = require("scripts.radiative-tower")
local common = require("common")

if not storage.cerys then
	return
end

local surface = game.surfaces["cerys"]
if not (surface and surface.valid) then
	return
end

if not (storage.cerys.reactor and storage.cerys.reactor.entity and storage.cerys.reactor.entity.valid) then
	return
end

local corners = {
	{ x = storage.cerys.reactor.entity.position.x - 11, y = storage.cerys.reactor.entity.position.y - 11 },
	{ x = storage.cerys.reactor.entity.position.x + 11, y = storage.cerys.reactor.entity.position.y - 11 },
	{ x = storage.cerys.reactor.entity.position.x + 11, y = storage.cerys.reactor.entity.position.y + 11 },
	{ x = storage.cerys.reactor.entity.position.x - 11, y = storage.cerys.reactor.entity.position.y + 11 },
}

local min_distance = (
	common.HARD_MODE_ON and common.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS_HARD_MODE
	or common.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS
) + 2

local towers_found = 0

for _, corner in pairs(corners) do
	local nearby_towers = surface.find_entities_filtered({
		area = {
			{ x = corner.x - min_distance, y = corner.y - min_distance },
			{ x = corner.x + min_distance, y = corner.y + min_distance },
		},
		name = {
			"cerys-fulgoran-radiative-tower-contracted-container",
			"cerys-fulgoran-radiative-tower",
			"cerys-fulgoran-radiative-tower-base-frozen",
			"cerys-fulgoran-radiative-tower-base",
			"cerys-fulgoran-radiative-tower-rising-reactor-base",
		},
	})

	towers_found = towers_found + #nearby_towers
end

if towers_found == 0 then
	game.print("[CERYS]: Adding missing radiative tower in range of the reactor.", { color = common.WARN_COLOR })

	local p =
		surface.find_non_colliding_position("cerys-fulgoran-radiative-tower-contracted-container", corners[1], 10, 0.5)

	if p then
		local e = surface.create_entity({
			name = "cerys-fulgoran-radiative-tower-contracted-container",
			position = p,
			force = "player",
		})
		script.raise_script_built({ entity = e })

		if e and e.valid then
			e.minable_flag = false
			e.destructible = false

			radiative_towers.register_radiative_tower_contracted(e)
		end
	end
end
