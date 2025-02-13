local common = require("common")

local Public = {}

local PLANET_OFFSET = { x = 50, y = -30 }
local PLANET_PARALLAX = 0.35

function Public.tick_1_update_background_renderings(surface)
	for _, player in pairs(game.connected_players) do
		if not (player and player.valid) then
			storage.background_renderings[player.index] = nil
		else
			local on_cerys = player.surface.name == "cerys"
			local r = storage.background_renderings[player.index]

			if on_cerys then
				if not r then
					local planet_stretch = common.get_cerys_surface_stretch_factor(surface) ^ 2

					storage.background_renderings[player.index] = rendering.draw_sprite({
						sprite = "fulgora-background",
						target = {
							x = player.position.x + PLANET_OFFSET.x,
							y = player.position.y + PLANET_OFFSET.y - (1 / planet_stretch - 1) * 40,
						},
						surface = player.surface,
						render_layer = "zero",
						players = { player.index },
						y_scale = 1 / planet_stretch,
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
