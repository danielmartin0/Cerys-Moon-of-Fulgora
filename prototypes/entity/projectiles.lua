local merge = require("lib").merge
local sounds = require("__base__.prototypes.entity.sounds")

local nuke_shockwave_starting_speed_deviation = 0.125

local NEUTRON_DAMAGE = { amount = 70, type = "physical" }

local neutron_damage_effect = {
	type = "direct",
	filter_enabled = true,
	entity_flags = { "breaths-air" },
	action_delivery = {
		type = "instant",
		target_effects = {
			type = "damage",
			damage = NEUTRON_DAMAGE,
		},
	},
}

local base_neutron = {
	type = "projectile",
	hidden = true,
	acceleration = 0,
	direction_only = true,
	map_color = { 0.8, 0.8, 0.8 },
	collision_box = { { -0.15, -0.8 }, { 0.15, 0.8 } },
	animation = {
		filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/neutron.png",
		size = 32,
		scale = 0.5,
		draw_as_glow = true,
	},
	action = neutron_damage_effect,
}

local create_neutron = {
	type = "area",
	target_entities = false,
	trigger_from_target = true,
	radius = 12,
	action_delivery = {
		type = "projectile",
		projectile = "cerys-neutron-projectile",
		starting_speed = 1.1,
		starting_speed_deviation = 1.5,
		max_range = 12,
		min_range = 0,
		direction_deviation = math.pi,
	},
}

local create_neutron_slow = {
	type = "area",
	target_entities = false,
	trigger_from_target = true,
	radius = 6,
	action_delivery = {
		type = "projectile",
		projectile = "cerys-neutron-projectile-2",
		starting_speed = 0.9,
		starting_speed_deviation = 1.2,
		max_range = 6,
		min_range = 0,
		direction_deviation = 3 * math.pi / 16,
	},
}

local create_neutron_very_slow = {
	type = "area",
	target_entities = false,
	trigger_from_target = true,
	radius = 6,
	action_delivery = {
		type = "projectile",
		projectile = "cerys-neutron-projectile-3",
		starting_speed = 0.3,
		starting_speed_deviation = 0.3,
		max_range = 6,
		min_range = 0,
		direction_deviation = 5 * math.pi / 16,
	},
}

