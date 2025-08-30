local common = require("common")
local lib = require("lib")

local surface = lib.generated_cerys_surface()
if not surface then
	return
end

if storage.cerys and storage.cerys.solar_wind_particles then
	for _, particle in pairs(storage.cerys.solar_wind_particles) do
		if particle.velocity then
			particle.velocity.x = particle.velocity.x * (2 / 3)
			particle.velocity.y = particle.velocity.y * (2 / 3)
		end
	end
end
