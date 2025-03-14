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
		"hidden-reactor-1",
		"hidden-reactor-2",
		"hidden-reactor-3",
		"hidden-reactor-4",
		"hidden-reactor-5",
		"hidden-reactor-6",
		"hidden-reactor-7",
		"hidden-reactor-8",
		"hidden-reactor-9",
		"hidden-reactor-10",
		"hidden-reactor-11",
		"hidden-reactor-12",
		"hidden-reactor-13",
		"hidden-reactor-14",
		"hidden-reactor-15",
		"hidden-reactor-16",
		"hidden-reactor-17",
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
	if tower.entity and tower.entity.valid then
		tower.reactors = {}
		tower.last_radius = nil
		if tower.current_lamp and tower.current_lamp.valid then
			tower.current_lamp.destroy()
			tower.current_lamp = nil
		end
	end
end
