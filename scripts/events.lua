local radiative_towers = require("scripts.radiative-tower")
local rods = require("scripts.charging-rod")
local space = require("scripts.space")
local repair = require("scripts.repair")
local nuclear_reactor = require("scripts.nuclear-reactor")
local ice = require("scripts.ice")
local common = require("common")
local cargo_pods = require("scripts.cargo-pods")
local cryogenic_plant = require("scripts.cryogenic-plant")
local background = require("scripts.background")
local migrations = require("scripts.migrations")

-- Highest-level file besides control.lua.

script.on_configuration_changed(function()
	local surface = game.surfaces["cerys"]

	if not (surface and surface.valid) then
		return
	end

	if storage.cerys then -- Why this check? The surface could have been generated in a non-standard way, and if that is the case, we want to let on_chunk_generated initialize the cerys storage before doing anything else.
		if
			storage.cerys
			and not (storage.cerys.reactor and storage.cerys.reactor.entity and storage.cerys.reactor.entity.valid)
		then
			if not storage.cerys.initialization_version then
				game.print(
					"[Cerys-Moon-of-Fulgora] Cerys is missing the Fulgoran reactor. This happened due to an initialization bug in the mod when you first visited. To allow Cerys to regenerate, it is recommended to run /c game.delete_surface('cerys')"
				)
			end
		end

		migrations.run_migrations()
	end

	-- TODO: storage.cerys.last_seen_version
end)

script.on_event({
	defines.events.on_pre_surface_cleared,
	defines.events.on_pre_surface_deleted,
}, function(event)
	local surface_index = event.surface_index
	local surface = game.surfaces[surface_index]

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	storage.cerys = nil
end)

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

script.on_event(defines.events.on_player_changed_surface, function(event)
	local player = game.players[event.player_index]
	local new_surface = player.surface

	if new_surface.name == "cerys" then
		new_surface.request_to_generate_chunks({ 0, 0 }, (common.MOON_RADIUS * 2) / 32)
	end
end)

script.on_event(defines.events.on_tick, function(event)
	local tick = event.tick

	local surface = game.surfaces["cerys"]
	if not (surface and surface.valid) then
		return
	end

	if not storage.cerys then
		-- Something has gone wrong, so delete the surface to avoid play on a broken world.
		game.delete_surface("cerys")
		return
	end

	local move_solar_wind = true
	if settings.global["cerys-disable-solar-wind-when-not-looking-at-surface"].value then
		move_solar_wind = false
		for _, player in pairs(game.connected_players) do
			if player.surface.name == "cerys" then
				move_solar_wind = true
				break
			end
		end
	end

	background.tick_1_update_background_renderings()
	nuclear_reactor.tick_1_move_radiation(game.tick)
	radiative_towers.tick_1_move_radiative_towers(surface)
	cryogenic_plant.tick_1_check_cryo_quality_upgrades(surface)

	if move_solar_wind then
		space.tick_1_move_solar_wind()

		if tick % 2 == 0 then
			space.tick_2_try_spawn_solar_wind_particle(surface)
		end

		if tick % 8 == 0 then
			space.tick_8_solar_wind_collisions(surface)
		end

		if tick % 9 == 0 then
			space.tick_9_solar_wind_deflection()
		end
	end

	if common.DEBUG_MOON_START and tick == 30 then
		surface.request_to_generate_chunks({ 0, 0 }, (common.MOON_RADIUS * 2) / 32)
	end

	if tick % 2 == 0 then
		nuclear_reactor.tick_2_radiation(surface)
	end

	if tick % nuclear_reactor.REACTOR_TICK_INTERVAL == 0 then
		nuclear_reactor.tick_reactor(surface)
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

script.on_event(defines.events.on_player_joined_game, function(event)
	if common.DEBUG_MOON_START then
		local player = game.players[event.player_index]

		if player.controller_type == defines.controllers.cutscene then
			player.exit_cutscene()
		end

		player.force.technologies["moon-discovery-cerys"].research_recursive()
		player.force.technologies["recycling"].research_recursive()
		player.force.technologies["bulk-inserter"].research_recursive()
		player.force.technologies["railway"].research_recursive()
		player.force.technologies["uranium-ammo"].research_recursive()
		player.force.technologies["solar-energy"].research_recursive() -- if not for energy shield prerequisite, this tech might need to be a prerequisite
		player.force.technologies["steel-axe"].research_recursive()
		player.force.technologies["advanced-combinators"].research_recursive()
		player.force.technologies["electric-mining-drill"].research_recursive()
		player.force.technologies["radar"].research_recursive()
		player.force.technologies["construction-robotics"].research_recursive()
		player.force.technologies["electric-energy-distribution-2"].research_recursive()
		player.force.technologies["efficiency-module-2"].research_recursive()
		player.force.technologies["productivity-module-2"].research_recursive()
		player.force.technologies["speed-module-2"].research_recursive()
		player.force.technologies["quality-module-2"].research_recursive()
		player.force.technologies["toolbelt"].research_recursive()
		player.force.technologies["lamp"].research_recursive()
		player.force.technologies["mining-productivity-1"].research_recursive()
		player.force.technologies["laser"].research_recursive()
		player.force.technologies["physical-projectile-damage-6"].research_recursive()
		player.force.technologies["fission-reactor-equipment"].research_recursive()
		player.force.technologies["automation-3"].research_recursive()
		player.force.technologies["logistics-3"].research_recursive()
		player.force.technologies["nuclear-fuel-reprocessing"].research_recursive()
		player.force.technologies["effect-transmission"].research_recursive()
		player.force.technologies["electromagnetic-plant"].research_recursive()
		player.force.technologies["laser-turret"].research_recursive()
		player.force.technologies["repair-pack"].research_recursive()

		local surface = game.surfaces["cerys"]
		if surface and surface.valid and player.surface.name ~= "cerys" then
			local p = { x = 0, y = 0 }
			local p2 = surface.find_non_colliding_position("character", { x = 0, y = 0 }, 20, 0.5)
			player.teleport(p2 or p, surface)
			player.clear_items_inside()

			local armor = player.insert({ name = "power-armor", count = 1 })
			local inv = player.get_inventory(defines.inventory.character_armor)

			if armor > 0 and inv and inv.valid then
				local armor_item = inv[1]

				if armor_item and armor_item.valid then
					local grid = armor_item.grid
					if grid then
						grid.put({ name = "fission-reactor-equipment" })
						grid.put({ name = "exoskeleton-equipment" })
						grid.put({ name = "exoskeleton-equipment" })
						grid.put({ name = "personal-roboport-equipment" })
						grid.put({ name = "battery-mk2-equipment" })
						grid.put({ name = "battery-mk2-equipment" })
						grid.put({ name = "battery-mk2-equipment" })
						grid.put({ name = "battery-mk2-equipment" })
						grid.put({ name = "battery-mk2-equipment" })
						grid.put({ name = "battery-mk2-equipment" })
					end
				end
			end
		end
	end

	migrations.run_migrations()
end)
