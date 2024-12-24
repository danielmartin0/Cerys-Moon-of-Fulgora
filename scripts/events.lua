local radiative_towers = require("scripts.radiative-tower")
local rods = require("scripts.charging-rod")
local space = require("scripts.space")
local repair = require("scripts.repair")
local nuclear_reactor = require("scripts.nuclear-reactor")
local ice = require("scripts.ice")
local common = require("common")
local cargo_pods = require("scripts.cargo-pods")
local cryogenic_plant = require("scripts.cryogenic-plant")
local init = require("scripts.init")

local Private = {}

script.on_event({
	defines.events.on_built_entity,
	defines.events.on_robot_built_entity,
	defines.events.on_space_platform_built_entity,
}, function(event)
	local entity = event.entity
	if not (entity and entity.valid) then
		return
	end

	if entity.name == "cerys-fulgoran-radiative-tower" then
		radiative_towers.register_heating_tower(entity)
	end

	if entity.name == "charging-rod" then
		if event.robot then
			rods.robot_built_charging_rod(entity, event.tags or {})
		else
			rods.built_charging_rod(entity, event.tags or {})
		end
	end

	if entity.name == "entity-ghost" and entity.ghost_name == "charging-rod" then
		rods.built_ghost_charging_rod(entity, entity.tags)
	end

	if entity.name == "cerys-fulgoran-reactor-scaffold" and event.name == defines.events.on_built_entity then
		if not event.player_index then
			return
		end

		local player = game.connected_players[event.player_index]

		if not (player and player.valid) then
			return
		end

		repair.scaffold_on_build(entity, player)
	end
end)

script.on_event(defines.events.on_pre_build, function(event)
	local player = game.get_player(event.player_index)
	local cursor_stack = player.cursor_stack
	if cursor_stack and cursor_stack.valid_for_read then
		local item_name = cursor_stack.name

		if item_name == "cerys-fulgoran-reactor-scaffold" then
			repair.scaffold_on_pre_build(event)
		end
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	local research = event.research
	if research.name == "cerys-fulgoran-cryogenics" then
		research.force.recipes["cerys-discover-fulgoran-cryogenics"].enabled = false
	end
end)

script.on_event(defines.events.on_tick, function(event)
	local tick = event.tick

	local surface = game.surfaces["cerys"]
	if not (surface and surface.valid) then
		return
	end

	if not storage.cerys then
		init.initialize_cerys(surface)
	end

	Private.tick_1_update_background_renderings()
	space.tick_1_move_solar_wind()
	nuclear_reactor.tick_1_move_radiation(game.tick)
	radiative_towers.tick_1_move_radiative_towers(surface)
	cryogenic_plant.tick_1_check_cryo_quality_upgrades(surface)

	if common.DEBUG_MOON_START and tick == 30 then
		surface.request_to_generate_chunks({ 0, 0 }, (common.MOON_RADIUS * 2) / 32)
	end

	if tick % 2 == 0 then
		space.tick_2_try_spawn_solar_wind_particle(surface)
		nuclear_reactor.tick_2_radiation(surface)
	end

	if tick % nuclear_reactor.REACTOR_TICK_INTERVAL == 0 then
		nuclear_reactor.tick_reactor(surface)
	end

	if tick % 10 == 0 then
		space.tick_10_solar_wind_collisions(surface)
	end

	if tick % 9 == 0 then
		space.tick_9_solar_wind_deflection()
	end

	if tick % 10 == 0 then
		cargo_pods.tick_10_check_cargo_pods()
	end

	if tick % 15 == 0 then
		cryogenic_plant.tick_15_check_cryo_quality_upgrades(surface)
		-- Ideally, match the tick interval of the repair recipes:
		repair.tick_15_check_broken_cryo_plants(surface)
		repair.tick_15_nuclear_reactor_repair_check(surface)
	end

	if tick % radiative_towers.TOWER_CHECK_INTERVAL == 0 then
		radiative_towers.tick_towers(surface)
	end

	if tick % 60 == 0 then
		space.spawn_asteroid(surface)
	end

	if tick % 20 == 0 then
		local player_on_surface = false
		for _, player in pairs(game.connected_players) do
			if
				not player_on_surface
				and player
				and player.valid
				and player.surface
				and player.surface.valid
				and player.surface.index == surface.index
			then
				player_on_surface = true
			elseif
				not player_on_surface
				and player
				and player.valid
				and player.character
				and player.character.valid
				and player.character.surface
				and player.character.surface.valid
				and player.character.surface.index == surface.index
			then
				player_on_surface = true
			end
		end
		if player_on_surface then
			radiative_towers.tick_20_contracted_towers(surface)

			if tick % ice.ICE_CHECK_INTERVAL == 0 then
				ice.tick_ice(surface)
			end
		end
	end

	if tick % 240 == 0 then
		space.tick_240_clean_up_cerys_asteroids()
		space.tick_240_clean_up_cerys_solar_wind_particles()
	end

	if tick % 520 == 0 then
		rods.tick_520_cleanup_charging_rods()
	end
end)

local PLANET_OFFSET = { x = 50, y = -30 }
local PLANET_PARALLAX = 0.35

function Private.tick_1_update_background_renderings()
	for _, player in pairs(game.connected_players) do
		if not (player and player.valid) then
			storage.background_renderings[player.index] = nil
		else
			local on_cerys = player.surface.name == "cerys"
			local r = storage.background_renderings[player.index]

			if on_cerys then
				if not r then
					storage.background_renderings[player.index] = rendering.draw_sprite({
						sprite = "fulgora-background",
						target = { x = player.position.x + PLANET_OFFSET.x, y = player.position.y + PLANET_OFFSET.y },
						surface = player.surface,
						render_layer = "zero",
						players = { player.index },
					})

					r = storage.background_renderings[player.index]
				end

				if r.valid then
					r.target = {
						x = player.position.x * PLANET_PARALLAX + PLANET_OFFSET.x,
						y = player.position.y * PLANET_PARALLAX + PLANET_OFFSET.y,
					}
				else
					r.destroy()
					storage.background_renderings[player.index] = nil
				end
			elseif r then
				if r.valid then
					r.destroy()
				end
				storage.background_renderings[player.index] = nil
			end
		end
	end
end
