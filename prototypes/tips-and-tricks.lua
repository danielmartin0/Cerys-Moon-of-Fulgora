data:extend({
	{
		type = "tips-and-tricks-item",
		name = "cerys-briefing",
		category = "space-age",
		tag = "[planet=cerys]",
		indent = 0,
		order = "a-z-b[Cerys]",
		trigger = {
			type = "research",
			technology = "moon-discovery-cerys",
		},
		skip_trigger = {
			type = "or",
			triggers = {
				{
					type = "change-surface",
					surface = "cerys",
				},
			},
		},
		simulation = {
			init_update_count = 10,
			planet = "cerys",
			generate_map = false,
			init = [[

			game.simulation.camera_position = { 0.5,0.5 }

			for x = -11, 11 do
				for y = -6, 6 do
					game.surfaces[1].set_tiles({ { position = { x, y }, name = "cerys-dry-ice-on-land" } })
				end
			end

			rendering.draw_sprite({
				sprite = "fulgora-background",
				target = {
					x = -25,
					y = -33,
				},
				surface = game.surfaces[1],
				render_layer = "zero",
				x_scale = 0.5,
				y_scale = 0.5,
			})

			local y_to_empty_space_spots = {
				[-4] = 0,
				[-3] = 0,
				[-2] = 2,
				[-1] = 3,
				[0] = 4,
				[1] = 6,
				[2] = 8,
				[3] = 9,
				[4] = 10,
				[5] = 13,
				[6] = 16,
			}
			for y, num in pairs(y_to_empty_space_spots) do
				for x = 11, 11 - num, -1 do
					game.surfaces[1].set_tiles({
						{ position = { x, y }, name = "cerys-empty-space-2" },
					})
				end
			end

			game.surfaces[1].create_entity{name = "cerys-hidden-reactor-14", position = {0, 0}}

			for x = -11, -5 do
				for y = -6, -5 do
					game.surfaces[1].set_tiles({ { position = { x, y }, name = "cerys-ash-dark" } })
				end
			end

			game.surfaces[1].create_entity{name="cerys-ruin-big", position = {-1, -4}}
			game.surfaces[1].create_entity{name="cerys-ruin-medium", position = {-8, -1}}
			game.surfaces[1].create_entity{name="cerys-methane-iceberg-big", position = {7, -3}}
			game.surfaces[1].create_entity{name="cerys-methane-iceberg-big", position = {9, -5}}

			game.surfaces[1].create_decoratives{decoratives = {{name = "cerys-ruin-tiny", position = {4, -1}}}}
			game.surfaces[1].create_decoratives{decoratives = {{name = "cerys-ruin-tiny", position = {3, -4}}}}
			game.surfaces[1].create_decoratives{decoratives = {{name = "cerys-ruin-tiny", position = {0, 0}}}}
			
			game.surfaces[1].create_entity{name = "cerys-nuclear-scrap", amount = 50, position = {-3, 2}}
			game.surfaces[1].create_entity{name = "cerys-nuclear-scrap", amount = 100000000, position = {-5, 3}}
			game.surfaces[1].create_entity{name = "cerys-nuclear-scrap", amount = 50, position = {-6, 3}}
			game.surfaces[1].create_entity{name = "cerys-nuclear-scrap", amount = 100000000, position = {-7, 4}}
			game.surfaces[1].create_entity{name = "cerys-nuclear-scrap", amount = 100000000, position = {-8, 4}}
			game.surfaces[1].create_entity{name = "cerys-nuclear-scrap", amount = 50, position = {-9, 4}}

			storage.cerys = {}
			storage.cerys.solar_wind_particles = {}

			local particle_positions = {
				{ x = -95, y = -4 },
				{ x = -38, y = -3 },
				{ x = -51, y = -1 },
				{ x = -83, y = 0 },
				{ x = -119, y = 3 },
				{ x = -9, y = 4 },
			}

			for i, position in pairs(particle_positions) do
				local r = rendering.draw_sprite({
					sprite = "cerys-solar-wind-particle",
					target = { x = position.x, y = position.y },
					surface = game.surfaces[1],
					render_layer = "air-object",
					x_scale = 0.8,
					y_scale = 0.8,
				})

				table.insert(storage.cerys.solar_wind_particles, {
					rendering = r,
					initial_position = position,
				})
			end
        ]],
			update = [[
            for _, particle in pairs(storage.cerys.solar_wind_particles) do
                particle.rendering.target = { x = particle.initial_position.x + 0.15 * (game.tick % 900), y = particle.initial_position.y }
            end
        ]],
			checkboard = false,
			mute_wind_sounds = true,
		},
		-- },
		-- simulation = {
		-- 	planet = "cerys",
		-- 	generate_map = false,
		-- 	init = [[
		--     game.simulation.camera_position = {0, 1.5}

		--     for x = -12, 12, 1 do
		--         for y = -6, 6 do
		--             game.surfaces[1].set_tiles{{position = {x, y}, name = "sand-1-underwater"}}
		--         end
		--     end

		--     game.surfaces[1].create_entity {
		--         name = "maraxsis-water-shader",
		--         position = {0, 0},
		--         create_build_effect_smoke = false
		--     }

		--     for _, cliff_info in pairs {
		--         {position = {-2, 2.5}, orientation = "north-to-east"},
		--         {position = {-2, -1.5}, orientation = "west-to-south"},
		--         {position = {-6, -1.5}, orientation = "north-to-east"},
		--         {position = {-6, -5.5}, orientation = "west-to-south"},
		--         {position = {-10, -5.5}, orientation = "north-to-east"},
		--         {position = {-10, -9.5}, orientation = "west-to-south"},
		--         {position = {-14, -9.5}, orientation = "none-to-east"},
		--         {position = {2, 2.5}, orientation = "west-to-east"},
		--         {position = {6, 2.5}, orientation = "west-to-east"},
		--         {position = {10, 2.5}, orientation = "west-to-east"},
		--         {position = {14, 2.5}, orientation = "west-to-east"},
		--         {position = {18, 2.5}, orientation = "west-to-east"},
		--         {position = {22, 2.5}, orientation = "west-to-none"},
		--     } do
		--         local position = cliff_info.position
		--         position = {position[1], position[2] - 2}
		--         game.surfaces[1].create_entity {
		--             name = "cliff-maraxsis",
		--             position = position,
		--             cliff_orientation = cliff_info.orientation,
		--             create_build_effect_smoke = false
		--         }
		--     end

		--     game.surfaces[1].create_entity {
		--         name = "maraxsis-tropical-fish-10",
		--         position = {-5, 3},
		--         create_build_effect_smoke = false
		--     }

		--     game.surfaces[1].create_entity {
		--         name = "maraxsis-tropical-fish-5",
		--         position = {4, -2},
		--         create_build_effect_smoke = false
		--     }

		--     game.surfaces[1].create_entity {
		--         name = "maraxsis-tropical-fish-9",
		--         position = {1, 8},
		--         create_build_effect_smoke = false
		--     }.orientation = 0.24

		--     local create_list = {}
		--     table.insert(create_list, { name = "waves-decal", position = {6, -6}, amount = 1})
		--     for k, position in pairs {{-10, -3}, {-8, -3}, {4, -3}, {8, 1}} do
		--         table.insert(create_list, { name = "v-brown-carpet-grass", position = position, amount = 1})
		--     end
		--     for k, position in pairs {{-10, 2},{-8, 3}, {-7, 3}, {5, 3}, {7, 3}, {3, 4}, {6, 4}, {1, 5}} do
		--         table.insert(create_list, { name = "yellow-lettuce-lichen-cups-3x3", position = position, amount = 1})
		--     end
		--     for k, position in pairs {{-1, 7}, {-2, 8}, {-3, 4}, {0, 3}, {8, 4}} do
		--         table.insert(create_list, { name = "honeycomb-fungus-1x1", position = position, amount = 1})
		--     end
		--     for x = -12, -6, 1 do
		--         for y = -6, -2 do
		--             table.insert(create_list, { name = "polycephalum-slime", position = {x, y}, amount = 1})
		--         end
		--     end
		--     game.surfaces[1].create_decoratives{decoratives = create_list}
		-- ]],
		-- 	checkboard = false,
		-- 	mute_wind_sounds = false,
		-- },
	},
})

data:extend({
	{
		type = "tips-and-tricks-item",
		name = "cerys-plutonium-generation",
		category = "space-age",
		tag = "[item=plutonium-239]",
		indent = 1,
		order = "a-z-b[Cerys]-b",
		trigger = {
			type = "research",
			technology = "cerys-applications-of-radioactivity",
		},
		dependencies = { "cerys-briefing" },
	},
})
