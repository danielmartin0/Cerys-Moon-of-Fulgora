local common = require("common")

local Public = {}

-- local DAY_LENGTH = 0.5 * 60 * 60
local DAY_LENGTH = common.DAY_LENGTH_MINUTES * 60 * 60

function Public.tick_update_lights()
	if not storage.cerys then
		return
	end

	local surface = game.surfaces["cerys"]

	if not (surface and surface.valid) then
		return
	end

	storage.cerys.light = storage.cerys.light or {}

	local elapsed_ticks = game.tick - (storage.cerys.first_visit_tick or 0)
	local daytime = (elapsed_ticks / DAY_LENGTH) % 1

	if settings.global["cerys-dynamic-lighting"].value and elapsed_ticks < 10 * 60 then -- Avoid cargo pod graphical issue on first visit
		surface.brightness_visual_weights = { 0.22, 0.23, 0.22 }
		surface.min_brightness = 0.2
		surface.solar_power_multiplier = 1
		surface.daytime = 0
		storage.cerys.lighting_last_seen = nil
		return
	end

	if settings.global["cerys-dynamic-lighting"].value then
		if storage.cerys.lighting_last_seen ~= "dynamic" then
			surface.brightness_visual_weights = { 1000000, 1000000, 1000000 }
			surface.min_brightness = 0
			storage.cerys.lighting_last_seen = "dynamic"
		end
	else
		if storage.cerys.lighting_last_seen ~= "static" then
			surface.brightness_visual_weights = { 0.22, 0.23, 0.22 }
			surface.min_brightness = 0.2
			surface.solar_power_multiplier = 1
			if storage.cerys.light.rendering_1 then
				storage.cerys.light.rendering_1.destroy()
				storage.cerys.light.rendering_1 = nil
			end
			if storage.cerys.light.rendering_2 then
				storage.cerys.light.rendering_2.destroy()
				storage.cerys.light.rendering_2 = nil
			end
			if storage.cerys.light.rendering_3 then
				storage.cerys.light.rendering_3.destroy()
				storage.cerys.light.rendering_3 = nil
			end
			storage.cerys.lighting_last_seen = "static"
		end
		surface.daytime = daytime
		return
	end

	local R = common.get_cerys_semimajor_axis(surface)
	local box_over_circle = common.SOLAR_IMAGE_SIZE / common.SOLAR_IMAGE_CIRCLE_SIZE

	--== Graphics ==--
	-- Commented lines are typically less polished versions.

	local stretched_daytime
	if daytime < 46 / 100 then
		stretched_daytime = 0
	elseif daytime < 70 / 100 then
		stretched_daytime = 0.5 * (daytime - 46 / 100) / (24 / 100)
	elseif daytime < 76 / 100 then
		stretched_daytime = 0.5
	else
		stretched_daytime = 0.5 + 0.5 * (daytime - 76 / 100) / (24 / 100)
	end
	-- local stretched_daytime = daytime

	local phase = (stretched_daytime + 0.25) * 2 * math.pi -- puts midday at phase = pi/2

	local bounded_x = (1 - math.sin(phase % math.pi)) * (((phase % math.pi) < (math.pi / 2)) and 1 or -1)
	-- local bounded_x = (1 - (phase % math.pi) / (math.pi / 2)) -- for testing

	local regularized_bounded_x = math.max(math.min(bounded_x, 0.83), -0.83)
	-- local regularized_bounded_x = math.tanh(bounded_x) * 0.9 / math.tanh(1) -- Changing size whilst it's huge causes large moving artifacts

	local circle_scaling_effect = 1 / (1 - math.abs(regularized_bounded_x))
	-- local circle_scaling_effect = 1 -- for testing

	-- Helps avoid a) the circle being a snug fit, b) graphical overflow of the negative circle's image boundary
	local elbow_room_factor = 1 + 0.4 * math.sin(phase) ^ 4
	-- local elbow_room_factor = 1 -- for testing

	local light_x = R * regularized_bounded_x * circle_scaling_effect + R * bounded_x
	local light_radius = (R * circle_scaling_effect) * elbow_room_factor

	local is_white_circle = (phase % (2 * math.pi)) < math.pi
	local use_rectangle = math.abs(bounded_x) > 0.83

	local light_1 = storage.cerys.light.rendering_1
	local light_2 = storage.cerys.light.rendering_2

	if use_rectangle then
		light_x = R * math.cos((phase + math.pi / 2) % math.pi) * 0.7 -- constant factor is not an exact science
	end
	local light_position = { x = light_x, y = 0 }
	local light_scale = light_radius * box_over_circle / 64
	if use_rectangle then
		light_scale = light_scale * 0.65 -- not an exact science
	end
	local rectangle_sprite = ((phase % (2 * math.pi)) > math.pi / 2 and (phase % (2 * math.pi)) < 3 * math.pi / 2)
			and "cerys-solar-light-rectangle-inverted"
		or "cerys-solar-light-rectangle"

	if is_white_circle then
		if light_2 then
			light_2.destroy()
			storage.cerys.light.rendering_2 = nil

			-- if storage.cerys.light.flag_rendering_2 then
			-- 	storage.cerys.light.flag_rendering_2.destroy()
			-- 	storage.cerys.light.flag_rendering_2 = nil
			-- end
		end

		if light_1 and light_1.valid then
			light_1.target = light_position
			light_1.x_scale = light_scale
			light_1.y_scale = light_scale
			light_1.sprite = use_rectangle and rectangle_sprite or "cerys-solar-light"

			-- if storage.cerys.light.flag_rendering_1 then
			-- 	storage.cerys.light.flag_rendering_1.target = light_position
			-- end
		else
			light_1 = rendering.draw_sprite({
				sprite = use_rectangle and rectangle_sprite or "cerys-solar-light",
				x_scale = light_scale,
				y_scale = light_scale,
				target = light_position,
				surface = surface,
			})

			storage.cerys.light.rendering_1 = light_1

			-- storage.cerys.light.flag_rendering_1 = rendering.draw_sprite({
			-- 	sprite = "utility/spawn_flag",
			-- 	target = light_position,
			-- 	x_scale = 3,
			-- 	y_scale = 3,
			-- 	surface = surface,
			-- })
		end
	else
		if light_1 then
			light_1.destroy()
			storage.cerys.light.rendering_1 = nil

			-- if storage.cerys.light.flag_rendering_1 then
			-- 	storage.cerys.light.flag_rendering_1.destroy()
			-- 	storage.cerys.light.flag_rendering_1 = nil
			-- end
		end

		if light_2 and light_2.valid then
			light_2.target = light_position
			light_2.x_scale = light_scale
			light_2.y_scale = light_scale
			light_2.sprite = use_rectangle and rectangle_sprite or "cerys-solar-light-inverted"

			-- if storage.cerys.light.flag_rendering_2 then
			-- 	storage.cerys.light.flag_rendering_2.target = light_position
			-- end
		else
			light_2 = rendering.draw_sprite({
				sprite = use_rectangle and rectangle_sprite or "cerys-solar-light-inverted",
				x_scale = light_scale,
				y_scale = light_scale,
				target = light_position,
				surface = surface,
			})

			storage.cerys.light.rendering_2 = light_2

			-- storage.cerys.light.flag_rendering_2 = rendering.draw_sprite({
			-- 	sprite = "utility/spawn_flag",
			-- 	target = light_position,
			-- 	x_scale = 3,
			-- 	y_scale = 3,
			-- 	surface = surface,
			-- })
		end
	end

	local light_3 = storage.cerys.light.rendering_3
	if not (light_3 and light_3.valid) then
		storage.cerys.light.rendering_3 = rendering.draw_light({
			sprite = "cerys-solar-light",
			scale = 2 * R,
			intensity = 0.47,
			color = { 1, 1, 1 },
			target = { x = 0, y = 0 },
			surface = surface,
			minimum_darkness = 0,
		})
	end

	--== Solar panels ==--

	storage.cerys.solar_panels = storage.cerys.solar_panels or {}

	local total_brightness = 0
	local panel_count = 0

	for unit_number, panel in pairs(storage.cerys.solar_panels) do
		if panel.entity and panel.entity.valid then
			-- if panel.entity.is_connected_to_electric_network() then -- doesn't work?
			local x = panel.entity.position.x
			local y = panel.entity.position.y

			local d = math.sqrt(x ^ 2 + y ^ 2)
			if d > R * 0.99 then
				x = x / d * R * 0.99
				y = y / d * R * 0.99
			end

			local panel_longitude_radians = math.atan2(x, math.sqrt(R ^ 2 - x ^ 2 - y ^ 2))
			local adjusted_longitude = 2 * panel_longitude_radians / 3 -- This multiplication accounts for a 2d–3d perspective issue.

			local angle = (phase - math.pi / 2 + adjusted_longitude) % (2 * math.pi)

			local penumbra_size = math.pi / 14 -- must be <= math.pi / 4

			local efficiency
			if angle < math.pi / 2 - penumbra_size then
				efficiency = 1
			elseif angle < math.pi / 2 + penumbra_size then
				efficiency = 1 - (angle - (math.pi / 2 - penumbra_size)) / (2 * penumbra_size)
			elseif angle < 3 * math.pi / 2 - penumbra_size then
				efficiency = 0
			elseif angle < 3 * math.pi / 2 + penumbra_size then
				efficiency = (angle - (3 * math.pi / 2 - penumbra_size)) / (2 * penumbra_size)
			else
				efficiency = 1
			end

			total_brightness = total_brightness + efficiency
			panel_count = panel_count + 1
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

	local engine_daytime = 0.45 - 0.1995 * desired_solar_panel_bar_fullness -- Any closer to 0.25 and the engine complains

	if desired_solar_panel_bar_fullness == 1 then
		engine_daytime = engine_daytime - 1 / 3000 -- Somehow this helps avoid an oscillating value in the UI
	end

	surface.daytime = engine_daytime
	local vanilla_solar_power_multiplier = Public.vanilla_solar_power_multiplier(engine_daytime)

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
