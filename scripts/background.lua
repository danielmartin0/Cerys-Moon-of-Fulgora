local Public = {}

local PLANET_OFFSET = { x = 50, y = -30 }
local PLANET_PARALLAX = 0.35

function Public.tick_1_update_background_renderings()
	for _, player in pairs(game.connected_players) do
		if not (player and player.valid) then
			storage.background_renderings[player.index] = nil
		else
			local on_cerys = player.surface.name == "cerys"
			local r = storage.background_renderings[player.index]

			if on_cerys then
				if not r then
					storage.background_renderings[player.index] = rendering.draw_sprite({
						sprite = "fulgora-background",
						target = { x = player.position.x + PLANET_OFFSET.x, y = player.position.y + PLANET_OFFSET.y },
						surface = player.surface,
						render_layer = "zero",
						players = { player.index },
					})

					r = storage.background_renderings[player.index]
				end

				if r.valid then
					r.target = {
						x = player.position.x * PLANET_PARALLAX + PLANET_OFFSET.x,
						y = player.position.y * PLANET_PARALLAX + PLANET_OFFSET.y,
					}
				else
					r.destroy()
					storage.background_renderings[player.index] = nil
				end
			elseif r then
				if r.valid then
					r.destroy()
				end
				storage.background_renderings[player.index] = nil
			end
		end
	end
end

return Public
