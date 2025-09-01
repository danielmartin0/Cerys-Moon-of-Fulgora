local common = require("common")
local lib = require("lib")

local surface = lib.generated_cerys_surface()
if not surface then
	return
end

if storage.cerys and storage.cerys.solar_wind_particles then
	for _, particle in pairs(storage.cerys.solar_wind_particles) do
		if particle.velocity then
			particle.velocity.x = particle.velocity.x * (3 / 2) * common.PARTICLE_SIMULATION_SPEED
			particle.velocity.y = particle.velocity.y * (3 / 2) * common.PARTICLE_SIMULATION_SPEED
		end
	end
end
