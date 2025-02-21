local common = require("common")

local Public = {}

local DAY_LENGTH = common.DAY_LENGTH_MINUTES * 60 * 60

function Public.tick_3_update_light_position()
	if not storage.cerys then
		return
	end

	local surface = game.surfaces["cerys"]

	if not (surface and surface.valid) then
		return
	end

	storage.cerys.light = storage.cerys.light or {}
	storage.cerys.solar_panels = storage.cerys.solar_panels or {}

	local elapsed_ticks = game.tick - (storage.cerys.creation_tick or 0)
	local modulo_ticks = elapsed_ticks % DAY_LENGTH
	local daytime
	if modulo_ticks < DAY_LENGTH * 5 / 10 then
		daytime = 0
	elseif modulo_ticks < DAY_LENGTH * 7 / 10 then
		daytime = 0.5 * (modulo_ticks - DAY_LENGTH * 5 / 10) / (DAY_LENGTH * 2 / 10)
	elseif modulo_ticks < DAY_LENGTH * 8 / 10 then
		daytime = 0.5
	else
		daytime = 0.5 + 0.5 * (modulo_ticks - DAY_LENGTH * 8 / 10) / (DAY_LENGTH * 2 / 10)
	end

	local phase = (daytime + 0.25) * 2 * math.pi

	local rescaled_phase = (1 - math.sin(phase % math.pi)) * ((phase % math.pi) < math.pi / 2 and 1 or -1)

	local R = common.get_cerys_semimajor_axis(surface)
	local box_over_circle = 4096 / 2400 -- From the original svg

	-- These factors make it different to the simple transit of a circle:
	local regularized_rescaled_phase = math.max(math.min(rescaled_phase, 0.92), -0.92)
	local circle_scaling_effect = 1 / (1 - math.abs(regularized_rescaled_phase))
	local elbow_room_factor = 1 + 0.5 * math.sin(phase) ^ 4 -- So the circle isn't a perfectly snug fit

	local light_position = { x = R * regularized_rescaled_phase * circle_scaling_effect + R * rescaled_phase, y = 0 }

	local scale_1 = box_over_circle / 64 * (R * circle_scaling_effect) * elbow_room_factor
	local scale_2 = box_over_circle / 64 * (R * circle_scaling_effect) * elbow_room_factor

	local light_1 = storage.cerys.light.rendering_1
	local light_2 = storage.cerys.light.rendering_2

	if (phase % (2 * math.pi)) < math.pi then
		if light_2 then
			light_2.destroy()
			storage.cerys.light.rendering_2 = nil
		end

		if light_1 and light_1.valid then
			light_1.target = light_position
			light_1.x_scale = scale_1
			light_1.y_scale = scale_1 * 1.05
		else
			light_1 = rendering.draw_sprite({
				sprite = "cerys-solar-light",
				x_scale = scale_1,
				y_scale = scale_1,
				target = light_position,
				surface = surface,
			})

			storage.cerys.light.rendering_1 = light_1
		end
	else
		if light_1 then
			light_1.destroy()
			storage.cerys.light.rendering_1 = nil
		end

		if light_2 and light_2.valid then
			light_2.target = light_position
			light_2.x_scale = scale_2
			light_2.y_scale = scale_2 * 1.05
		else
			light_2 = rendering.draw_sprite({
				sprite = "cerys-solar-light-inverted",
				x_scale = scale_2,
				y_scale = scale_2,
				target = light_position,
				surface = surface,
			})

			storage.cerys.light.rendering_2 = light_2
		end
	end

	local light_3 = storage.cerys.light.rendering_3
	if not (light_3 and light_3.valid) then
		storage.cerys.light.rendering_3 = rendering.draw_light({
			sprite = "cerys-solar-light",
			scale = 2 * R,
			intensity = 0.25,
			color = { 1, 1, 1 },
			target = { x = 0, y = 0 },
			surface = surface,
			minimum_darkness = 0,
		})
	end

	-- local total_brightness = 0
	-- local panel_count = 0

	-- for unit_number, panel in pairs(storage.cerys.solar_panels) do
	-- 	if panel.entity.valid then
	-- 		local dx = panel.entity.position.x - light_position.x
	-- 		local dy = panel.entity.position.y - light_position.y
	-- 		local d = (dx * dx + dy * dy) ^ (1 / 2)

	-- 		local relative_d = d / R

	-- 		local min_d = 0.2
	-- 		local max_d = 1.1

	-- 		local efficiency
	-- 		if relative_d <= min_d then
	-- 			efficiency = 1
	-- 		elseif relative_d <= max_d then
	-- 			efficiency = (max_d - relative_d) / (max_d - min_d)
	-- 		else
	-- 			efficiency = 0
	-- 		end

	-- 		log("distance: " .. relative_d .. " efficiency: " .. efficiency)

	-- 		total_brightness = total_brightness + efficiency
	-- 		panel_count = panel_count + 1
	-- 	else
	-- 		storage.cerys.solar_panels[unit_number] = nil
	-- 	end
	-- end

	-- local solar_power_multiplier = panel_count > 0 and (total_brightness / panel_count) or 1
	-- surface.solar_power_multiplier = math.ceil(solar_power_multiplier * 50) / 50

	surface.daytime = daytime

	surface.min_brightness = common.MIN_BRIGHTNESS
	-- surface.daytime = 0
	-- surface.daytime = 0.46 - 0.2 * solar_power_multiplier
	surface.brightness_visual_weights = common.BRIGHTNESS_VISUAL_WEIGHTS
end

function Public.register_solar_panel(entity)
	if not storage.cerys then
		return
	end
	storage.cerys.solar_panels = storage.cerys.solar_panels or {}
	storage.cerys.solar_panels[entity.unit_number] = {
		entity = entity,
	}
end

return Public
