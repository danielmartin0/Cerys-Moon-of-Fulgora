local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local merge = require("lib").merge
local common = require("common")

data:extend({
	{
		type = "assembling-machine",
		name = "cerys-solar-ghost-maker",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/charging-rod.png",
		flags = { "placeable-neutral", "placeable-player", "player-creation" },
		minable = { mining_time = 0.2, result = "cerys-solar-ghost-maker" },
		max_health = 80,
		corpse = "lightning-rod-remnants",
		dying_explosion = "medium-electric-pole-explosion",
		-- icon_draw_specification = { shift = { 0, -0.3 } },
		collision_box = { { -0.65, -0.65 }, { 0.65, 0.65 } },
		selection_box = { { -0.9, -1 }, { 0.9, 1 } },
		damaged_trigger_effect = hit_effects.entity({ { -0.2, -2.2 }, { 0.2, 0.2 } }),
		fast_replaceable_group = "cerys-solar-ghost-maker",
		graphics_set = {
			animation = {
				layers = {
					util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/charging-rod/tower", {
						priority = "high",
						scale = 0.27 * 0.85,
						line_length = 1,
						repeat_count = 1,
					}),
					util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/charging-rod/shadow", {
						priority = "high",
						draw_as_shadow = true,
						scale = 0.27 * 0.85,
						line_length = 1,
						repeat_count = 1,
					}),
				},
			},
		},
		crafting_categories = { "cerys-make-solar-wind-ghosts" },
		fixed_recipe = "cerys-make-solar-wind-ghosts",
		crafting_speed = 1,
		energy_source = {
			type = "void",
		},
		energy_usage = "10kW",
		module_slots = 1,
		open_sound = sounds.inserter_open,
		close_sound = sounds.inserter_close,
		allowed_effects = { "speed" },
		effect_receiver = { uses_module_effects = true, uses_beacon_effects = true, uses_surface_effects = false },
		surface_conditions = {
			common.AMBIENT_RADIATION_MIN,
		},
		circuit_connector = circuit_connector_definitions.create_vector(universal_connector_template, {
			{
				variation = 24,
				main_offset = util.by_pixel(-5.125, -29),
				shadow_offset = util.by_pixel(-5.125, -29),
				show_shadow = true,
			},
			{
				variation = 24,
				main_offset = util.by_pixel(-5.125, -29),
				shadow_offset = util.by_pixel(-5.125, -29),
				show_shadow = true,
			},
			{
				variation = 24,
				main_offset = util.by_pixel(-5.125, -29),
				shadow_offset = util.by_pixel(-5.125, -29),
				show_shadow = true,
			},
			{
				variation = 24,
				main_offset = util.by_pixel(-5.125, -29),
				shadow_offset = util.by_pixel(-5.125, -29),
				show_shadow = true,
			},
		}),
		circuit_wire_max_distance = default_circuit_wire_max_distance,
	},
})
