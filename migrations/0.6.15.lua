if not storage.cerys then
	return
end

storage.radiative_towers = storage.radiative_towers or {
	towers = {},
	contracted_towers = {},
}

if storage.cerys.heating_towers then
	storage.radiative_towers.towers = storage.cerys.heating_towers
end

if storage.cerys.heating_towers_contracted then
	storage.radiative_towers.contracted_towers = storage.cerys.heating_towers_contracted
end
