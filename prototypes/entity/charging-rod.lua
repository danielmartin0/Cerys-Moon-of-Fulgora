local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local merge = require("lib").merge

data:extend({
	{
		type = "accumulator",
		name = "cerys-charging-rod",
		flags = { "placeable-neutral", "player-creation" },
		minable = { mining_time = 0.1, result = "cerys-charging-rod" },
		max_health = 200,
		corpse = "lightning-rod-remnants",
		dying_explosion = "medium-electric-pole-explosion",
		resistances = {
			{
				type = "fire",
				percent = 90,
			},
			{
				type = "electric",
				percent = 100,
			},
		},
		collision_box = { { -0.65, -0.65 }, { 0.65, 0.65 } },
		selection_box = { { -0.9, -1 }, { 0.9, 1 } },
		damaged_trigger_effect = hit_effects.entity({ { -0.2, -2.2 }, { 0.2, 0.2 } }),
		drawing_box_vertical_extension = 4.3,
		open_sound = sounds.electric_network_open,
		close_sound = sounds.electric_network_close,
		factoriopedia_simulation = "nil",
		energy_source = {
			type = "electric",
			usage_priority = "tertiary",
			buffer_capacity = "12MJ",
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
			{ property = "magnetic-field", min = 120, max = 120 },
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
	},

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
