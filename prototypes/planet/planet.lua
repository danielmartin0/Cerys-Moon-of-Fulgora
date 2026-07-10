local common = require("common")
local map_gen_settings = require("prototypes.planet.map-gen-settings")
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")
local planet_catalogue_cerys = require("__Cerys-Moon-of-Fulgora__.prototypes.planet.procession-catalogue-cerys")

data:extend({
	{
		type = "surface-property",
		name = "cerys-ambient-radiation",
		default_value = 10,
	},
})

PlanetsLib:extend({
	{
		type = "planet",
		name = "cerys",
		orbit = {
			parent = {
				type = "planet",
				name = "fulgora",
			},
			distance = 1.39,
			orientation = mods["Tiered-Solar-System"] and 0.6 or 0.45, -- Generally pointing away from the sun
			sprite = {
				type = "sprite",
				filename = "__Cerys-Moon-of-Fulgora__/graphics/icons/orbit.png",
				size = 379,
				scale = 0.25,
			},
			is_satellite = true,
		},
		subgroup = "satellites",
		label_orientation = 0.51,
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cerys.png",
		icon_size = 256,
		starmap_icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/starmap-planet-cerys.png",
		starmap_icon_size = 500,
		map_gen_settings = map_gen_settings.cerys(),
		gravity_pull = 10,
		draw_orbit = false,
		magnitude = 0.5,
		order = "d[fulgora]-a[cerys]",
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
			["day-night-cycle"] = common.DAY_LENGTH_MINUTES * 60 * 60,
			["magnetic-field"] = 120, -- Fulgora is 99
			["solar-power"] = 120, -- No atmosphere
			pressure = 5,
			gravity = 0.15, -- 0.1 is minimum for chests
			temperature = 251,
			["cerys-ambient-radiation"] = 400,
		},
		asteroid_spawn_influence = 1,
		asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_fulgora, 0.9),
		persistent_ambient_sounds = {},
		surface_render_parameters = {
			shadow_opacity = 0.6, -- Slightly darker due to no atmosphere, though too dark doesn't play well with dynamic lighting
		},
		entities_require_heating = not common.DEBUG_DISABLE_FREEZING,
		


		platform_surface_render_parameters = {
			platform_backdrop =
			{
				atmosphere_color = {100,100,100,0,},
				atmosphere_ray_light_color_1 = {0,0,0,0,},
				atmosphere_ray_light_color_2 = {0,0,0,0,},
				atmosphere_thickness = 0,
				light_color = {0.9804, 1.0, 1.0, 0.8},
				light_direction = {0.50,1.0,10.0,},
				light_intensity_contrast = 0.09,
				light_radius = 50,
				planet_axis = {-22,30,},
				planet_surface =
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/planet/cerys.png",
					width = 4096,
					height = 2048
				},
				planet_normal =
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/planet/cerys-normal.png",
					width = 2048,
					height = 1024
				},
				radius = 350,
				position = {-200.0, -150.0}, 
				rotation_seconds = -180,
				surface_normal_intensity = 1.2,
				surface_vertical_offset = 0.0,
			}
		},
	},
})

-- If oxygen property is enabled, oxygen for Cerys is set to 0%, in line with Muluna's convention for planets intended to ban burner items.
if data.raw["surface-property"]["oxygen"] then
	data.raw["planet"]["cerys"].surface_properties["oxygen"] = 0
end

data:extend({
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
})