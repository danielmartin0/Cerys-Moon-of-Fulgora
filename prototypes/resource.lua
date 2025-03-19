local merge = require("lib").merge

-- TODO: Like this?
-- data.raw.resource["crude-oil"].created_effect = create_tiles("snow-flat")

local stage_counts_2 = { 15000 * 100, 9500 * 100, 5500 * 100, 2900 * 100, 1300 * 100, 400 * 100, 150 * 100, 80 * 100 }
local stage_counts_3 = {
	15000 * 10000,
	9500 * 10000,
	5500 * 10000,
	2900 * 10000,
	1300 * 10000,
	400 * 10000,
	150 * 10000,
	80 * 10000,
}
local stage_counts_4 = {
	15000 * 40000,
	9500 * 40000,
	5500 * 40000,
	2900 * 40000,
	1300 * 40000,
	400 * 40000,
	150 * 40000,
	80 * 40000,
}

data:extend({
	merge(data.raw.resource["scrap"], {
		name = "cerys-nuclear-scrap",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/nuclear-scrap.png",
		icon_size = 64,
		order = "w-a[nuclear-scrap]",
		minable = merge(data.raw.resource["scrap"].minable, {
			mining_time = 0.44,
			result = "cerys-nuclear-scrap",
		}),
		stages = {
			sheet = {
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-scrap-2.png",
				priority = "extra-high",
				size = 128,
				frame_count = 8,
				variation_count = 8,
				scale = 0.5,
			},
		},
		autoplace = {
			order = "b",
			probability_expression = "cerys_nuclear_scrap",
			richness_expression = "10 + 100 * cerys_nuclear_scrap ^ 3",
		},
		map_color = { 0.18, 0.22, 0.2 },
		map_grid = true,
		factoriopedia_simulation = "nil",
		stage_counts = stage_counts_4,
	}),

	merge(data.raw.resource["iron-ore"], {
		name = "cerys-nitrogen-rich-minerals",
		order = "w-b[nuclear-scrap]",
		minable = merge(data.raw.resource["iron-ore"].minable, { -- TODO: Change particle emitted
			mining_time = 2.5,
			result = "cerys-nitrogen-rich-minerals",
		}),
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nitrogen-rich-minerals.png",
		icon_size = 64,
		stages = {
			sheet = {
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nitrogen-rich-minerals.png",
				priority = "extra-high",
				size = 128,
				frame_count = 8,
				variation_count = 8,
				scale = 0.5,
			},
		},
		autoplace = {
			order = "b",
			probability_expression = "cerys_nitrogen_rich_minerals",
			richness_expression = "ceil(500 + 100 * cerys_nitrogen_rich_minerals ^ 2)",
		},
		map_color = { 0, 0, 0 },
		map_grid = true,
		stage_counts = stage_counts_2,
		factoriopedia_simulation = "nil",
	}),

	merge(data.raw.resource["copper-ore"], {
		name = "methane-ice",
		order = "w-c[methane-ice]",
		minable = merge(data.raw.resource["iron-ore"].minable, { -- TODO: Change particle emitted
			mining_time = 0.45,
			result = "methane-ice",
		}),
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/methane-ice.png",
		icon_size = 64,
		stages = {
			sheet = {
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/methane-ice-crystals.png",
				priority = "extra-high",
				size = 128,
				frame_count = 8,
				variation_count = 8,
				scale = 0.5,
			},
		},
		autoplace = {
			order = "b",
			probability_expression = "cerys_methane_ice",
			richness_expression = "10 + 1000 * cerys_methane_ice ^ 2",
		},
		map_color = { 159, 194, 165 },
		map_grid = true,
		stage_counts = stage_counts_3,
		factoriopedia_simulation = "nil",
	}),
})
