local merge = require("lib").merge
local common = require("common")
-- local sounds = require("__base__.prototypes.entity.sounds")

local cryo_plant = merge(data.raw["assembling-machine"]["cryogenic-plant"], {
	name = "cerys-fulgoran-cryogenic-plant",
	subgroup = "cerys-entities",
	order = "c",
	max_health = 3500,
	crafting_categories = {
		"fulgoran-cryogenics",
	},
	module_slots = 9,
	crafting_speed = 1,
	energy_usage = "350kW", -- If this is too high, it stops players solving their problems by expanding.
	next_upgrade = "nil",
	fast_replaceable_group = "cerys-fulgoran-cryogenic-plant",
	minable = { mining_time = 1, result = "cerys-fulgoran-cryogenic-plant" },
	autoplace = {
		probability_expression = "0",
	},
	map_color = { 83, 17, 150 },
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cryogenic-plant.png",
	icon_size = 64,
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
					0.6 - 0.132,
					-0.1 - 0.05,
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
				scale = 0.504,
				shift = {
					1.309375 - 0.132,
					0.21875 - 0.05,
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
				scale = 0.252,
				shift = {
					-0.05 - 0.132,
					-1.359375 - 0.05,
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
				scale = 0.252,
				shift = {
					0 - 0.132,
					-1.1875 - 0.05,
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
				scale = 0.252,
				shift = {
					0 - 0.132,
					-1.1875 - 0.05,
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
				scale = 0.252,
				shift = {
					0 - 0.132,
					-1.171875 - 0.05,
				},
				width = 208,
			},
			apply_recipe_tint = "secondary",
			fadeout = true,
		},
		-- TODO?:
		-- frozen_patch = util.sprite_load(
		-- 	"__space-age__/graphics/entity/cryogenic-plant/cryogenic-plant-frozen",
		-- 	{ scale = 0.5 }
		-- ),
	},
}

local pipe_picture = {
	north = {
		layers = {
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-pipe-v", {
				priority = "extra-high",
				scale = 0.252,
				shift = { 0, 3 },
			}),
		},
	},
	east = {
		layers = {
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-pipe-h", {
				priority = "extra-high",
				scale = 0.252,
				shift = { -3, 0 },
			}),
		},
	},
	south = {
		layers = {
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-pipe-v", {
				priority = "extra-high",
				scale = 0.252,
				shift = { 0, -3 },
			}),
		},
	},
	west = {
		layers = {
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-pipe-h", {
				priority = "extra-high",
				scale = 0.252,
				shift = { 3, 0 },
			}),
		},
	},
}

-- TODO: Adjust to our pipe graphics
cryo_plant.fluid_boxes = {
	{
		production_type = "input",
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = { { flow_direction = "input", direction = defines.direction.south, position = { -2, 2 } } },
	},
	{
		production_type = "input",
		pipe_covers = pipecoverspictures(),
		pipe_picture = pipe_picture,
		always_draw_covers = true, -- fighting against FluidBoxPrototype::always_draw_covers crazy default
		volume = 1000,
		pipe_connections = { { flow_direction = "input", direction = defines.direction.south, position = { 0, 2 } } },
	},
	{
		production_type = "input",
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = { { flow_direction = "input", direction = defines.direction.south, position = { 2, 2 } } },
	},
	{
		production_type = "output",
		pipe_covers = pipecoverspictures(),
		volume = 100,
		pipe_connections = { { flow_direction = "output", direction = defines.direction.north, position = { -2, -2 } } },
	},
	{
		production_type = "output",
		pipe_covers = pipecoverspictures(),
		pipe_picture = pipe_picture,
		always_draw_covers = true, -- fighting against FluidBoxPrototype::always_draw_covers crazy default
		volume = 100,
		pipe_connections = { { flow_direction = "output", direction = defines.direction.north, position = { 0, -2 } } },
	},
	{
		production_type = "output",
		pipe_covers = pipecoverspictures(),
		volume = 100,
		pipe_connections = { { flow_direction = "output", direction = defines.direction.north, position = { 2, -2 } } },
	},
}

-- fluid_boxes =
--     {
--       {
--         production_type = "input",
--         pipe_covers = pipecoverspictures(),
--         volume = 1000,
--         pipe_connections = {{ flow_direction="input", direction = defines.direction.south, position = {-2, 2} }}
--       },
--       {
--         production_type = "input",
--         pipe_picture =  require("__space-age__.prototypes.entity.cryogenic-plant-pictures").pipe_picture,
--         pipe_picture_frozen =  require("__space-age__.prototypes.entity.cryogenic-plant-pictures").pipe_picture_frozen,
--         always_draw_covers = true, -- fighting against FluidBoxPrototype::always_draw_covers crazy default
--         pipe_covers = pipecoverspictures(),
--         volume = 1000,
--         pipe_connections = {{ flow_direction="input", direction = defines.direction.south, position = {0, 2} }}
--       },
--       {
--         production_type = "input",
--         pipe_covers = pipecoverspictures(),
--         volume = 1000,
--         pipe_connections = {{ flow_direction="input", direction = defines.direction.south, position = {2, 2} }}
--       },
--       {
--         production_type = "output",
--         pipe_covers = pipecoverspictures(),
--         volume = 100,
--         pipe_connections = {{ flow_direction="output", direction = defines.direction.north, position = {-2, -2} }}
--       },
--       {
--         production_type = "output",
--         pipe_picture =  require("__space-age__.prototypes.entity.cryogenic-plant-pictures").pipe_picture,
--         pipe_picture_frozen =  require("__space-age__.prototypes.entity.cryogenic-plant-pictures").pipe_picture_frozen,
--         always_draw_covers = true, -- fighting against FluidBoxPrototype::always_draw_covers crazy default
--         pipe_covers = pipecoverspictures(),
--         volume = 100,
--         pipe_connections = {{ flow_direction="output", direction = defines.direction.north, position = {0, -2} }}
--       },
--       {
--         production_type = "output",
--         pipe_covers = pipecoverspictures(),
--         volume = 100,
--         pipe_connections = {{ flow_direction="output", direction = defines.direction.north, position = {2, -2} }}
--       }
--     }

local wreck = merge(cryo_plant, {
	name = "cerys-fulgoran-cryogenic-plant-wreck",
	hidden_in_factoriopedia = true,
	crafting_categories = { "cerys-cryogenic-plant-repair" },
	fixed_recipe = "cerys-repair-cryogenic-plant",
	fast_replaceable_group = "cerys-fulgoran-cryogenic-plant",
	crafting_speed = 1,
	energy_source = {
		type = "void",
	},
	module_slots = 1,
	allowed_effects = { "speed", "productivity" },
	graphics_set = {
		animation = {
			layers = {
				{
					animation_speed = 0.1,
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cryogenic-plant/cryogenic-plant-wreck.png",
					frame_count = 1,
					repeat_count = 192,
					height = 864,
					line_length = 1,
					scale = 0.273,
					shift = {
						0.5,
						-0.1,
					},
					width = 993,
				},
			},
		},
		working_visualisations = nil,
	},
	map_color = { 200, 150, 250 },
	working_sound = {
		-- TODO: Improve this sound
		sound = { filename = "__base__/sound/assembling-machine-t2-1.ogg", volume = 0.45 },
		audible_distance_modifier = 0.5,
		fade_in_ticks = 4,
		fade_out_ticks = 20,
	},
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
					scale = 0.273,
					shift = {
						0.5,
						-0.1,
					},
					width = 993,
					tint = common.FACTORIO_UNDO_FROZEN_TINT,
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
