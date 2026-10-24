local common = require("common")

local menu_simulations = {}

menu_simulations.cerys_radiative_tower = {
	checkboard = false,
	save = "__Cerys-Moon-of-Fulgora__/menu-simulations/cerys1.zip",
	length = 60 * 20,
	mods = { "Cerys-Moon-of-Fulgora" },
	init = [[
		local sim_planet = game.surfaces["cerys"]
		game.simulation.camera_surface_index = sim_planet.index
		game.simulation.camera_position = {2.5, 18.5}
		game.simulation.camera_zoom = 0.906
		game.tick_paused = false
		game.players[1].gui.screen.visible = false
		
		local character = sim_planet.find_entities_filtered{name = "character", force = "player", limit = 1}[1]
		if not character then
			character = sim_planet.create_entity{
				name = "character",
				position = {-16, 29},
				force = "player"
			}
		end
		
		local tick = 0
		script.on_nth_tick(1, function()
			tick = tick + 1
			
			if tick == 60 then
				character.walking_state = {walking = true, direction = defines.direction.east}
			end
			
			if tick == 175 then
				character.walking_state = {walking = false}
			end
			
			if tick == 200 then
				sim_planet.create_entity{name = "steel-chest", position = {-4, 31}, force = "player"}
				sim_planet.play_sound{path = "entity-build/steel-chest", position = {-4, 31}}
			end
			
			if tick == 220 then
				sim_planet.create_entity{name = "inserter", position = {-3, 31}, direction = defines.direction.east, force = "player"}
				sim_planet.play_sound{path = "entity-build/inserter", position = {-3, 31}}
			end
			
			if tick == 240 then sim_planet.create_entity{name = "transport-belt", position = {-2, 31}, direction = defines.direction.west, force = "player"} sim_planet.play_sound{path = "entity-build/transport-belt", position = {-2, 31}} end
			if tick == 245 then sim_planet.create_entity{name = "transport-belt", position = {-1, 31}, direction = defines.direction.west, force = "player"} sim_planet.play_sound{path = "entity-build/transport-belt", position = {-1, 31}} end
			if tick == 250 then sim_planet.create_entity{name = "transport-belt", position = {0, 31}, direction = defines.direction.west, force = "player"} sim_planet.play_sound{path = "entity-build/transport-belt", position = {0, 31}} end
			if tick == 255 then sim_planet.create_entity{name = "transport-belt", position = {1, 31}, direction = defines.direction.west, force = "player"} sim_planet.play_sound{path = "entity-build/transport-belt", position = {1, 31}} end
			if tick == 260 then sim_planet.create_entity{name = "transport-belt", position = {2, 31}, direction = defines.direction.west, force = "player"} sim_planet.play_sound{path = "entity-build/transport-belt", position = {2, 31}} end
			
			if tick == 280 then
				sim_planet.create_entity{name = "inserter", position = {3, 31}, direction = defines.direction.east, force = "player"}
				sim_planet.play_sound{path = "entity-build/inserter", position = {3, 31}}
			end
			
			if tick == 330 then
				sim_planet.create_entity{name = "substation", position = {2.5, 29.5}, force = "player"}
				sim_planet.play_sound{path = "entity-build/substation", position = {2.5, 29.5}}
			end
		end)
	]]
}

menu_simulations.cerys_asteroids = {
	checkboard = false,
	save = "__Cerys-Moon-of-Fulgora__/menu-simulations/cerys2.zip",
	length = 60 * 20,
	mods = { "Cerys-Moon-of-Fulgora" },
	init = [[
		local sim_planet = game.surfaces["cerys"]
		game.simulation.camera_surface_index = sim_planet.index
		game.simulation.camera_position = {4.5, -122.5}
		game.simulation.camera_zoom = 0.8
		game.tick_paused = false
		game.players[1].gui.screen.visible = false
	]]
}

menu_simulations.cerys_research = {
	checkboard = false,
	save = "__Cerys-Moon-of-Fulgora__/menu-simulations/cerys3.zip",
	length = 60 * 20,
	mods = { "Cerys-Moon-of-Fulgora" },
	init = [[
		local sim_planet = game.surfaces["cerys"]
		game.simulation.camera_surface_index = sim_planet.index
		game.simulation.camera_position = {-11.5, 73.5}
		game.simulation.camera_zoom = 0.906
		game.tick_paused = false
		game.players[1].gui.screen.visible = false
	]]
}

local constants = data.raw["utility-constants"]["default"]

if common.DEBUG_ONLY_CERYS_MENU_SIMULATIONS or not constants.main_menu_simulations then
	constants.main_menu_simulations = {}
end

for name, simulation in pairs(menu_simulations) do
	constants.main_menu_simulations[name] = simulation
end
