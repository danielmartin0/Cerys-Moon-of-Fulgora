--== The following content should really be in data.lua. However, there are a large number of conflicts on the mod portal that arise when other mods try to mess with Cerys labs and technologies, so it is here for now. It is fine for other mods to modify these if they do so mindfully. ==--

-- TODO: Add recycling recipes for the Cerysian lab and science pack.

local merge = require("lib").merge

local cerys_lab = merge(data.raw.lab["lab"], {
	name = "cerys-lab",
	inputs = {
		"automation-science-pack",
		"logistic-science-pack",
		"cerys-science-pack",
		"utility-science-pack",
	}, -- Also set elsewhere
	collision_box = { { -2.15, -1.75 }, { 2.15, 1.75 } },
	selection_box = { { -2.5, -2 }, { 2.5, 2 } },
	minable = { mining_time = 0.2, result = "cerys-lab" },
	surface_conditions = {
		{
			property = "magnetic-field",
			min = 120,
			max = 120,
		},
	},
	energy_usage = "60kW",
	researching_speed = 2,
	frozen_patch = merge(data.raw.lab["lab"].frozen_patch, {
		scale = 0.75,
		shift = util.by_pixel(0, 4),
	}),
	on_animation = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-back.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				shift = util.by_pixel(10, 0),
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
			},
			{
				filename = "__base__/graphics/entity/lab/lab.png",
				width = 194,
				height = 174,
				frame_count = 33,
				line_length = 11,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 1.5),
				scale = 0.68,
			},
			{
				filename = "__base__/graphics/entity/lab/lab-integration.png",
				width = 242,
				height = 162,
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 15.5),
				scale = 0.68,
			},
			{
				filename = "__base__/graphics/entity/lab/lab-light.png",
				blend_mode = "additive",
				draw_as_light = true,
				width = 216,
				height = 194,
				frame_count = 33,
				line_length = 11,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 0),
				scale = 0.68,
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-front-shadow.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				line_length = 1,
				repeat_count = 33,
				shift = util.by_pixel(10, 0),
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-front.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
				shift = util.by_pixel(10, 0),
			},
			{
				filename = "__base__/graphics/entity/lab/lab-shadow.png",
				width = 242,
				height = 136,
				shift = util.by_pixel(13, 11),
				scale = 0.68,
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
				draw_as_shadow = true,
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-shadow.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				shift = util.by_pixel(10, 0),
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
				draw_as_shadow = true,
			},
		},
	},
	off_animation = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-back.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				shift = util.by_pixel(10, 0),
			},
			{
				filename = "__base__/graphics/entity/lab/lab.png",
				width = 194,
				height = 174,
				shift = util.by_pixel(0, 1.5),
				scale = 0.68,
			},
			{
				filename = "__base__/graphics/entity/lab/lab-integration.png",
				width = 242,
				height = 162,
				shift = util.by_pixel(0, 15.5),
				scale = 0.68,
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-front-shadow.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				shift = util.by_pixel(10, 0),
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-front.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				shift = util.by_pixel(10, 0),
			},
			{
				filename = "__base__/graphics/entity/lab/lab-shadow.png",
				width = 242,
				height = 136,
				shift = util.by_pixel(13, 11),
				scale = 0.68,
				draw_as_shadow = true,
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-lab/cerys-lab-shadow.png",
				priority = "high",
				width = 347,
				height = 267,
				scale = 0.68,
				draw_as_shadow = true,
				shift = util.by_pixel(10, 0),
			},
		},
	},
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cerys-lab-cropped.png", -- Since lab research productivity reads this icon
	icon_size = 64,
	fast_replaceable_group = "nil",
})

data:extend({

	cerys_lab,

	merge(cerys_lab, {
		-- This entity is never placed. It is only in the game to prevent the game from throwing a fit about there being no science lab that can research fulgoran-cryogenics-progress.
		name = "cerys-lab-dummy",
		hidden = true,
		inputs = {
			"fulgoran-cryogenics-progress",
		},
	}),

	merge(data.raw.tool["electromagnetic-science-pack"], {
		name = "cerys-science-pack",
		localised_description = "nil",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cerys-science-pack.png",
		icon_size = 64,
		weight = 1 * 1000 * 1000000, -- Cannot be launched on rocket
		order = "j-a[cerys]",
		default_import_location = "cerys",
	}),
})
