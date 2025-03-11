local lib = require("lib")
local radiative_towers = require("scripts.radiative-tower")
local rods = require("scripts.charging-rod")
local space = require("scripts.space")
local repair = require("scripts.reactor-repair")
local nuclear_reactor = require("scripts.nuclear-reactor")
local ice = require("scripts.ice")
local common = require("common")
local cryogenic_plant = require("scripts.cryogenic-plant")
local background = require("scripts.background")
local init = require("scripts.init")
local cooling = require("scripts.cooling")
local crusher = require("scripts.crusher")
local pre_blueprint_pasted = require("scripts.pre_blueprint_pasted")
local lighting = require("scripts.lighting")
local picker_dollies = require("compat.picker-dollies")

local Public = {}

-- Highest-level file besides control.lua.

script.on_event({
	defines.events.on_built_entity,
	defines.events.on_robot_built_entity,
	defines.events.on_space_platform_built_entity,
	defines.events.script_raised_built,
	defines.events.script_raised_revive,
}, function(event)
	local entity = event.entity
	if not (entity and entity.valid) then
		return
	end

	local on_cerys = entity.surface and entity.surface.valid and entity.surface.name == "cerys"

	if on_cerys and entity.type == "tile-ghost" then
		local tile = entity.surface.get_tile(entity.position.x, entity.position.y)
		if tile and lib.find(common.SPACE_TILES_AROUND_CERYS, tile.name) then
			entity.destroy()
			return
		end
	end

	if entity.name == "cerys-fulgoran-radiative-tower" or entity.name == "cerys-fulgoran-radiative-tower-frozen" then
		radiative_towers.register_radiative_tower(entity)
	elseif on_cerys and entity.name == "cerys-charging-rod" then
		rods.built_charging_rod(entity, event.tags or {})
	elseif entity.name == "cerys-fulgoran-reactor-scaffold" and event.name == defines.events.on_built_entity then
		if not event.player_index then
			return
		end

		local player = game.players[event.player_index]

		if not (player and player.valid) then
			return
		end

		repair.scaffold_on_build(entity, player)
	elseif entity.name == "cerys-fulgoran-crusher" or entity.name:match("^cerys%-fulgoran%-crusher%-quality%-") then
		crusher.register_crusher(entity)
	elseif on_cerys and entity.type == "solar-panel" then
		lighting.register_solar_panel(entity)
	end
end)

script.on_event(defines.events.on_pre_build, function(event)
	local player = game.get_player(event.player_index)
	local cursor_stack = player.cursor_stack

	pre_blueprint_pasted.on_pre_build(event)

	if cursor_stack and cursor_stack.valid_for_read then
		local item_name = cursor_stack.name

		if item_name == "cerys-fulgoran-reactor-scaffold" then
			repair.scaffold_on_pre_build(event)
		end
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	local research = event.research

	-- if not settings.startup["cerys-technology-compatibility-mode"].value then
	if research.name == "cerys-fulgoran-cryogenics" then
		research.force.recipes["cerys-discover-fulgoran-cryogenics"].enabled = false
	elseif research.name == "cerys-nuclear-scrap-recycling" then
		-- This usually shouldn't be necessary, but in case the player has reset their technologies, we take the opportunity here to undo the above.
		research.force.recipes["cerys-discover-fulgoran-cryogenics"].enabled = true
	end
	-- end
end)

script.on_event(defines.events.on_player_changed_surface, function(event)
	local player = game.players[event.player_index]
	local new_surface = player.surface

	if new_surface.name == "cerys" then
		if storage.cerys and not storage.cerys.first_visit_tick then
			storage.cerys.first_visit_tick = game.tick

			new_surface.request_to_generate_chunks({ 0, 0 }, common.get_cerys_semimajor_axis(new_surface) * 2 / 32)
		end
	end
end)

