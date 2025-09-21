local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local merge = require("lib").merge
local common = require("common")

data:extend({
	{
		type = "assembling-machine",
		name = "cerys-solar-ghost-maker",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/solar-ghost-maker.png",
		icon_size = 128,
		flags = { "placeable-neutral", "placeable-player", "player-creation" },
		minable = { mining_time = 0.05, result = "cerys-solar-ghost-maker" },
		max_health = 80,
		corpse = "lightning-rod-remnants",
		dying_explosion = "medium-electric-pole-explosion",
		-- icon_draw_specification = { shift = { 0, -0.3 } },
		collision_box = { { -0.15, -0.15 }, { 0.15, 0.15 } },
		selection_box = { { -0.5, -0.6 }, { 0.5, 0.5 } },
		damaged_trigger_effect = hit_effects.entity({ { -0.2, -2.2 }, { 0.2, 0.2 } }),
		fast_replaceable_group = "cerys-solar-ghost-maker",
		factoriopedia_simulation = {
			length = 240,
			init = [[
				require("__core__/lualib/story")
				game.simulation.camera_zoom = 2.7
				game.simulation.camera_position = {0, -1}
				game.surfaces[1].create_entity{name = "cerys-solar-ghost-maker", position = {-0.5 + (math.random() - 0.5), -0.5 + (math.random() - 0.5)}}

				storage.cerys = {}
				storage.cerys.solar_wind_particles = {}
			]],
			update = [[
            	for _, particle in pairs(storage.cerys.solar_wind_particles) do
					local r = particle.rendering
					local v = particle.velocity
					local p = { x = r.target.position.x + v.x, y = r.target.position.y + v.y }

                	r.target = p
            	end

				if game.tick % 60 == 0 then
					local r = rendering.draw_sprite({
						sprite = "cerys-solar-wind-particle-ghost",
						target = { x = 0.1, y = -1.94 },
						surface = game.surfaces[1],
						render_layer = "air-object",
					})

					local spd = ]] .. common.PARTICLE_SIMULATION_SPEED .. [[
					local x_velocity = 0.15 * spd + math.random() * 0.1 / 3 * spd
					local y_velocity = 0.2 * (math.random() - 0.5) ^ 3 * spd

					table.insert(storage.cerys.solar_wind_particles, {
						rendering = r,
						velocity = { x = x_velocity, y = y_velocity },
					})
				end
        	]],
		},
		drawing_box_vertical_extension = 1.5,
		graphics_set = {
			animation = {
				layers = {
					util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/solar-ghost-maker/111", {
						priority = "high",
						scale = 0.19,
						repeat_count = 1,
					}),
					util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/solar-ghost-maker/111shadow", {
						priority = "high",
						draw_as_shadow = true,
						scale = 0.19,
						repeat_count = 1,
					}),
				},
			},
		},
		crafting_categories = { "cerys-make-solar-wind-ghosts" },
		fixed_recipe = "cerys-make-solar-wind-ghosts",
		crafting_speed = 1,
		energy_source = {
			type = "void",
		},
		energy_usage = "10kW",
		module_slots = 0,
		open_sound = sounds.inserter_open,
		close_sound = sounds.inserter_close,
		allowed_effects = { "speed" },
		effect_receiver = { uses_module_effects = true, uses_beacon_effects = true, uses_surface_effects = false },
		surface_conditions = {
			common.AMBIENT_RADIATION_MIN,
		},
		circuit_connector = circuit_connector_definitions.create_vector(universal_connector_template, {
			{
				variation = 24,
				main_offset = util.by_pixel(-5.125, -29),
				shadow_offset = util.by_pixel(-5.125, -29),
				show_shadow = true,
			},
			{
				variation = 24,
				main_offset = util.by_pixel(-5.125, -29),
				shadow_offset = util.by_pixel(-5.125, -29),
				show_shadow = true,
			},
			{
				variation = 24,
				main_offset = util.by_pixel(-5.125, -29),
				shadow_offset = util.by_pixel(-5.125, -29),
				show_shadow = true,
			},
			{
				variation = 24,
				main_offset = util.by_pixel(-5.125, -29),
				shadow_offset = util.by_pixel(-5.125, -29),
				show_shadow = true,
			},
		}),
		circuit_wire_max_distance = default_circuit_wire_max_distance,
	},
})
