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
			orientation = 0.49,
			sprite = {
				type = "sprite",
				filename = "__Cerys-Moon-of-Fulgora__/graphics/icons/orbit.png",
				size = 379,
				scale = 0.25,
			},
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
