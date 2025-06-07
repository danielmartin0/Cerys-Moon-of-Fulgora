local common = require("common")
local hit_effects = require("__base__.prototypes.entity.hit-effects")

if settings.startup["cerys-player-constructable-radiative-towers"].value then
	data:extend({
		{
			type = "reactor",
			name = "cerys-radiative-tower",
			subgroup = "environmental-protection",
			order = "z-d[radiative-tower]",
			flags = { "placeable-neutral", "player-creation" },
			hidden = true,
			max_health = 500,
			dying_explosion = "heating-tower-explosion",
			collision_box = { { -2.25, -2.1 }, { 2.25, 2.1 } },
			selection_box = { { -2.5, -2.3 }, { 2.5, 2.3 } },
			damaged_trigger_effect = hit_effects.entity(),
			drawing_box_vertical_extension = 1.2,
			energy_source = {
				type = "burner",
				fuel_categories = { "chemical-or-radiative" },
				emissions_per_minute = { pollution = 5 },
				effectivity = 0.9,
				fuel_inventory_size = 2, -- not too high so you can see the fuel on belts
				burnt_inventory_size = 0,
			},
			consumption = "1300kW",
			heat_buffer = {
				max_temperature = 150,
				specific_heat = "70kJ",
				max_transfer = "1kW",
				minimum_glow_temperature = 0,
				heat_picture = {
					layers = {
						util.sprite_load(
							"__Cerys-Moon-of-Fulgora__/graphics/entity/player-radiative-tower/player-tower-glow",
							{
								scale = 0.42,
								blend_mode = "additive",
								tint = { 1, 1, 1 },
								draw_as_light = true,
							}
						),
						util.sprite_load(
							"__Cerys-Moon-of-Fulgora__/graphics/entity/player-radiative-tower/player-tower-glow",
							{
								scale = 0.42,
								blend_mode = "additive",
								tint = { 0.5, 0.4, 0.3, 0.2 },
							}
						),
					},
				},
			},
			neighbour_bonus = 0,
			picture = {
				layers = {
					util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/player-radiative-tower/player-tower", {
						scale = 0.42,
					}),
					util.sprite_load(
						"__Cerys-Moon-of-Fulgora__/graphics/entity/player-radiative-tower/player-tower-shadow",
						{
							scale = 0.42,
							draw_as_shadow = true,
						}
					),
				},
			},
			icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/player-radiative-tower.png",
			icon_size = 64,
			open_sound = { filename = "__base__/sound/open-close/metal-large-open.ogg", volume = 0.8 },
			close_sound = { filename = "__base__/sound/open-close/metal-large-close.ogg", volume = 0.8 },
			working_sound = {
				sound = { audible_distance_modifier = 0.9, filename = "__base__/sound/heat-pipe.ogg", volume = 0.85 },
				max_sounds_per_prototype = 3,
				fade_in_ticks = 4,
				fade_out_ticks = 20,
			},
			default_temperature_signal = { type = "virtual", name = "signal-T" },
			circuit_wire_max_distance = reactor_circuit_wire_max_distance,
			circuit_connector = circuit_connector_definitions.create_single(universal_connector_template, {
				variation = 7,
				main_offset = util.by_pixel(-37.5, 7.5),
				shadow_offset = util.by_pixel(-37.5, 7.5),
				show_shadow = true,
			}),
			minable = { mining_time = 0.2, result = "cerys-radiative-tower" },
			autoplace = {
				probability_expression = "0",
			},
			fast_replaceable_group = "radiative-tower",
			created_effect = {
				type = "direct",
				action_delivery = {
					type = "instant",
					source_effects = {
						type = "script",
						effect_id = "cerys-player-radiative-tower-created",
					},
				},
			},
			radius_visualisation_specification = {
				distance = 13,
				sprite = {
					filename = "__Cerys-Moon-of-Fulgora__/graphics/icons/area-of-effect.png",
					tint = { r = 1, g = 0, b = 0, a = 0.5 },
					height = 64,
					width = 64,
				},
			},
		},
	})
end

-- data:extend({
-- 	{
-- 		type = "beacon",
-- 		name = "cerys-radiative-tower-dummy", -- Secretly a beacon for the visualisation
-- 		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/player-radiative-tower.png",
-- 		icon_size = 64,
-- 		hidden = true,
-- 		minable = nil,
-- 		next_upgrade = nil,
-- 		flags = { "placeable-neutral", "player-creation" },
-- 		collision_box = data.raw["reactor"]["cerys-radiative-tower"].collision_box,
-- 		selection_box = data.raw["reactor"]["cerys-radiative-tower"].selection_box,
-- 		collision_mask = data.raw["reactor"]["cerys-radiative-tower"].collision_mask,
-- 		allowed_effects = {},
-- 		radius_visualisation_picture = {
-- 			filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
-- 			priority = "extra-high-no-scale",
-- 			width = 10,
-- 			height = 10,
-- 			tint = { 1, 0, 0 },
-- 		},
-- 		supply_area_distance = 9,
-- 		energy_usage = data.raw["reactor"]["cerys-radiative-tower"].consumption,
-- 		energy_source = {
-- 			type = "void",
-- 		},
-- 		distribution_effectivity = 0,
-- 		distribution_effectivity_bonus_per_quality_level = 0,
-- 		module_slots = 0,
-- 		created_effect = {
-- 			type = "direct",
-- 			action_delivery = {
-- 				type = "instant",
-- 				source_effects = {
-- 					type = "script",
-- 					effect_id = "cerys-player-radiative-tower-created",
-- 				},
-- 			},
-- 		},
-- 		base_picture = data.raw["reactor"]["cerys-radiative-tower"].picture,
-- 		drawing_box_vertical_extension = data.raw["reactor"]["cerys-radiative-tower"].drawing_box_vertical_extension,
-- 	},
-- })
