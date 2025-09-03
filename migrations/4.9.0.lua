local common = require("common")
local lib = require("lib")

local surface = lib.generated_cerys_surface()
if not surface then
	return
end

for tile_name, replacement_name in pairs(common.TILE_REPLACEMENTS) do
	local old_tiles = surface.find_tiles_filtered({ name = tile_name })

	local new_tiles = {}

	for _, old_tile in pairs(old_tiles) do
		if old_tile.valid then
			table.insert(new_tiles, {
				name = replacement_name,
				position = old_tile.position,
			})
		end
	end

	surface.set_tiles(new_tiles, true)
end

if storage.cerys and storage.cerys.solar_wind_particles then
	for _, particle in pairs(storage.cerys.solar_wind_particles) do
		if particle.velocity then
			particle.velocity.x = particle.velocity.x * common.PARTICLE_SIMULATION_SPEED
			particle.velocity.y = particle.velocity.y * common.PARTICLE_SIMULATION_SPEED
		end
	end
end
