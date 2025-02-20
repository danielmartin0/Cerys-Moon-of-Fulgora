local common = require("common")

local Public = {}

local DAY_LENGTH = 30 * 30

function Public.tick_3_update_light_position()
	if not storage.cerys then
		return
	end

	local surface = game.surfaces["cerys"]

	if not (surface and surface.valid) then
		return
	end

	surface.daytime = 0.5

	storage.cerys.light = storage.cerys.light or {}

	local light = storage.cerys.light.rendering
	if not (light and light.valid) then
		light = rendering.draw_light({
			sprite = "utility/light_medium",
			scale = common.CERYS_RADIUS,
			intensity = 1,
			color = { 1, 1, 1 },
			target = { x = 0, y = 0 },
			surface = surface,
			minimum_darkness = 0,
		})

		storage.cerys.light = {
			rendering = light,
			creation_tick = game.tick,
		}
	end

	local elapsed_ticks = game.tick - storage.cerys.light.creation_tick
	local phase = 2 * math.pi * ((elapsed_ticks / DAY_LENGTH) % 0.5)

	light.target = { x = 2 * common.CERYS_RADIUS * math.cos(phase), y = 0 }
end

return Public
