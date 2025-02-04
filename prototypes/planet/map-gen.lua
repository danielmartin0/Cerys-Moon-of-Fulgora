local common = require("common")

data:extend({

	{
		type = "noise-expression",
		name = "cerys_radius",
		expression = tostring(common.MOON_RADIUS),
	},

	{
		type = "noise-expression",
		name = "map_distance",
		expression = "(x^2 + y^2)^(1/2)",
	},

	{
		type = "noise-expression",
		name = "cerys_surface_distance_over_map_distance",
		expression = "(map_distance / cerys_radius) + \z
			((map_distance / cerys_radius)^3) / 6 + \z
			3 * ((map_distance / cerys_radius)^5) / 40 + \z
			5 * ((map_distance / cerys_radius)^7) / 112 + \z
			35 * ((map_distance / cerys_radius)^9) / 1152", -- series expansion
	},

	{
		type = "noise-expression",
		name = "cerys_x_surface",
		expression = "x * cerys_surface_distance_over_map_distance",
	},

	{
		type = "noise-expression",
		name = "cerys_y_surface",
		expression = "y * cerys_surface_distance_over_map_distance",
	},

	{
		type = "noise-expression",
		name = "cerys_surface",
		expression = "cerys_radius_wobble + (cerys_radius - distance) / 50",
	},

	{
		type = "noise-expression",
		name = "cerys_surface_inner",
		expression = "cerys_radius_wobble + (cerys_radius - 2 - distance) / 50",
	},

	{
		type = "noise-expression",
		name = "cerys_radius_wobble",
		expression = "multioctave_noise{\z
			x = cerys_x_surface, \z
			y = cerys_y_surface, \z
			seed0 = map_seed, \z
			seed1 = 0, \z
			octaves = 3, \z
			persistence = 0.5, \z
			input_scale = 1 / 10, \z
			output_scale = 1 / 40}",
	},
	{
		type = "noise-expression",
		name = "cerys_reactor_correction",
		expression = "clamp(lerp(0, 1, distance / 100), 0, 1)",
	},

	{
		type = "noise-expression",
		name = "cerys_ash_cracks",
		expression = "multioctave_noise{\z
			x = cerys_x_surface, \z
			y = cerys_y_surface, \z
			seed0 = map_seed, \z
			seed1 = 6100, \z
			octaves = 5, \z
			persistence = 0.7, \z
			input_scale = 1 / 2, \z
			output_scale = 1}",
	},
	{
		type = "noise-expression",
		name = "cerys_ash_dark",
		expression = "multioctave_noise{\z
			x = cerys_x_surface, \z
			y = cerys_y_surface, \z
			seed0 = map_seed, \z
			seed1 = 6200, \z
			octaves = 5, \z
			persistence = 0.7, \z
			input_scale = 1 / 2, \z
			output_scale = 1}",
	},
	{
		type = "noise-expression",
		name = "cerys_ash_light",
		expression = "multioctave_noise{\z
			x = cerys_x_surface, \z
			y = cerys_y_surface, \z
			seed0 = map_seed, \z
			seed1 = 6400, \z
			octaves = 5, \z
			persistence = 0.7, \z
			input_scale = 1 / 2, \z
			output_scale = 1}",
	},
	{
		type = "noise-expression",
		name = "cerys_pumice_stones",
		expression = "multioctave_noise{\z
			x = cerys_x_surface, \z
			y = cerys_y_surface, \z
			seed0 = map_seed, \z
			seed1 = 6500, \z
			octaves = 5, \z
			persistence = 0.7, \z
			input_scale = 1 / 2, \z
			output_scale = 1}",
	},

	{
		type = "noise-expression",
		name = "cerys_script_occupied_terrain",
		expression = "max(0, \z
		(1 / ((x - (" .. tostring(common.REACTOR_POSITION.x) .. "))^2 + \z
			(y - (" .. tostring(common.REACTOR_POSITION.y) .. "))^2)^(1/2)) + \z
			(1 / ((x - (" .. tostring(common.LITHIUM_POSITION.x) .. "))^2 + \z
			(y - (" .. tostring(common.LITHIUM_POSITION.y) .. "))^2)^(1/2))\z
		)",
	},
	{
		type = "noise-expression",
		name = "cerys_water",
		-- Heavily tuned:
		expression = "max(0, multioctave_noise{\z
			x = (cerys_x_surface * 0.2 + 77), \z
			y = (cerys_y_surface * 0.2 + 77), \z
			seed0 = 0, \z
			seed1 = 1610, \z
			octaves = 4, \z
			persistence = 0.35, \z
			input_scale = 1, \z
			output_scale = 15} - 2.8 \z
			- 10 * cerys_all_forced_resources\z
			+ min(0, 10000 * cerys_surface_inner))", -- This expression drops below zero
	},

	{
		type = "noise-expression",
		name = "cerys_ruin_density",
		expression = "multioctave_noise{\z
			x = cerys_x_surface, \z
			y = cerys_y_surface, \z
			seed0 = map_seed, \z
			seed1 = 200, \z
			octaves = 3, \z
			persistence = 0.4, \z
			input_scale = 3, \z
			output_scale = 2} - 0.5",
	},

	{
		type = "noise-expression",
		name = "cerys_nuclear_scrap_forced_spot_radius",
		expression = "20 * (slider_rescale(control:cerys_nuclear_scrap:size, 2)^(1/2))",
	},
	{
		type = "noise-expression",
		name = "cerys_nuclear_scrap_forced",
		expression = "((cerys_nuclear_scrap_forced_spot_radius / \z
			((cerys_x_surface + 40)^2 + (cerys_y_surface + 70)^2)^(1/2)) - 1)^3",
	},
	{
		type = "noise-expression",
		name = "cerys_nuclear_scrap",
		expression = "max(0, ceil(cerys_nuclear_scrap_forced - 0.1)) + \z
			max(0, multioctave_noise{\z
				x = cerys_x_surface, \z
				y = cerys_y_surface, \z
				seed0 = map_seed, \z
				seed1 = 400, \z
				octaves = 3, \z
				persistence = 0.4, \z
				input_scale = slider_rescale(control:cerys_nuclear_scrap:size, 3) / 10, \z
				output_scale = 220} \z
				- (280 / slider_rescale(control:cerys_nuclear_scrap:size, 1.2) \z
				/ slider_rescale(control:cerys_nuclear_scrap:frequency, 1.2))) \z
			- 200 * cerys_script_occupied_terrain \z
			- 10000 * cerys_water",
	},

	{
		type = "noise-expression",
		name = "cerys_nitrogen_rich_minerals_forced_spot_radius",
		expression = "40 * (slider_rescale(control:cerys_nitrogen_rich_minerals:size, 2)^(1/2))",
	},
	{
		type = "noise-expression",
		name = "cerys_smoothed_nitrogen_x_coordinate", -- To make it easier to discover the patch, while letting it get quite close to the moon edge.
		expression = "cerys_x_surface * 0.7 + 80",
	},
	{
		type = "noise-expression",
		name = "cerys_nitrogen_rich_minerals_forced",
		expression = "((cerys_nitrogen_rich_minerals_forced_spot_radius / \z
			(cerys_smoothed_nitrogen_x_coordinate^2 + \z
			(cerys_y_surface + 18)^2)^(1/2)) - 1)^3 \z
			+ ((0.275 * cerys_nitrogen_rich_minerals_forced_spot_radius / \z
			((cerys_x_surface - 8)^2 + \z
			(cerys_y_surface - 64)^2)^(1/2)) \z
			- 1)",
	}, -- Main patch is on the left to encourage the player to start far from the final zone. The other patch is a hint patch.

	{
		type = "noise-expression",
		name = "cerys_nitrogen_rich_minerals",
		expression = "max(0, -(30 / slider_rescale(control:cerys_nitrogen_rich_minerals:size, 1.2) \z
				/ slider_rescale(control:cerys_nitrogen_rich_minerals:frequency, 1.2)) + 10 * ceil(cerys_nitrogen_rich_minerals_forced) + \z
			multioctave_noise{\z
				x = cerys_x_surface, \z
				y = cerys_y_surface, \z
				seed0 = map_seed, \z
				seed1 = 500, \z
				octaves = 3, \z
				persistence = 0.4, \z
				input_scale = slider_rescale(control:cerys_nitrogen_rich_minerals:size, 3) / 5, \z
				output_scale = 10})",
	},

	{
		type = "noise-expression",
		name = "cerys_methane_ice_forced_spot_radius",
		expression = "20 * (slider_rescale(control:cerys_methane_ice:size, 2)^(1/2))",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_ice_forced",
		expression = "10 * ((cerys_methane_ice_forced_spot_radius / \z
			((cerys_x_surface + 10)^2 + (cerys_y_surface - 80)^2)^(1/2)) - 1)",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_ice",
		expression = "max(0, ceil(cerys_methane_ice_forced)) + \z
			max(0, multioctave_noise{\z
				x = cerys_x_surface, \z
				y = cerys_y_surface, \z
				seed0 = map_seed, \z
				seed1 = 600, \z
				octaves = 3, \z
				persistence = 0.4, \z
				input_scale = slider_rescale(control:cerys_methane_ice:frequency, 3) / 7, \z
				output_scale = 1} \z
				* (130 - 0.2 * map_distance * cerys_surface_distance_over_map_distance) - (140 / slider_rescale(control:cerys_methane_ice:size, 1.2) \z
				/ slider_rescale(control:cerys_methane_ice:frequency, 1.2)))\z
			- 400 * cerys_script_occupied_terrain \z
			- 10000 * cerys_water",
	},

	{
		type = "noise-expression",
		name = "cerys_all_forced_resources",
		expression = "max(0, cerys_nuclear_scrap_forced) + \z
			max(0, cerys_nitrogen_rich_minerals_forced) + \z
			max(0, cerys_methane_ice_forced)",
	},

	{
		type = "noise-expression",
		name = "cerys_all_resources",
		expression = "max(0, cerys_nuclear_scrap + cerys_nitrogen_rich_minerals + cerys_methane_ice)",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_iceberg_large",
		expression = "0.02 + multioctave_noise{\z
			x = cerys_x_surface, \z
			y = cerys_y_surface, \z
			seed0 = map_seed, \z
			seed1 = 3100, \z
			octaves = 4, \z
			persistence = 0.6, \z
			input_scale = 1 / 8, \z
			output_scale = 0.001}\z
			- 10 * cerys_all_resources\z
			- 10 * cerys_water",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_iceberg_small",
		expression = "0.075 + multioctave_noise{\z
			x = cerys_x_surface, \z
			y = cerys_y_surface, \z
			seed0 = map_seed, \z
			seed1 = 3100, \z
			octaves = 4, \z
			persistence = 0.6, \z
			input_scale = 1 / 8, \z
			output_scale = 0.01}\z
			- 10 * cerys_all_resources",
	},
	{
		type = "noise-expression",
		name = "cerys_ash_flats",
		expression = "0",
	},
})
