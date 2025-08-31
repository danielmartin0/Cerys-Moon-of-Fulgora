local function sound_variations_with_volume_variations(
	filename_string,
	variations,
	min_volume,
	max_volume,
	modifiers_parameter
)
	local result = {}
	for i = 1, variations do
		result[i] = {
			filename = filename_string .. "-" .. i .. ".ogg",
			min_volume = min_volume or 0.5,
			max_volume = max_volume or 0.5,
		}
		if modifiers_parameter then
			result[i].modifiers = modifiers_parameter
		end
	end
	return result
end

data:extend({
	{
		type = "explosion",
		name = "plutonium-explosion",
		localised_name = { "entity-name.explosion" },
		icons = {
			{ icon = "__base__/graphics/icons/explosion.png" },
			{ icon = "__base__/graphics/icons/cannon-shell.png" },
		},
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "explosions",
		animations = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/explosion-2.png",
				draw_as_glow = true,
				priority = "high",
				line_length = 16,
				width = 64,
				height = 57,
				frame_count = 16,
				animation_speed = 0.5,
				scale = 0.5,
				shift = util.by_pixel(-15, 10),
				usage = "explosion",
			},
		},
		sound = {
			aggregation = {
				max_count = 1,
				remove = true,
			},
			variations = sound_variations_with_volume_variations("__base__/sound/small-explosion", 5, 0.25, 0.3),
		},
	},
})

data:extend({
	{
		type = "optimized-particle",
		name = "solar-wind-exposure-particle",
		life_time = (60 * 0.30),
		render_layer = "projectile",
		render_layer_when_on_ground = "corpse",
		regular_trigger_effect_frequency = 2,
		pictures = {
			sheet = {
				filename = "__base__/graphics/particle/blood-particle/water-particle.png",
				line_length = 12,
				width = 16,
				height = 16,
				frame_count = 12,
				variation_count = 7,
				tint = { r = 0.8, g = 0.8, b = 1 },
				scale = 0.78,
				draw_as_glow = true,
				shift = util.by_pixel(1.5, -1),
			},
		},
	},
})

-- local plutonium_cannon_shell_explosion = merge(data.raw["explosion"]["big-explosion"], {
-- 	name = "plutonium-cannon-shell-explosion",
-- 	localised_name = "entity-name.plutonium-cannon-shell-explosion",
-- 	icons = {
-- 		{ icon = "__base__/graphics/icons/explosion.png" },
-- 		{ icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/explosive-plutonium-cannon-shell.png" },
-- 	},
-- })
-- for _, spritesheet in pairs(plutonium_cannon_shell_explosion.animations) do
-- 	spritesheet.tint = { r = 0.3, g = 0.4, b = 1 }
-- end

-- local plutonium_cannon_explosion = merge(data.raw["explosion"]["explosion"], {
-- 	name = "plutonium-cannon-explosion",
-- 	localised_name = "entity-name.plutonium-cannon-explosion",
-- 	icons = {
-- 		{ icon = "__base__/graphics/icons/explosion.png" },
-- 		{ icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/plutonium-cannon-shell.png" },
-- 	},
-- })
-- for _, spritesheet in pairs(plutonium_cannon_explosion.animations) do
-- 	spritesheet.tint = { r = 0.3, g = 0.4, b = 1 }
-- end

-- data:extend({
-- 	plutonium_cannon_shell_explosion,
-- 	plutonium_cannon_explosion,
-- })

-- data:extend({

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
-- })
