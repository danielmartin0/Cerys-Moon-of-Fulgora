if not storage.cerys then
	return
end

for _, particle in pairs(storage.cerys.solar_wind_particles) do
	if particle.entity and particle.entity.valid then
		particle.entity.destroy()
	end
	particle.entity = nil
end
