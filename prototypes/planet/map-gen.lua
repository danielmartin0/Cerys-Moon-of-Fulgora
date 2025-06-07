local common = require("common")

data:extend({
	{
		type = "noise-expression",
		name = "cerys_radius",
		expression = tostring(common.CERYS_RADIUS),
	},

	{
		type = "noise-expression",
		name = "cerys_map_distance",
		expression = "(cerys_xx^2 + cerys_yy^2)^(1/2)",
	},

	{
		type = "noise-expression",
		name = "cerys_surface_distance_over_map_distance",
		expression = "(cerys_map_distance / cerys_radius) + \z
			((cerys_map_distance / cerys_radius)^3) / 6 + \z
			3 * ((cerys_map_distance / cerys_radius)^5) / 40 + \z
			5 * ((cerys_map_distance / cerys_radius)^7) / 112 + \z
			35 * ((cerys_map_distance / cerys_radius)^9) / 1152", -- series expansion
	},

	{
		type = "noise-expression",
		name = "cerys_stretch_factor",
		expression = common.cerys_surface_stretch_factor_for_math(),
	},

	{
		type = "noise-expression",
		name = "cerys_y_surface_before_ribbonworld_adjustment",
		expression = "y * cerys_surface_distance_over_map_distance",
	},

	{
		type = "noise-expression",
		name = "cerys_y_surface",
		expression = "cerys_y_surface_before_ribbonworld_adjustment * cerys_stretch_factor",
	},

	{
		type = "noise-expression",
		name = "cerys_yy",
		expression = "y * cerys_stretch_factor",
	},

	{
		type = "noise-expression",
		name = "cerys_x_surface_before_ribbonworld_adjustment",
		expression = "x * cerys_surface_distance_over_map_distance",
	},

	{
		type = "noise-expression",
		name = "cerys_x_surface",
		expression = "cerys_x_surface_before_ribbonworld_adjustment / cerys_stretch_factor",
	},

	{
		type = "noise-expression",
		name = "cerys_xx",
		expression = "x / cerys_stretch_factor",
	},

	{
		type = "noise-expression",
		name = "cerys_surface",
		expression = "cerys_radius_wobble + (cerys_radius - cerys_map_distance) / 50",
	},

	{
		type = "noise-expression",
		name = "cerys_surface_inner",
		expression = "cerys_radius_wobble + (cerys_radius - 2 - cerys_map_distance) / 50",
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
			output_scale = 1} + 0.1",
	},
	{
		type = "noise-expression",
		name = "cerys_pumice_stones",
		expression = "multioctave_noise{\z
			x = cerys_x_surface, \z
			y = cerys_y_surface, \z
			seed0 = map_seed, \z
			seed1 = 6400, \z
			octaves = 5, \z
			persistence = 0.7, \z
			input_scale = 1 / 2, \z
			output_scale = 1} + 0.1",
	},

	{
		type = "noise-expression",
		name = "cerys_water",
		-- Heavily tuned:
		expression = "max(0, multioctave_noise{\z
			x = (cerys_x_surface * 0.22 + 77), \z
			y = (cerys_y_surface * 0.22 + 77), \z
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
		name = "cerys_nuclear_scrap_forced_spot_radius",
		expression = "3 * (slider_rescale(control:cerys_nuclear_scrap:size, 2)^(1/2))",
	},
	{
		type = "noise-expression",
		name = "cerys_nuclear_scrap_forced",
		expression = "((cerys_nuclear_scrap_forced_spot_radius / \z
			((cerys_x_surface + 11)^2 + (cerys_y_surface - 1)^2)^(1/2)) - 1)^3",
	},
	{
		type = "noise-expression",
		name = "cerys_nuclear_scrap", -- biased towards center of the map, but not the exact center (as large patches in the center of the map look unpleasant)
		expression = "max(0, ceil(cerys_nuclear_scrap_forced)) + \z
			max(0, multioctave_noise{\z
				x = cerys_x_surface, \z
				y = cerys_y_surface, \z
				seed0 = map_seed, \z
				seed1 = 400, \z
				octaves = 3, \z
				persistence = 0.4, \z
				input_scale = slider_rescale(control:cerys_nuclear_scrap:size, 3) / 4, \z
				output_scale = 250} * (1.2 - 0.4 * cerys_map_distance / cerys_radius) \z
				- (260 / slider_rescale(control:cerys_nuclear_scrap:size, 1.2) \z
				/ slider_rescale(control:cerys_nuclear_scrap:frequency, 1.2))) \z
			- 10000 * cerys_water \z
			- 10000 * max(0, cerys_nitrogen_rich_minerals_forced(cerys_nitrogen_rich_minerals_forced_spot_radius * 1.2)) \z
			+ min(0, ((cerys_xx^2 + cerys_yy^2)^(1/2) - 35) * 8) \z
			+ min(0, (((x - ("
			.. tostring(common.REACTOR_POSITION_SEED.x)
			.. "))^2 + \z
			(cerys_yy - ("
			.. tostring(common.REACTOR_POSITION_SEED.y)
			.. "))^2)^(1/2) - 40) * 8)",
	},

	{
		type = "noise-expression",
		name = "cerys_methane_ice_forced_spot_radius",
		expression = "28 * (slider_rescale(control:cerys_methane_ice:size, 2)^(1/2))",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_ice_forced",
		expression = "10 * ((cerys_methane_ice_forced_spot_radius / \z
			((cerys_x_surface + 10)^2 + (cerys_y_surface - 80)^2)^(1/2)) - 1) + \z
			7 * ((cerys_methane_ice_forced_spot_radius / \z
			((cerys_x_surface + 17)^2 + (cerys_y_surface + 75)^2)^(1/2)) - 1.1)",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_ice",
		expression = "max(0, ceil(cerys_methane_ice_forced)) \z
			+ max(0, multioctave_noise{\z
				x = cerys_x_surface, \z
				y = cerys_y_surface, \z
				seed0 = map_seed, \z
				seed1 = 500, \z
				octaves = 3, \z
				persistence = 0.4, \z
				input_scale = slider_rescale(control:cerys_methane_ice:size, 3) / 9, \z
				output_scale = 240} \z
				- (260 / slider_rescale(control:cerys_methane_ice:size, 1.2) \z
				/ slider_rescale(control:cerys_methane_ice:frequency, 1.2))) \z
			- 10000 * cerys_water \z
			- 10000 * max(0, cerys_nitrogen_rich_minerals_forced(cerys_nitrogen_rich_minerals_forced_spot_radius * 1.2)) \z
			+ min(0, ((cerys_xx^2 + cerys_yy^2)^(1/2) - 40) * 8) \z
			+ min(0, (((x - ("
			.. tostring(common.REACTOR_POSITION_SEED.x)
			.. "))^2 + \z
			(cerys_yy - ("
			.. tostring(common.REACTOR_POSITION_SEED.y)
			.. "))^2)^(1/2) - 40) * 8)", -- Large patches in the center of the map look unpleasant
	},

	{
		type = "noise-expression",
		name = "cerys_nitrogen_rich_minerals_forced_spot_radius",
		expression = "21 * (slider_rescale(control:cerys_nitrogen_rich_minerals:size, 2)^(1/2))",
	},
	{
		type = "noise-expression",
		name = "cerys_smoothed_nitrogen_x_coordinate", -- To make it easier to discover the patch, while letting it get quite close to the moon edge.
		expression = "cerys_x_surface * 0.7 + 70",
	},

	{
		type = "noise-function",
		name = "cerys_nitrogen_rich_minerals_forced",
		parameters = { "radius" },
		expression = "((radius / \z
			(cerys_smoothed_nitrogen_x_coordinate^2 + \z
			(cerys_y_surface + 18)^2)^(1/2)) - 1)^3 \z
			+ (0.22 * radius / \z
			((cerys_x_surface - 8)^2 + \z
			(cerys_y_surface - 64)^2)^(1/2)) \z
			+ (0.22 * radius / \z
			((cerys_x_surface + 8)^2 + \z
			(cerys_y_surface + 64)^2)^(1/2)) \z
			- 0.2",
	}, -- Main patch is on the left to encourage the player to start far from the final zone. The others are hint patches.

	{
		type = "noise-expression",
		name = "cerys_nitrogen_rich_minerals",
		expression = "max(0, -(30 / slider_rescale(control:cerys_nitrogen_rich_minerals:size, 1.2) \z
				/ slider_rescale(control:cerys_nitrogen_rich_minerals:frequency, 1.2)) + 10 * cerys_nitrogen_rich_minerals_forced(cerys_nitrogen_rich_minerals_forced_spot_radius) + \z
			multioctave_noise{\z
				x = cerys_x_surface, \z
				y = cerys_y_surface, \z
				seed0 = map_seed, \z
				seed1 = 600, \z
				octaves = 3, \z
				persistence = 0.4, \z
				input_scale = slider_rescale(control:cerys_nitrogen_rich_minerals:size, 3) / 5, \z
				output_scale = 12})",
	},

	{
		type = "noise-expression",
		name = "cerys_all_forced_resources",
		expression = "max(0, cerys_nuclear_scrap_forced) + \z
			max(0, cerys_nitrogen_rich_minerals_forced(cerys_nitrogen_rich_minerals_forced_spot_radius)) + \z
			max(0, cerys_methane_ice_forced)",
	},

	{
		type = "noise-expression",
		name = "cerys_all_resources",
		expression = "max(0, cerys_nuclear_scrap + cerys_nitrogen_rich_minerals + cerys_methane_ice)",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_iceberg_huge",
		expression = "-0.6 \z
			+ cerys_rpi(0.2) \z
			- min(0, cerys_decorative_knockout) \z
			+ cerys_decorative_mix_noise{seed = 1000, input_scale = 1/14}\z
			- 10 * cerys_all_resources",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_iceberg_big",
		expression = "-0.7 \z
			+ cerys_rpi(0.2) \z
			- min(0, cerys_decorative_knockout) \z
			+ cerys_decorative_mix_noise{seed = 2000, input_scale = 1/12}\z
			- 10 * cerys_all_resources",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_iceberg_medium",
		expression = "-0.4 \z
			+ cerys_rpi(0.2) \z
			- min(0, cerys_decorative_knockout) \z
			+ cerys_decorative_mix_noise{seed = 3000, input_scale = 1/10}\z
			- 10 * cerys_all_resources",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_iceberg_small",
		expression = "-0.2 \z
			+ cerys_rpi(0.2) \z
			- min(0, cerys_decorative_knockout) \z
			+ cerys_decorative_mix_noise{seed = 4000, input_scale = 1/8}\z
			- 10 * cerys_all_resources",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_iceberg_tiny",
		expression = "-0.1 \z
			+ cerys_rpi(0.2) \z
			- min(0, cerys_decorative_knockout) \z
			+ cerys_decorative_mix_noise{seed = 5000, input_scale = 1/7}\z
			- 10 * cerys_all_resources",
	},
	{
		type = "noise-expression",
		name = "cerys_ruin_tiny",
		expression = "-0.6 \z
			+ cerys_rpi(0.2) \z
			- min(0, cerys_decorative_knockout) \z
			+ cerys_decorative_mix_noise{seed = 6000, input_scale = 1/7}\z
			- 10 * cerys_all_resources",
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
		name = "cerys_ash_flats", -- TODO: Remove when the base game bug of crashing on noise prototype removal is fixed
		expression = "0",
	},
	{
		type = "noise-expression",
		name = "cerys_methane_iceberg_large", -- TODO: Remove when the base game bug of crashing on noise prototype removal is fixed
		expression = "0",
	},
	{
		type = "noise-expression",
		name = "xx", -- TODO: Remove when the base game bug of crashing on noise prototype removal is fixed
		expression = "0",
	},
	{
		type = "noise-expression",
		name = "yy", -- TODO: Remove when the base game bug of crashing on noise prototype removal is fixed
		expression = "0",
	},
	{
		type = "noise-expression",
		name = "cerys_reactor_correction", -- TODO: Remove when the base game bug of crashing on noise prototype removal is fixed
		expression = "0",
	},
	{
		type = "noise-expression",
		name = "cerys_script_occupied_terrain", -- TODO: Remove when the base game bug of crashing on noise prototype removal is fixed
		expression = "0",
	},

	{
		type = "noise-expression",
		name = "surface_distance", -- TODO: Remove when the base game bug of crashing on noise prototype removal is fixed
		expression = "0",
	},
	{
		type = "noise-expression",
		name = "map_distance", -- TODO: Remove when the base game bug of crashing on noise prototype removal is fixed
		expression = "0",
	},
	{
		type = "noise-function",
		name = "cerys_rpi", -- adapted from vanilla
		parameters = { "survival" },
		expression = "random_penalty{x = cerys_x_surface, y = cerys_y_surface, source = 1, amplitude = 1/survival} - 1",
	},
	{
		type = "noise-function",
		name = "cerys_decorative_mix_noise", -- adapted from vanilla
		parameters = { "seed", "input_scale" },
		expression = "-0.25\z
		+ abs(multioctave_noise{x = cerys_x_surface, y = cerys_y_surface, persistence = 0.65, seed0 = map_seed, seed1 = seed + 500, octaves = 2, input_scale = input_scale, output_scale = 0.8, offset_y = seed})\z
		+ basis_noise{x = cerys_x_surface, y = cerys_y_surface, seed0 = map_seed, seed1 = seed, input_scale = input_scale, output_scale = 0.1, offset_x = seed}\z
		+ basis_noise{x = cerys_x_surface, y = cerys_y_surface, seed0 = map_seed, seed1 = seed, input_scale = input_scale / 2, output_scale = 0.15, offset_x = seed}\z
		+ basis_noise{x = cerys_x_surface, y = cerys_y_surface, seed0 = map_seed, seed1 = seed, input_scale = input_scale / 4, output_scale = 0.2, offset_x = seed}",
	},
	{
		type = "noise-expression",
		name = "cerys_decorative_knockout", -- adapted from vanilla
		expression = "multioctave_noise{x = cerys_x_surface, y = cerys_y_surface, persistence = 0.7, seed0 = map_seed, seed1 = 1300000, octaves = 2, input_scale = 1/2.5}",
	},
})
