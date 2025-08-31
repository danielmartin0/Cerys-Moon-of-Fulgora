local merge = require("lib").merge
local sounds = require("__base__.prototypes.entity.sounds")

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

local create_neutron_vacuum = {
	type = "area",
	target_entities = false,
	trigger_from_target = true,
	radius = 200,
	action_delivery = {
		type = "projectile",
		projectile = "cerys-neutron-projectile-3",
		starting_speed = 1.5,
		starting_speed_deviation = 0.5,
		max_range = 200,
		min_range = 0,
		direction_deviation = math.pi,
	},
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
						check_buildability = true,
						entity_name = "neutron-explosion-air",
					},
					{
						type = "create-entity",
						check_buildability = true,
						entity_name = "neutron-explosion-vacuum",
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
})

data:extend({
	{
		type = "explosion",
		name = "neutron-explosion-air",
		surface_conditions = {
			{
				property = "pressure",
				min = 5.0001,
			},
		},
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				source_effects = {
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
				},
			},
		},
		flags = { "not-on-map" },
		hidden = true,
		icons = {
			{ icon = "__base__/graphics/icons/explosion.png" },
			{ icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/neutron-bomb.png", icon_size = 64 },
		},
		order = "a-d-a",
		subgroup = "explosions",
		height = 0,
		sound = {
			audible_distance_modifier = 2,
			speed = 4,
			variations = {
				{ filename = "__base__/sound/fight/large-explosion-1.ogg", volume = 1, speed = 2 },
				{ filename = "__base__/sound/fight/large-explosion-2.ogg", volume = 1, speed = 2 },
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
			animation_speed = 2.3 * 0.5 * 0.75,
			tint = { r = 0.6, g = 0.8, b = 1 },
			scale = 0.7,
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
		name = "neutron-explosion-vacuum",
		surface_conditions = {
			{
				property = "pressure",
				max = 5,
			},
		},
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				source_effects = {
					{
						type = "nested-result",
						repeat_count = 225,
						action = create_neutron_vacuum,
					},
				},
			},
		},
		flags = { "not-on-map" },
		hidden = true,
		icons = {
			{ icon = "__base__/graphics/icons/explosion.png" },
			{ icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/neutron-bomb.png", icon_size = 64 },
		},
		order = "a-d-a",
		subgroup = "explosions",
		height = 0,
		sound = {
			audible_distance_modifier = 2,
			speed = 4,
			variations = {
				{ filename = "__base__/sound/fight/large-explosion-1.ogg", volume = 1, speed = 2 },
				{ filename = "__base__/sound/fight/large-explosion-2.ogg", volume = 1, speed = 2 },
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
			animation_speed = 2.3 * 0.5 * 0.75,
			tint = { r = 0.6, g = 0.8, b = 1 },
			scale = 0.7,
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
})