script.on_event(defines.events.on_tick, function(event)
	local tick = event.tick

	radiative_towers.tick_1_move_radiative_towers()

	if tick % 20 == 0 then
		radiative_towers.tick_20_contracted_towers()
	end

	if tick % radiative_towers.TOWER_TEMPERATURE_TICK_INTERVAL == 0 then
		radiative_towers.radiative_heaters_temperature_tick()
	end

	local surface
	if storage.cerys then
		surface = game.get_surface("cerys")
		if surface and surface.valid then
			Public.cerys_tick(surface, tick)
		end
	end

	if tick % (60 * 15) == 0 then
		surface = surface or game.surfaces["cerys"]
		local valid = surface and surface.valid

		if valid and not storage.cerys then
			-- Something has gone wrong, so delete the surface to avoid play on a broken world.
			game.delete_surface("cerys")
		end
	end
end)

function Public.cerys_tick(surface, tick)
	local player_looking_at_surface = false
	local player_on_surface = false

	for _, player in pairs(game.connected_players) do
		if player.surface == surface then
			player_looking_at_surface = true
		end

		if player.physical_surface == surface then
			player_on_surface = true
		end
	end

	local solar_wind_tick_multiplier = player_looking_at_surface and 1 or 12

	background.tick_1_update_background_renderings(surface)
	nuclear_reactor.tick_1_move_radiation(game.tick)
	cryogenic_plant.tick_1_check_cryo_quality_upgrades(surface)
	crusher.tick_1_check_crusher_quality_upgrades(surface)

	if tick % 3 == 0 then
		lighting.tick_3_update_lights()
	end

	if
		player_looking_at_surface or not settings.global["cerys-disable-solar-wind-when-not-looking-at-surface"].value
	then
		if tick % (1 * solar_wind_tick_multiplier) == 0 then
			space.tick_1_move_solar_wind()
		end

		if tick % (8 * solar_wind_tick_multiplier) == 0 then
			space.tick_8_solar_wind_collisions(surface, solar_wind_tick_multiplier)
		end

		if tick % (space.SOLAR_WIND_DEFLECTION_TICK_INTERVAL * solar_wind_tick_multiplier) == 0 then
			space.tick_solar_wind_deflection()
		end

		if tick % (9 * solar_wind_tick_multiplier) == 0 then
			local spawn_chance = 0.3375 * settings.global["cerys-solar-wind-spawn-rate-percentage"].value / 100
			if math.random() < spawn_chance then
				space.spawn_solar_wind_particle(surface)
			end
		end

		if tick % (12 * solar_wind_tick_multiplier) == 0 then
			rods.tick_12_check_charging_rods()
		end
	end

	if (common.DEBUG_CERYS_START or settings.startup["cerys-start-on-cerys"].value) and tick == 30 then
		surface.request_to_generate_chunks({ 0, 0 }, common.get_cerys_semimajor_axis(surface) * 2 / 32)
	end

	if player_looking_at_surface and tick % 2 == 0 then
		nuclear_reactor.tick_2_radiation(surface)
	end

	if tick % nuclear_reactor.REACTOR_TICK_INTERVAL == 0 then
		nuclear_reactor.tick_reactor(surface, player_looking_at_surface)
	end

	if tick % 15 == 0 then
		-- Ideally, match the tick interval of the repair recipes:
		cryogenic_plant.tick_15_check_broken_cryo_plants(surface)
		crusher.tick_15_check_broken_crushers(surface)
		repair.tick_15_nuclear_reactor_repair_check(surface)
	end

	if tick % 20 == 0 then
		cryogenic_plant.tick_20_check_cryo_quality_upgrades(surface)
		crusher.tick_20_check_crusher_quality_upgrades(surface)
	end

	if tick % 60 == 0 then
		space.try_spawn_asteroid(surface)
		cooling.tick_60_cool_heat_entities()
		Public.check_thankyou_toast(surface)
	end

	if (player_looking_at_surface or player_on_surface) and tick % ice.ICE_CHECK_INTERVAL == 0 then
		ice.tick_ice(surface)
	end

	if tick % 240 == 0 then
		space.tick_240_clean_up_cerys_asteroids(surface)
		space.tick_240_clean_up_cerys_solar_wind_particles(surface)
	end

	if tick % 300 == 0 then
		cooling.tick_300_find_heat_entities(surface)
	end
end

