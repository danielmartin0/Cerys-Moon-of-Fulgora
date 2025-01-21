local merge = require("lib").merge

data:extend({
	merge(data.raw["lightning-attractor"]["lightning-rod"], {
		type = "accumulator",
		name = "cerys-charging-rod",
		minable = { mining_time = 0.1, result = "cerys-charging-rod" },
		collision_box = { { -0.65, -0.65 }, { 0.65, 0.65 } },
		selection_box = { { -0.9, -1 }, { 0.9, 1 } },
		-- range_elongation = 0,
		factoriopedia_simulation = "nil",
		energy_source = {
			type = "electric",
			usage_priority = "tertiary",
			buffer_capacity = "12MJ", -- from 5MJ
			input_flow_limit = "4MW",
			output_flow_limit = "500kW",
		},
		chargable_graphics = merge(data.raw["lightning-attractor"]["lightning-rod"].chargable_graphics, {
			discharge_animation = {
				layers = {
					util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/charging-rod/light", {
						priority = "high",
						blend_mode = "additive",
						scale = 0.375 * 0.85,
						frame_count = 24,
						draw_as_glow = true,
					}),
				},
			},
			charge_animation = {
				layers = {
					util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/charging-rod/light", {
						priority = "high",
						blend_mode = "additive",
						scale = 0.375 * 0.85,
						frame_count = 24,
						draw_as_glow = true,
					}),
				},
			},
			picture = {
				layers = {
					util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/charging-rod/tower", {
						priority = "high",
						scale = 0.27 * 0.85,
					}),
					util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/charging-rod/shadow", {
						priority = "high",
						draw_as_shadow = true,
						scale = 0.27 * 0.85,
					}),
				},
			},
			charge_animation_is_looped = true,
		}),
		surface_conditions = {
			{ property = "magnetic-field", min = 120, max = 120 }, -- Don't allow scripts to run on other surfaces
		},
		working_sound = {
			main_sounds = {
				{
					sound = {
						filename = "__base__/sound/accumulator-working.ogg",
						volume = 1,
						speed = 0.8,
					},
					match_volume_to_activity = true,
					fade_in_ticks = 4,
					fade_out_ticks = 8,
				},
				{
					sound = {
						filename = "__base__/sound/accumulator-discharging.ogg",
						volume = 1,
						speed = 0.8,
					},
					match_volume_to_activity = true,
					fade_in_ticks = 4,
					fade_out_ticks = 8,
				},
			},
		},
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/charging-rod.png",
	}),

	{
		type = "simple-entity",
		name = "cerys-charging-rod-animation-blue",
		hidden = true,
		random_animation_offset = true,
		animations = {
			layers = {
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/charging-rod/flowinglight_b.png",
					priority = "extra-high-no-scale",
					width = 440,
					height = 1000,
					frame_count = 27,
					line_length = 9,
					draw_as_glow = true,
					blend_mode = "additive",
					scale = 0.27 * 0.85,
					shift = util.by_pixel(0, -81 * 0.85 - 32),
					animation_speed = 0.08,
				},
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/charging-rod/light-b.png",
					priority = "extra-high-no-scale",
					width = 440,
					height = 1000,
					repeat_count = 27,
					draw_as_glow = true,
					blend_mode = "additive",
					scale = 0.27 * 0.85,
					shift = util.by_pixel(0, -81 * 0.85 - 32),
					animation_speed = 0.08,
				},
			},
		},
	},
	{
		type = "simple-entity",
		name = "cerys-charging-rod-animation-red",
		hidden = true,
		random_animation_offset = true,
		animations = {
			layers = {
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/charging-rod/flowinglight_r.png",
					priority = "extra-high-no-scale",
					width = 440,
					height = 1000,
					frame_count = 27,
					line_length = 9,
					draw_as_glow = true,
					blend_mode = "additive",
					scale = 0.27 * 0.85,
					shift = util.by_pixel(0, -81 * 0.85 - 32),
					animation_speed = 0.13,
				},
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/charging-rod/light-r.png",
					priority = "extra-high-no-scale",
					width = 440,
					height = 1000,
					repeat_count = 27,
					draw_as_glow = true,
					blend_mode = "additive",
					scale = 0.27 * 0.85,
					shift = util.by_pixel(0, -81 * 0.85 - 32),
					animation_speed = 0.13,
				},
			},
		},
	},
})
