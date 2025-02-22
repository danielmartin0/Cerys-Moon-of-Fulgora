local common = require("common")

local Public = {}

-- local DAY_LENGTH = 0.5 * 60 * 60
local DAY_LENGTH = common.DAY_LENGTH_MINUTES * 60 * 60

function Public.tick_3_update_lights()
	if not storage.cerys then
		return
	end

	local surface = game.surfaces["cerys"]

	if not (surface and surface.valid) then
		return
	end

	if settings.global["cerys-dynamic-lighting"].value then
		surface.brightness_visual_weights = { 1000000, 1000000, 1000000 }
		surface.min_brightness = 0
	else
		surface.brightness_visual_weights = { 0.2, 0.23, 0.21 }
		surface.min_brightness = 0.2
		surface.solar_power_multiplier = 1
		return
	end

	local R = common.get_cerys_semimajor_axis(surface)
	local box_over_circle = common.SOLAR_IMAGE_SIZE / common.SOLAR_IMAGE_CIRCLE_SIZE

	storage.cerys.light = storage.cerys.light or {}
	storage.cerys.solar_panels = storage.cerys.solar_panels or {}

	local elapsed_ticks = game.tick - (storage.cerys.creation_tick or 0)

	local daytime = (elapsed_ticks / DAY_LENGTH) % 1

	local adjusted_daytime
	if daytime < 5 / 10 then
		adjusted_daytime = 0
	elseif daytime < 7 / 10 then
		adjusted_daytime = 0.5 * (daytime - 5 / 10) / (2 / 10)
	elseif daytime < 8 / 10 then
		adjusted_daytime = 0.5
	else
		adjusted_daytime = 0.5 + 0.5 * (daytime - 8 / 10) / (2 / 10)
	end
	-- local adjusted_daytime = daytime

	local phase = (adjusted_daytime + 0.25) * 2 * math.pi

	-- local naive_x = (1 - (phase % math.pi) / (math.pi / 2))
	local naive_x = (1 - math.sin(phase % math.pi)) * (((phase % math.pi) < (math.pi / 2)) and 1 or -1)

	local regularized_naive_x = math.max(math.min(naive_x, 0.9), -0.9)

	-- local circle_scaling_effect = 1
	local circle_scaling_effect = 1 / (1 - math.abs(regularized_naive_x))

	-- local elbow_room_factor = 1
	local elbow_room_factor = 1 + 0.4 * math.sin(phase) ^ 4

	local light_x = R * regularized_naive_x * circle_scaling_effect + R * naive_x
	local light_radius = (R * circle_scaling_effect) * elbow_room_factor

	local light_1 = storage.cerys.light.rendering_1
	local light_2 = storage.cerys.light.rendering_2

	local light_scale = light_radius * box_over_circle / 64
	local light_position = { x = light_x, y = 0 }

	local is_white_circle = (phase % (2 * math.pi)) < math.pi

	if is_white_circle then
		if light_2 then
			light_2.destroy()
			storage.cerys.light.rendering_2 = nil
		end

		if light_1 and light_1.valid then
			light_1.target = light_position
			light_1.x_scale = light_scale
			light_1.y_scale = light_scale
		else
			light_1 = rendering.draw_sprite({
				sprite = "cerys-solar-light",
				x_scale = light_scale,
				y_scale = light_scale,
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
			light_2.x_scale = light_scale
			light_2.y_scale = light_scale
		else
			light_2 = rendering.draw_sprite({
				sprite = "cerys-solar-light-inverted",
				x_scale = light_scale,
				y_scale = light_scale,
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

	local total_brightness = 0
	local panel_count = 0

	local ideal_circle_scaling_effect = 1 / (1 - math.abs(naive_x))
	local ideal_light_x = R * naive_x * ideal_circle_scaling_effect + R * naive_x
	local ideal_light_radius = (R * ideal_circle_scaling_effect) * elbow_room_factor

	for unit_number, panel in pairs(storage.cerys.solar_panels) do
		if panel.entity and panel.entity.valid then
			-- if panel.entity.is_connected_to_electric_network() then
			if naive_x == 1 then
				total_brightness = total_brightness + 0.5
				panel_count = panel_count + 1
			else
				local relative_x = (panel.entity.position.x - ideal_light_x) / ideal_light_radius
				local relative_y = panel.entity.position.y / ideal_light_radius

				local d = (relative_x * relative_x + relative_y * relative_y) ^ (1 / 2)

				local d1 = 0.8
				local d2 = 1.2

				local efficiency
				if d <= d1 then
					if is_white_circle then
						efficiency = 1
					else
						efficiency = 0
					end
				elseif d <= d2 then
					if is_white_circle then
						efficiency = (d2 - d) / (d2 - d1)
					else
						efficiency = (d - d1) / (d2 - d1)
					end
				else
					if is_white_circle then
						efficiency = 0
					else
						efficiency = 1
					end
				end

				total_brightness = total_brightness + efficiency
				panel_count = panel_count + 1
			end
			-- end
		else
			storage.cerys.solar_panels[unit_number] = nil
		end
	end

	local desired_solar_power_multiplier
	if panel_count > 0 then
		desired_solar_power_multiplier = total_brightness / panel_count
	else
		desired_solar_power_multiplier = 1
	end

	local desired_solar_panel_bar_fullness = desired_solar_power_multiplier

	local game_daytime = 0.45 - 0.1995 * desired_solar_panel_bar_fullness -- Any closer to 0.25 and the engine complains

	if desired_solar_panel_bar_fullness == 1 then
		game_daytime = game_daytime - 1 / 3000 -- Somehow this helps avoid an oscillating value in the UI
	end

	surface.daytime = game_daytime
	local vanilla_solar_power_multiplier = Public.vanilla_solar_power_multiplier(game_daytime)

	if desired_solar_power_multiplier == 0 or desired_solar_power_multiplier == 1 then
		surface.solar_power_multiplier = 1
	else
		surface.solar_power_multiplier = desired_solar_power_multiplier / vanilla_solar_power_multiplier
	end
end

function Public.vanilla_solar_power_multiplier(daytime)
	if daytime < 0.25 or daytime > 0.75 then
		return 1
	elseif daytime < 0.45 then
		return 1 - (daytime - 0.25) / 0.2
	elseif daytime < 0.55 then
		return 0
	else
		return (daytime - 0.55) / 0.2
	end
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