data:extend({
	merge(base_neutron, {
		name = "cerys-neutron-projectile-3",
	}),

	merge(base_neutron, {
		name = "cerys-neutron-projectile-2",
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "nested-result",
						action = neutron_damage_effect,
					},
					{
						type = "nested-result",
						probability = 1,
						action = create_neutron_very_slow,
					},
				},
			},
		},
	}),
	merge(base_neutron, {
		name = "cerys-neutron-projectile",
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "nested-result",
						action = neutron_damage_effect,
					},
					{
						type = "nested-result",
						probability = 1,
						action = create_neutron_slow,
					},
				},
			},
		},
	}),

	{
		type = "artillery-projectile",
		name = "cerys-neutron-bomb-projectile",
		flags = { "not-on-map" },
		hidden = true,
		reveal_map = true,
		map_color = { r = 0, g = 1, b = 1 },
		picture = {
			filename = "__base__/graphics/entity/artillery-projectile/shell.png",
			draw_as_glow = true,
			width = 64,
			height = 64,
			scale = 0.5,
		},
		shadow = {
			filename = "__base__/graphics/entity/artillery-projectile/shell-shadow.png",
			width = 64,
			height = 64,
			scale = 0.5,
		},
		chart_picture = {
			filename = "__base__/graphics/entity/artillery-projectile/artillery-shoot-map-visualization.png",
			flags = { "icon" },
			width = 64,
			height = 64,
			priority = "high",
			scale = 0.25,
		},
		height_from_ground = 280 / 64,
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "nested-result",
						repeat_count = 175,
						action = create_neutron,
					},
					{
						type = "nested-result",
						repeat_count = 50,
						action = create_neutron_slow,
					},
					{
						type = "nested-result",
						action = {
							type = "area",
							radius = 6,
							action_delivery = {
								type = "instant",
								target_effects = {
									{
										type = "damage",
										damage = { amount = 2500, type = "physical" },
									},
									{
										type = "damage",
										damage = { amount = 2500, type = "explosion" },
									},
								},
							},
						},
					},
					{
						type = "create-entity",
						entity_name = "neutron-bomb-explosion",
					},
					{
						type = "camera-effect",
						duration = 12,
						ease_in_duration = 5,
						ease_out_duration = 40,
						delay = 0,
						strength = 5,
						full_strength_max_distance = 40,
						max_distance = 500,
					},
					{
						type = "play-sound",
						sound = sounds.nuclear_explosion(0.5),
						play_on_target_position = true,
					},
					{
						type = "create-trivial-smoke",
						smoke_name = "artillery-smoke",
						initial_height = 0,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.005,
						offset_deviation = { { -4, -4 }, { 4, 4 } },
						max_radius = 3.5,
						repeat_count = 4 * 4 * 15,
					},
					{
						type = "invoke-tile-trigger",
						repeat_count = 1,
					},
					{
						type = "show-explosion-on-chart",
						scale = 16 / 32,
					},
				},
			},
		},
	},

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
							type = "set-tile",
							tile_name = "nuclear-ground",
							radius = 14,
							apply_projection = true,
							tile_collision_mask = {
								layers = {
									water_tile = true,
								},
							},
						},
						{
							type = "destroy-cliffs",
							radius = 27,
							explosion_at_trigger = "explosion",
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

	-- {
	-- 	type = "projectile",
	-- 	name = "cerys-plutonium-cannon-projectile",
	-- 	flags = { "not-on-map" },
	-- 	hidden = true,
	-- 	collision_box = { { -0.3, -1.1 }, { 0.3, 1.1 } },
	-- 	acceleration = 0,
	-- 	direction_only = true,
	-- 	piercing_damage = data.raw["projectile"]["uranium-cannon-projectile"].piercing_damage * 2,
	-- 	action = {
	-- 		type = "direct",
	-- 		action_delivery = {
	-- 			type = "instant",
	-- 			target_effects = {
	-- 				{
	-- 					type = "damage",
	-- 					damage = { amount = 4000, type = "physical" },
	-- 				},
	-- 				{
	-- 					type = "damage",
	-- 					damage = { amount = 400, type = "explosion" },
	-- 				},
	-- 				{
	-- 					type = "create-entity",
	-- 					entity_name = "plutonium-cannon-explosion",
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- 	final_action = {
	-- 		type = "direct",
	-- 		action_delivery = {
	-- 			type = "instant",
	-- 			target_effects = {
	-- 				{
	-- 					type = "create-entity",
	-- 					entity_name = "small-scorchmark-tintable",
	-- 					check_buildability = true,
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- 	animation = {
	-- 		filename = "__base__/graphics/entity/bullet/bullet.png",
	-- 		draw_as_glow = true,
	-- 		width = 3,
	-- 		height = 50,
	-- 		priority = "high",
	-- 	},
	-- },

	-- {
	-- 	type = "projectile",
	-- 	name = "explosive-cerys-plutonium-cannon-projectile",
	-- 	flags = { "not-on-map" },
	-- 	hidden = true,
	-- 	collision_box = { { -0.3, -1.1 }, { 0.3, 1.1 } },
	-- 	acceleration = 0,
	-- 	piercing_damage = data.raw["projectile"]["explosive-uranium-cannon-projectile"].piercing_damage * 2,
	-- 	action = {
	-- 		type = "direct",
	-- 		action_delivery = {
	-- 			type = "instant",
	-- 			target_effects = {
	-- 				{
	-- 					type = "damage",
	-- 					damage = { amount = 700, type = "physical" },
	-- 				},
	-- 				{
	-- 					type = "create-entity",
	-- 					entity_name = "plutonium-cannon-explosion",
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- 	final_action = {
	-- 		type = "direct",
	-- 		action_delivery = {
	-- 			type = "instant",
	-- 			target_effects = {
	-- 				{
	-- 					type = "create-entity",
	-- 					entity_name = "plutonium-cannon-shell-explosion",
	-- 				},
	-- 				{
	-- 					type = "nested-result",
	-- 					action = {
	-- 						type = "area",
	-- 						radius = 4.25,
	-- 						action_delivery = {
	-- 							type = "instant",
	-- 							target_effects = {
	-- 								{
	-- 									type = "damage",
	-- 									damage = { amount = 620, type = "explosion" },
	-- 								},
	-- 								{
	-- 									type = "create-entity",
	-- 									entity_name = "plutonium-cannon-explosion",
	-- 								},
	-- 							},
	-- 						},
	-- 					},
	-- 				},
	-- 				{
	-- 					type = "create-entity",
	-- 					entity_name = "medium-scorchmark-tintable",
	-- 					check_buildability = true,
	-- 				},
	-- 				{
	-- 					type = "invoke-tile-trigger",
	-- 					repeat_count = 1,
	-- 				},
	-- 				{
	-- 					type = "destroy-decoratives",
	-- 					from_render_layer = "decorative",
	-- 					to_render_layer = "object",
	-- 					include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
	-- 					include_decals = false,
	-- 					invoke_decorative_trigger = true,
	-- 					decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
	-- 					radius = 3.25, -- large radius for demostrative purposes
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- 	animation = {
	-- 		filename = "__base__/graphics/entity/bullet/bullet.png",
	-- 		draw_as_glow = true,
	-- 		width = 3,
	-- 		height = 50,
	-- 		priority = "high",
	-- 	},
	-- },
})
