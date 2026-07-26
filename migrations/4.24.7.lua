for _, particle in pairs(storage.solar_wind_particles or {}) do
	if not particle.birth_tick then
		particle.birth_tick = game.tick - (particle.age or 0)
	end
	particle.age = nil
end
