local common = require("common")
local lib = require("lib")

local Public = {}

local PLANET_OFFSET = { x = 50, y = -30 }
local PLANET_PARALLAX = 0.35

function Public.tick_1_update_background_renderings(surface)
	if game.is_multiplayer() and settings.global["cerys-disable-parallax-in-multiplayer"].value then
		if not storage.parallax_disabled then
			Public.reset_background_rendering_positions()
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

			if on_cerys and helpers.is_valid_sprite_path("cerys-fulgora-background") then
				local stretch = lib.get_cerys_surface_stretch_factor(surface)
				local planet_stretch = stretch
				local extra_y_offset = -5 * (stretch - 1)

				local center_of_screen = {
					x = player.position.x,
					y = player.position.y + player.flight_height,
				}

				local target_position = {
					x = center_of_screen.x * PLANET_PARALLAX + PLANET_OFFSET.x,
					y = center_of_screen.y * PLANET_PARALLAX + PLANET_OFFSET.y + extra_y_offset,
				}

				if not r then
					storage.background_renderings[player.index] = rendering.draw_sprite({
						sprite = "cerys-fulgora-background",
						target = target_position,
						surface = player.surface,
						render_layer = "zero",
						players = { player.index },
						x_scale = common.DEFAULT_FULGORA_IMAGE_SIZE
							/ prototypes.mod_data["Cerys"].data.fulgora_image_size,
						y_scale = common.DEFAULT_FULGORA_IMAGE_SIZE
							/ prototypes.mod_data["Cerys"].data.fulgora_image_size
							/ planet_stretch,
					})

					r = storage.background_renderings[player.index]
				end

				if r.valid then
					r.target = target_position
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

function Public.reset_background_rendering_positions()
	local surface = lib.generated_cerys_surface()
	if not surface then
		return
	end

	local stretch = lib.get_cerys_surface_stretch_factor(surface)
	local planet_stretch = stretch

	for _, player in pairs(game.players) do
		local r = storage.background_renderings[player.index]

		if r and r.valid then
			r.target = {
				x = PLANET_OFFSET.x,
				y = PLANET_OFFSET.y,
			}
			r.x_scale = common.DEFAULT_FULGORA_IMAGE_SIZE / prototypes.mod_data["Cerys"].data.fulgora_image_size
			r.y_scale = common.DEFAULT_FULGORA_IMAGE_SIZE
				/ prototypes.mod_data["Cerys"].data.fulgora_image_size
				/ planet_stretch
		end
	end
end

return Public
