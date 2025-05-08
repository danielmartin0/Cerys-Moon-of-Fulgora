if not storage.cerys then
	return
end

if not (storage.radiative_towers and storage.radiative_towers.towers) then
	return
end

local surface = game.surfaces["cerys"]
if not (surface and surface.valid) then
	return
end

local reactors = surface.find_entities_filtered({
	name = {
		"cerys-hidden-reactor-1",
		"cerys-hidden-reactor-2",
		"cerys-hidden-reactor-3",
		"cerys-hidden-reactor-4",
		"cerys-hidden-reactor-5",
		"cerys-hidden-reactor-6",
		"cerys-hidden-reactor-7",
		"cerys-hidden-reactor-8",
		"cerys-hidden-reactor-9",
		"cerys-hidden-reactor-10",
		"cerys-hidden-reactor-11",
		"cerys-hidden-reactor-12",
		"cerys-hidden-reactor-13",
		"cerys-hidden-reactor-14",
		"cerys-hidden-reactor-15",
		"cerys-hidden-reactor-16",
		"cerys-hidden-reactor-17",
	},
})

for _, reactor in pairs(reactors) do
	if reactor.valid then
		reactor.destroy()
	end
end

local lamps = surface.find_entities_filtered({
	name = {
		"radiative-tower-lamp-1",
		"radiative-tower-lamp-2",
		"radiative-tower-lamp-3",
		"radiative-tower-lamp-4",
		"radiative-tower-lamp-5",
		"radiative-tower-lamp-6",
		"radiative-tower-lamp-7",
		"radiative-tower-lamp-8",
		"radiative-tower-lamp-9",
		"radiative-tower-lamp-10",
		"radiative-tower-lamp-11",
		"radiative-tower-lamp-12",
		"radiative-tower-lamp-13",
		"radiative-tower-lamp-14",
		"radiative-tower-lamp-15",
		"radiative-tower-lamp-16",
		"radiative-tower-lamp-17",
	},
})

for _, lamp in pairs(lamps) do
	if lamp.valid then
		lamp.destroy()
	end
end

for _, tower in pairs(storage.radiative_towers.towers) do
	if
		tower.entity
		and tower.entity.valid
		and tower.entity.surface
		and tower.entity.surface.valid
		and tower.entity.surface.name == "cerys"
	then
		tower.reactors = {}
		tower.last_radius = nil
		tower.current_lamp = nil
	end
end
