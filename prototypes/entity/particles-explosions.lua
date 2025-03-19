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

data:extend({
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
		name = "neutron-bomb-explosion",
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