script.on_event(defines.events.on_script_trigger_effect, function(event)
	local effect_id = event.effect_id

	if effect_id == "cerys-fulgoran-radiative-tower-contracted-container" then
		local entity = event.target_entity

		if not (entity and entity.valid) then
			return
		end

		radiative_towers.register_radiative_tower_contracted(entity)
	elseif effect_id == "cerys-fulgoran-crusher-created" then
		local entity = event.target_entity
		if entity and entity.valid then
			crusher.register_crusher(entity)
		end
	elseif effect_id == "cerys-player-radiative-tower-created" then
		local entity = event.target_entity
		if entity and entity.valid then
			radiative_towers.register_player_radiative_tower(entity)
		end
	end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
	local player = game.players[event.player_index]

	storage.players_seen = storage.players_seen or {}

	if
		(common.DEBUG_CERYS_START or settings.startup["cerys-start-on-cerys"].value)
		and not storage.players_seen[player.index]
	then
		storage.players_seen[player.index] = true

		if player.controller_type == defines.controllers.cutscene then
			player.exit_cutscene()
		end

		player.force.technologies["advanced-combinators"].research_recursive()
		player.force.technologies["atomic-bomb"].research_recursive()
		player.force.technologies["automated-rail-transportation"].research_recursive()
		player.force.technologies["automation-3"].research_recursive()
		player.force.technologies["battery-equipment"].research_recursive()
		player.force.technologies["belt-immunity-equipment"].research_recursive()
		player.force.technologies["braking-force-2"].research_recursive()
		player.force.technologies["bulk-inserter"].research_recursive()
		player.force.technologies["construction-robotics"].research_recursive()
		player.force.technologies["discharge-defense-equipment"].research_recursive()
		player.force.technologies["effect-transmission"].research_recursive()
		player.force.technologies["efficiency-module-2"].research_recursive()
		player.force.technologies["electric-energy-distribution-2"].research_recursive()
		player.force.technologies["electric-mining-drill"].research_recursive()
		player.force.technologies["elevated-rail"].research_recursive()
		player.force.technologies["exoskeleton-equipment"].research_recursive()
		player.force.technologies["fission-reactor-equipment"].research_recursive()
		player.force.technologies["fluid-wagon"].research_recursive()
		player.force.technologies["gate"].research_recursive()
		player.force.technologies["gun-turret"].research_recursive()
		player.force.technologies["inserter-capacity-bonus-3"].research_recursive()
		player.force.technologies["lamp"].research_recursive()
		player.force.technologies["land-mine"].research_recursive()
		player.force.technologies["laser-shooting-speed-3"].research_recursive()
		player.force.technologies["logistics-3"].research_recursive()
		player.force.technologies["mining-productivity-2"].research_recursive()
		player.force.technologies["moon-discovery-cerys"].research_recursive()
		player.force.technologies["night-vision-equipment"].research_recursive()
		player.force.technologies["nuclear-fuel-reprocessing"].research_recursive()
		player.force.technologies["personal-roboport-equipment"].research_recursive()
		player.force.technologies["physical-projectile-damage-6"].research_recursive()
		player.force.technologies["productivity-module-2"].research_recursive()
		player.force.technologies["quality-module-2"].research_recursive()
		player.force.technologies["radar"].research_recursive()
		player.force.technologies["recycling"].research_recursive()
		player.force.technologies["repair-pack"].research_recursive()
		player.force.technologies["research-speed-2"].research_recursive()
		player.force.technologies["solar-energy"].research_recursive()
		player.force.technologies["speed-module-2"].research_recursive()
		player.force.technologies["steel-axe"].research_recursive()
		player.force.technologies["stronger-explosives-3"].research_recursive()
		player.force.technologies["toolbelt"].research_recursive()
		player.force.technologies["uranium-ammo"].research_recursive()
		player.force.technologies["weapon-shooting-speed-4"].research_recursive()
		player.force.technologies["worker-robots-speed-2"].research_recursive()
		player.force.technologies["worker-robots-storage-2"].research_recursive()
		-- player.force.technologies["moon-discovery-cerys"].researched = true

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
end)

