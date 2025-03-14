if not storage.cerys then
	return
end

if not (storage.radiative_towers and storage.radiative_towers.towers) then
	return
end

for _, tower in pairs(storage.radiative_towers.towers) do
	if tower.entity and tower.entity.valid and tower.reactors then
		for r, reactor in pairs(tower.reactors) do
			if reactor and reactor.valid then
				local reactor_north = reactor.surface.create_entity({
					name = reactor.name,
					position = { x = reactor.position.x, y = reactor.position.y - (tower.is_player_tower and 0 or 0.5) },
					force = reactor.force,
				})

				if reactor_north and reactor_north.valid then
					reactor_north.destructible = false
					reactor_north.minable_flag = false
					reactor_north.temperature = reactor.temperature
				end

				local reactor_south = reactor.surface.create_entity({
					name = reactor.name,
					position = { x = reactor.position.x, y = reactor.position.y + (tower.is_player_tower and 0 or 0.5) },
					force = reactor.force,
				})

				if reactor_south and reactor_south.valid then
					reactor_south.destructible = false
					reactor_south.minable_flag = false
					reactor_south.temperature = reactor.temperature
				end

				tower.reactors[r] = {
					north = reactor_north,
					south = reactor_south,
				}

				-- reactor.destroy() -- This would freeze everything for a moment, so we'll remove it in the on_tick
				tower.reactor_to_clean_up = reactor
			end
		end
	end
end
