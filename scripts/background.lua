local common = require("common")

local Public = {}

local PLANET_OFFSET = { x = 50, y = -30 }
local PLANET_PARALLAX = 0.35

function Public.tick_1_update_background_renderings(surface)
	if game.is_multiplayer() and settings.global["cerys-disable-parallax-in-multiplayer"].value then
		if not storage.parallax_disabled then
			Public.reset_background_renderings()
			storage.parallax_disabled = true
		end

		return
	else
		storage.parallax_disabled = false
	end

	for _, player in pairs(game.connected_players) do
		if not (player and player.valid) then
			storage.background_renderings[player.index] = nil
		else
			local on_cerys = player.surface.name == "cerys"
			local r = storage.background_renderings[player.index]

			if on_cerys then
				local stretch = common.get_cerys_surface_stretch_factor(surface)
				local planet_stretch = stretch
				local extra_y_offset = -5 * (stretch - 1)

				if not r then
					storage.background_renderings[player.index] = rendering.draw_sprite({
						sprite = "fulgora-background",
						target = {
							x = player.position.x + PLANET_OFFSET.x,
							y = player.position.y + PLANET_OFFSET.y + extra_y_offset,
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
						y = player.position.y * PLANET_PARALLAX + PLANET_OFFSET.y + extra_y_offset,
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

function Public.reset_background_renderings()
	local surface = game.surfaces["cerys"]

	if not (surface and surface.valid) then
		return
	end

	for _, player in pairs(game.players) do
		local r = storage.background_renderings[player.index]

		if r and r.valid then
			r.target = {
				x = PLANET_OFFSET.x,
				y = PLANET_OFFSET.y,
			}
		end
	end
end

return Public
