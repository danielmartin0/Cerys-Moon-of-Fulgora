local merge = require("lib").merge
-- local sounds = require("__base__.prototypes.entity.sounds")

local cryo_plant = merge(data.raw["assembling-machine"]["cryogenic-plant"], {
	name = "cerys-fulgoran-cryogenic-plant",
	subgroup = "cerys-entities",
	order = "b",
	max_health = 35000,
	crafting_categories = {
		"fulgoran-cryogenics",
		"electromagnetics-or-fulgoran-cryogenics",
		"chemistry-or-cryogenics-or-fulgoran-cryogenics",
		"cryogenics-or-fulgoran-cryogenics",
	},
	module_slots = 9,
	crafting_speed = 1.5,
	next_upgrade = "nil",
	fast_replaceable_group = "cerys-fulgoran-cryogenic-plant",
	minable = { mining_time = 1, result = "cerys-fulgoran-cryogenic-plant" }, -- This should never happen, but including it prompts the 'this cannot be mined' text if the created entity is set with minable_flag = false.
	autoplace = {
		probability_expression = "0",
	},
	map_color = { 153, 158, 255 },
	icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/cryogenic-plant.png",
	icon_size = 432,
})

-- TODO: Apart from the main image, some of the shifts are from the base game.
cryo_plant.graphics_set = {
	animation = {
		layers = {
			{
				animation_speed = 0.5,
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-main.png",
				frame_count = 1,
				repeat_count = 192,
				height = 864,
				line_length = 1,
				scale = 0.252,
				shift = {
					0.4,
					-0.1,
				},
				width = 993,
			},
			{
				animation_speed = 0.5,
				draw_as_shadow = true,
				filename = "__space-age__/graphics/entity/cryogenic-plant/cryogenic-plant-shadow.png",
				frame_count = 1,
				repeat_count = 192,
				height = 310,
				line_length = 1,
				scale = 0.5,
				shift = {
					1.109375,
					0.21875,
				},
				width = 462,
			},
			{
				animation_speed = 0.5,
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-anim1-base.png",
				frame_count = 64,
				height = 188,
				line_length = 8,
				repeat_count = 3,
				scale = 0.25,
				shift = {
					-0.25,
					-1.359375,
				},
				width = 244,
			},
		},
	},
	working_visualisations = {
		{
			animation = {
				animation_speed = 0.5,
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-anim1-working.png",
				frame_count = 64,
				height = 128,
				line_length = 8,
				repeat_count = 3,
				scale = 0.25,
				shift = {
					-0.21875,
					-1.1875,
				},
				width = 212,
			},
			fadeout = true,
		},
		{
			animation = {
				animation_speed = 0.5,
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-anim1-mask1.png",
				frame_count = 64,
				height = 124,
				line_length = 8,
				repeat_count = 3,
				scale = 0.25,
				shift = {
					-0.21875,
					-1.1875,
				},
				width = 208,
			},
			apply_recipe_tint = "primary",
			fadeout = true,
		},
		{
			animation = {
				animation_speed = 0.5,
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-anim1-mask2.png",
				frame_count = 64,
				height = 120,
				line_length = 8,
				repeat_count = 3,
				scale = 0.25,
				shift = {
					-0.21875,
					-1.171875,
				},
				width = 208,
			},
			apply_recipe_tint = "secondary",
			fadeout = true,
		},
	},
}

local wreck = merge(cryo_plant, {
	name = "cerys-fulgoran-cryogenic-plant-wreck",
	hidden_in_factoriopedia = true,
	crafting_categories = { "cryogenic-plant-repair" },
	fixed_recipe = "cerys-repair-cryogenic-plant",
	fast_replaceable_group = "cerys-fulgoran-cryogenic-plant",
	crafting_speed = 0.2, -- Super slow animation
	energy_source = {
		type = "void",
	},
	module_slots = 2,
	allowed_effects = { "speed", "productivity" },
	graphics_set = {
		animation = {
			layers = {
				{
					animation_speed = 0.5,
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-wreck.png",
					frame_count = 1,
					repeat_count = 192,
					height = 864,
					line_length = 1,
					scale = 0.28,
					shift = {
						0.4,
						-0.1,
					},
					width = 993,
				},
			},
		},
		working_visualisations = nil,
	},
	map_color = { 53, 54, 89 },
})

local wreck_frozen = merge(wreck, {
	name = "cerys-fulgoran-cryogenic-plant-wreck-frozen",
	graphics_set = {
		animation = {
			layers = {
				{
					animation_speed = 0.5,
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-wreck-frozen.png",
					frame_count = 1,
					repeat_count = 192,
					height = 864,
					line_length = 1,
					scale = 0.28,
					shift = {
						0.4,
						-0.1,
					},
					width = 993,
				},
			},
		},
		working_visualisations = nil,
	},
})

data:extend({
	cryo_plant,
	wreck,
	wreck_frozen,
})