-- It seems to be impossible to prevent this with collision masks:
script.on_event({
	defines.events.on_robot_built_tile,
	defines.events.on_player_built_tile,
}, function(event)
	local surface = game.surfaces[event.surface_index]
	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	local tiles = event.tiles
	for _, tile in pairs(tiles) do
		local hidden_tile = surface.get_hidden_tile(tile.position)
		if hidden_tile == "cerys-empty-space-2" or hidden_tile == "cerys-empty-space-3" then
			surface.set_tiles({ {
				name = hidden_tile,
				position = tile.position,
			} }, true)

			if event.player_index then
				local player = game.get_player(event.player_index)
				if player and player.valid and event.item then
					player.insert({ name = event.item.name, count = 1, quality = event.quality.name })
				end
			end
		end
	end
end)

script.on_configuration_changed(function()
	local surface = game.surfaces["cerys"]

	if surface and surface.valid then
		if storage.cerys then -- Why this check? The surface could have been generated in a non-standard way, and if that is the case, we want to let on_chunk_generated initialize the cerys storage before doing anything else.
			if not (storage.cerys.reactor and storage.cerys.reactor.entity and storage.cerys.reactor.entity.valid) then
				nuclear_reactor.register_reactor_if_missing(surface)

				if
					not (storage.cerys.reactor and storage.cerys.reactor.entity and storage.cerys.reactor.entity.valid)
				then
					init.create_reactor(surface)
				end
			end
		end
	end

	picker_dollies.add_picker_dollies_blacklists()
end)

function Public.check_thankyou_toast(surface)
	if storage.thankyou_message_timer and game.tick >= storage.thankyou_message_timer then
		storage.thankyou_message_timer = nil

		if settings.global["cerys-disable-kofi-toast"].value then
			return
		end

		surface.print({
			"",
			"[font=default-game] >>",
			{ "cerys.kofi-toast" },
			"[/font]",
		}, { color = { 164, 135, 255 } })
	end
end

script.on_event(defines.events.on_rocket_launch_ordered, function(event)
	if storage.thankyou_message_triggered then
		return
	end

	if
		not (
			event.rocket
			and event.rocket.valid
			and event.rocket.name ~= "planet-hopper"
			and event.rocket.surface
			and event.rocket.surface.valid
			and event.rocket.surface.name == "cerys"
			and event.rocket.cargo_pod
			and event.rocket.cargo_pod.valid
			and event.rocket.cargo_pod.get_passenger()
		)
	then
		return
	end

	local player = event.rocket.cargo_pod.get_passenger().player
	if not (player and player.valid) then
		return
	end

	storage.thankyou_message_triggered = true
	storage.thankyou_message_timer = game.tick + 5 * 60
end)

local function unresearch_successors(tech)
	for _, successor in pairs(tech.successors) do
		if successor.researched then
			successor.researched = false
		end
		unresearch_successors(successor)
	end
end

script.on_event({
	defines.events.on_pre_surface_cleared,
	defines.events.on_pre_surface_deleted,
}, function(event)
	local surface_index = event.surface_index
	local surface = game.surfaces[surface_index]

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	for _, force in pairs(game.forces) do
		local tech = force.technologies["moon-discovery-cerys"]
		if tech then
			unresearch_successors(tech)
		end
	end

	storage.cerys = nil
end)

script.on_event(defines.events.on_entity_damaged, function(event)
	local entity = event.entity

	if
		not (
			entity
			and entity.valid
			and entity.type == "asteroid"
			and entity.surface
			and entity.surface.valid
			and entity.surface.name == "cerys"
		)
	then
		return
	end

	local cause = event.cause

	if not (cause and cause.valid and cause.type == "character") then
		return
	end

	if not (event.damage_type.name == "physical") then
		return
	end

	local no_weapon = not (
		cause.get_inventory(defines.inventory.character_guns)
		and cause.get_inventory(defines.inventory.character_guns)[cause.selected_gun_index]
		and cause.get_inventory(defines.inventory.character_guns)[cause.selected_gun_index].valid_for_read
	)

	if no_weapon then
		entity.health = entity.health - 2 -- Allow melee on asteroids for funsies
	end
end)

return Public
