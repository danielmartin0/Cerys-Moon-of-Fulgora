local merge = require("lib").merge
local sounds = require("__base__.prototypes.entity.sounds")

local nuke_shockwave_starting_speed_deviation = 0.125

data:extend({

	{
		type = "projectile",
		name = "cerys-hydrogen-bomb-rocket",
		flags = { "not-on-map" },
		hidden = true,
		acceleration = 0.005,
		turn_speed = 0.003,
		turning_speed_increases_exponentially_with_projectile_speed = true,
		action = {
			type = "direct",
			action_delivery = {
				{
					type = "instant",
					target_effects = {
						{
							type = "destroy-cliffs",
							radius = 27,
							explosion_at_trigger = "explosion",
						},
						{
							type = "create-entity",
							check_buildability = true,
							-- This entity can have surface conditions
							entity_name = "nuke-effects-nauvis",
						},
						{
							type = "create-entity",
							entity_name = "thermonuclear-explosion",
						},
						{
							type = "camera-effect",
							duration = 60,
							ease_in_duration = 5,
							ease_out_duration = 60,
							delay = 0,
							strength = 10,
							full_strength_max_distance = 200,
							max_distance = 1200,
						},
						{
							type = "play-sound",
							sound = sounds.nuclear_explosion(1.5),
							play_on_target_position = false,
							-- min_distance = 200,
							max_distance = 3000,
						},
						{
							type = "play-sound",
							sound = sounds.nuclear_explosion_aftershock(0.5),
							play_on_target_position = false,
							-- min_distance = 200,
							max_distance = 1000,
						},
						{
							type = "damage",
							damage = { amount = 1200, type = "explosion" },
						},
						{
							type = "damage",
							damage = { amount = 400, type = "physical" },
						},
						{
							type = "damage",
							damage = { amount = 400, type = "fire" },
						},
						{
							type = "create-entity",
							entity_name = "huge-scorchmark",
							offsets = { { 0, -0.5 } },
							check_buildability = true,
						},
						{
							type = "invoke-tile-trigger",
							repeat_count = 1,
						},
						{
							type = "destroy-decoratives",
							include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
							include_decals = true,
							invoke_decorative_trigger = true,
							decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
							radius = 28, -- large radius for demostrative purposes
						},
						{
							type = "create-decorative",
							decorative = "nuclear-ground-patch",
							spawn_min_radius = 21,
							spawn_max_radius = 24,
							spawn_min = 90,
							spawn_max = 120,
							apply_projection = true,
							spread_evenly = true,
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 3000,
								radius = 10,
								action_delivery = {
									type = "projectile",
									projectile = "atomic-bomb-ground-zero-projectile",
									starting_speed = 2 * 0.6 * 0.8,
									starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
								},
							},
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 3000,
								radius = 110,
								action_delivery = {
									type = "projectile",
									projectile = "hydrogen-bomb-wave",
									starting_speed = 2 * 0.5 * 0.7,
									starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
								},
							},
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								show_in_tooltip = false,
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 5000,
								radius = 78,
								action_delivery = {
									type = "projectile",
									projectile = "atomic-bomb-wave-spawns-cluster-nuke-explosion",
									starting_speed = 2 * 0.5 * 0.7,
									starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
								},
							},
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								show_in_tooltip = false,
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 3500,
								radius = 12,
								action_delivery = {
									type = "projectile",
									projectile = "atomic-bomb-wave-spawns-fire-smoke-explosion",
									starting_speed = 2 * 0.5 * 0.65,
									starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
								},
							},
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								show_in_tooltip = false,
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 5000,
								radius = 24,
								action_delivery = {
									type = "projectile",
									projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
									starting_speed = 2 * 0.5 * 0.65,
									starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
								},
							},
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								show_in_tooltip = false,
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 1500,
								radius = 78,
								action_delivery = {
									type = "projectile",
									projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
									starting_speed = 2 * 0.5 * 0.65,
									starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
								},
							},
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								show_in_tooltip = false,
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 30,
								radius = 24,
								action_delivery = {
									type = "instant",
									target_effects = {
										{
											type = "create-entity",
											entity_name = "nuclear-smouldering-smoke-source",
											tile_collision_mask = {
												layers = {
													water_tile = true,
												},
											},
										},
									},
								},
							},
						},
					},
				},
				{
					type = "delayed",
					delayed_trigger = "thermonuclear-explosion-fires",
				},
			},
		},
		--light = {intensity = 0.8, size = 15},
		animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({ 0.3, 1, 0.3 }),
		shadow = require("__base__.prototypes.entity.rocket-projectile-pictures").shadow,
		smoke = require("__base__.prototypes.entity.rocket-projectile-pictures").smoke,
	},

	{
		type = "projectile",
		name = "hydrogen-bomb-wave",
		flags = { "not-on-map" },
		hidden = true,
		acceleration = 0,
		speed_modifier = { 1.0, 0.707 },
		action = {
			{
				type = "area",
				radius = 5,
				ignore_collision_condition = true,
				action_delivery = {
					type = "instant",
					target_effects = {
						type = "damage",
						vaporize = false,
						lower_distance_threshold = 0,
						upper_distance_threshold = 95,
						lower_damage_modifier = 1,
						upper_damage_modifier = 0.1,
						damage = { amount = 150, type = "explosion" },
					},
				},
			},
		},
		animation = nil,
		shadow = nil,
	},

	{
		type = "delayed-active-trigger",
		name = "thermonuclear-explosion-fires",
		delay = 1.5 * 60,
		action = {
			type = "direct",
			action_delivery = {
				{
					type = "instant",
					target_effects = {
						{
							type = "nested-result",
							action = {
								type = "area",
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 150,
								radius = 10,
								action_delivery = {
									type = "instant",
									target_effects = {
										type = "create-fire",
										entity_name = "cerys-hydrogen-bomb-fire-flame-1",
										tile_collision_mask = {
											layers = {
												water_tile = true,
											},
										},
									},
								},
							},
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 150,
								radius = 20,
								action_delivery = {
									type = "instant",
									target_effects = {
										type = "create-fire",
										entity_name = "cerys-hydrogen-bomb-fire-flame-2",
										tile_collision_mask = {
											layers = {
												water_tile = true,
											},
										},
									},
								},
							},
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 250,
								radius = 32,
								action_delivery = {
									type = "instant",
									target_effects = {
										type = "create-fire",
										entity_name = "cerys-hydrogen-bomb-fire-flame-3",
										tile_collision_mask = {
											layers = {
												water_tile = true,
											},
										},
									},
								},
							},
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 250,
								radius = 48,
								action_delivery = {
									type = "instant",
									target_effects = {
										type = "create-fire",
										entity_name = "cerys-hydrogen-bomb-fire-flame-4",
										tile_collision_mask = {
											layers = {
												water_tile = true,
											},
										},
									},
								},
							},
						},
						{
							type = "nested-result",
							action = {
								type = "area",
								target_entities = false,
								trigger_from_target = true,
								repeat_count = 80,
								radius = 64,
								action_delivery = {
									type = "instant",
									target_effects = {
										type = "create-fire",
										entity_name = "cerys-hydrogen-bomb-fire-flame-5",
										tile_collision_mask = {
											layers = {
												water_tile = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	merge(data.raw["fire"]["fire-flame"], {
		name = "cerys-hydrogen-bomb-fire-flame-1",
		initial_lifetime = 1200,
	}),
	merge(data.raw["fire"]["fire-flame"], {
		name = "cerys-hydrogen-bomb-fire-flame-2",
		initial_lifetime = 1000,
	}),
	merge(data.raw["fire"]["fire-flame"], {
		name = "cerys-hydrogen-bomb-fire-flame-3",
		initial_lifetime = 800,
	}),
	merge(data.raw["fire"]["fire-flame"], {
		name = "cerys-hydrogen-bomb-fire-flame-4",
		initial_lifetime = 600,
	}),
	merge(data.raw["fire"]["fire-flame"], {
		name = "cerys-hydrogen-bomb-fire-flame-5",
		initial_lifetime = 400,
	}),
	{
		type = "explosion",
		name = "thermonuclear-explosion",
		flags = { "not-on-map" },
		hidden = true,
		icons = {
			{ icon = "__base__/graphics/icons/explosion.png" },
			{ icon = "__base__/graphics/icons/atomic-bomb.png" },
		},
		order = "a-d-a",
		subgroup = "explosions",
		height = 0,
		sound = {
			audible_distance_modifier = 2,
			speed = 2,
			variations = {
				{ filename = "__base__/sound/fight/large-explosion-1.ogg", volume = 0.5, speed = 2 },
				{ filename = "__base__/sound/fight/large-explosion-2.ogg", volume = 0.5, speed = 2 },
			},
		},
		animations = {
			width = 628,
			height = 720,
			frame_count = 100,
			draw_as_glow = true,
			priority = "very-low",
			flags = { "linear-magnification" },
			shift = util.by_pixel(0.5, -122.5), --shift = util.by_pixel(0.5, -62.5), shifted by 60 due to scaling and centering
			animation_speed = 0.45 * 0.5 * 0.75,
			scale = 4,
			dice_y = 5,
			allow_forced_downscale = true,
			stripes = {
				{
					filename = "__base__/graphics/entity/nuke-explosion/nuke-explosion-1.png",
					width_in_frames = 5,
					height_in_frames = 5,
				},
				{
					filename = "__base__/graphics/entity/nuke-explosion/nuke-explosion-2.png",
					width_in_frames = 5,
					height_in_frames = 5,
				},
				{
					filename = "__base__/graphics/entity/nuke-explosion/nuke-explosion-3.png",
					width_in_frames = 5,
					height_in_frames = 5,
				},
				{
					filename = "__base__/graphics/entity/nuke-explosion/nuke-explosion-4.png",
					width_in_frames = 5,
					height_in_frames = 5,
				},
			},
			usage = "explosion",
		},
	},
	{
		type = "explosion",
		name = "cerys-atmospheric-nuke-effect",
		flags = { "not-on-map" },
		hidden = true,
		icons = {
			{ icon = "__base__/graphics/icons/explosion.png" },
			{ icon = "__base__/graphics/icons/atomic-bomb.png" },
		},
		order = "cerys",
		subgroup = "explosions",
		height = 0,
		animations = util.empty_sprite(),
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "camera-effect",
						duration = 255,
						ease_in_duration = 5,
						ease_out_duration = 255,
						delay = 0,
						strength = 20,
						full_strength_max_distance = 2500,
						max_distance = 2000,
					},
				},
			},
		},
	},
})
