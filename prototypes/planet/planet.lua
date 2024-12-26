local common = require("common")
local map_gen = require("prototypes.planet.map_gen")
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")
local planet_catalogue_cerys = require("__Cerys-Moon-of-Fulgora__.prototypes.planet.procession-catalogue-cerys")

data:extend({
	{
		type = "planet",
		name = "cerys",
		parent_planet = "fulgora", -- This field doesn't exist in the API, but this lets other modders be sensitive to it.
		planet_type = "moon", -- This field doesn't exist in the API, but this lets other modders be sensitive to it.
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cerys.png",
		starmap_icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/starmap-planet-cerys.png",
		starmap_icon_size = 500,
		map_gen_settings = map_gen.cerys(),
		gravity_pull = 10,
		distance = 25.5,
		orientation = 0.3328,
		label_orientation = 0.55,
		draw_orbit = false,
		magnitude = 0.5,
		order = "d[fulgora]-a[cerys]",
		subgroup = "planets",
		pollutant_type = nil,
		solar_power_in_space = 120,
		platform_procession_set = {
			arrival = { "planet-to-platform-b" },
			departure = { "platform-to-planet-a" },
		},
		planet_procession_set = {
			arrival = { "platform-to-planet-b" },
			departure = { "planet-to-platform-a" },
		},
		procession_graphic_catalogue = planet_catalogue_cerys,
		surface_properties = {
			["day-night-cycle"] = 4.5 * 60 * 60, -- Fulgora is 3m
			["magnetic-field"] = 120, -- Fulgora is 99
			["solar-power"] = 120, -- No atmosphere
			pressure = 5,
			gravity = 1, -- 0.1 is minimum for chests
			temperature = 251,
		},
		asteroid_spawn_influence = 1,
		asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_fulgora, 0.9),
		persistent_ambient_sounds = {},
		surface_render_parameters = {},
		entities_require_heating = not common.DEBUG_DISABLE_FREEZING,
	},
	{
		type = "space-connection",
		name = "fulgora-cerys",
		subgroup = "planet-connections",
		from = "fulgora",
		to = "cerys",
		order = "c",
		length = 800,
		asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_fulgora),
	},

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
		-- Water should avoid being on the map edge, as that looks wrong.
		type = "noise-expression",
		name = "cerys_water",
		expression = "max(0, multioctave_noise{\z
			x = (cerys_x_surface * 0.8 - 204) / 6, \z
			y = (cerys_y_surface * 0.8 + 23) / 6, \z
			seed0 = 0, \z
			seed1 = 1610, \z
			octaves = 4, \z
			persistence = 0.35, \z
			input_scale = 1, \z
			output_scale = 14} - 3.2 \z
			- 10 * cerys_all_forced_resources)", -- This expression drops below zero
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
		expression = "20",
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
		max(0, multioctave_noise{x = cerys_x_surface, y = cerys_y_surface, seed0 = map_seed, seed1 = 400, octaves = 3, persistence = 0.4, input_scale = 1 / 5, output_scale = 110} - 140)\z
		- 200 * cerys_script_occupied_terrain - 10000 * cerys_water",
	},

	{
		type = "noise-expression",
		name = "cerys_nitrogen_rich_minerals_forced_spot_radius",
		expression = "40",
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
			(cerys_smoothed_nitrogen_x_coordinate^2 + (cerys_y_surface + 18)^2)^(1/2)) - 1)^3 \z
			+ ((11 / ((cerys_x_surface - 8)^2 + (cerys_y_surface - 64)^2)^(1/2)) - 1)",
	}, -- Main patch is on the left to encourage the player to start far from the final zone. The other patch is a hint patch.

	{
		type = "noise-expression",
		name = "cerys_nitrogen_rich_minerals",
		expression = "max(0, -30 + 10 * ceil(cerys_nitrogen_rich_minerals_forced) + \z
			multioctave_noise{\z
				x = cerys_x_surface, \z
				y = cerys_y_surface, \z
				seed0 = map_seed, \z
				seed1 = 500, \z
				octaves = 3, \z
				persistence = 0.4, \z
				input_scale = 1 / 5, \z
				output_scale = 10})",
	},

	{
		type = "noise-expression",
		name = "cerys_methane_ice_forced_spot_radius",
		expression = "20",
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
		max(0, multioctave_noise{x = cerys_x_surface, y = cerys_y_surface, seed0 = map_seed, seed1 = 600, octaves = 3, persistence = 0.4, input_scale = 1 / 7, output_scale = 1} * (130 - 0.2 * map_distance * cerys_surface_distance_over_map_distance) - 140)\z
		- 400 * cerys_script_occupied_terrain - 10000 * cerys_water",
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
