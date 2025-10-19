local lib = require("lib")
local radiative_towers = require("scripts.radiative-tower")
local rods = require("scripts.charging-rod")
local space = require("scripts.space")
local reactor_repair = require("scripts.reactor-repair")
local nuclear_reactor = require("scripts.nuclear-reactor")
local ice = require("scripts.ice")
local common = require("common")
local cryogenic_plant = require("scripts.cryogenic-plant")
local background = require("scripts.background")
local init = require("scripts.init")
local cooling = require("scripts.cooling")
local crusher = require("scripts.crusher")
local teleporter = require("scripts.teleporter")
local lighting = require("scripts.lighting")
local picker_dollies = require("compat.picker-dollies")
local terrain = require("scripts.terrain")
local inserter = require("scripts.inserter")
local bplib = require("__bplib__.blueprint")
local BlueprintBuild = bplib.BlueprintBuild
local BlueprintSetup = bplib.BlueprintSetup

local Public = {}

-- Highest-level file besides control.lua.
-- WARNING!!! Some events are handled in charging-rod.lua.

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
	elseif
		on_cerys
		and (
			entity.name == "cerys-charging-rod"
			or entity.name == "entity-ghost" and entity.ghost_name == "cerys-charging-rod"
		)
	then
		local tags = entity.tags
			or event.tags
			or {
				circuit_controlled = false,
				control_signal = { type = "virtual", name = "signal-P" },
				is_positive = true,
			}
		rods.built_charging_rod(entity, tags)
	elseif on_cerys and entity.type == "heat-pipe" then
		cooling.register_heat_pipe(entity)
	elseif on_cerys and entity.type == "boiler" then
		cooling.register_boiler(entity)
	elseif entity.name == "cerys-fulgoran-reactor-scaffold" and event.name == defines.events.on_built_entity then
		if not event.player_index then
			return
		end

		local player = game.players[event.player_index]

		if not (player and player.valid) then
			return
		end

		reactor_repair.scaffold_on_build(entity, player)
	elseif entity.name == "cerys-fulgoran-teleporter-frozen" then
		teleporter.register_frozen_teleporter(entity)
	elseif on_cerys and entity.type == "solar-panel" then
		lighting.register_solar_panel(entity)
	elseif entity.name == "cerys-lab" then
		entity.backer_name = ""
	elseif entity.name == "cerys-radiation-proof-inserter" then
		inserter.register_inserter(entity)
	end
end)

script.on_event(defines.events.on_player_setup_blueprint, function(event)
	-- Following the documented example at https://github.com/project-cybersyn/bplib/blob/main/doc/example.lua
	local bp_setup = BlueprintSetup:new(event)

	if not bp_setup then
		return
	end

	local map = bp_setup:map_blueprint_indices_to_world_entities()
	if not map then
		return
	end

	for bp_index, entity in pairs(map) do
		if entity.name == "cerys-charging-rod" then
			local tags = {}
			rods.tags_set_is_positive(tags, storage.cerys.charging_rod_is_positive[entity.unit_number])
			tags.circuit_controlled = storage.cerys.charging_rods[entity.unit_number]
				and storage.cerys.charging_rods[entity.unit_number].circuit_controlled
			tags.control_signal = storage.cerys.charging_rods[entity.unit_number]
				and storage.cerys.charging_rods[entity.unit_number].control_signal

			bp_setup:apply_tags(bp_index, tags)
		end
	end
end)

local function update_overlapping_entity(tags, entity)
	local is_positive = rods.tags_is_positive(tags) or false

	rods.rod_set_state(entity, is_positive)

	local rod_data = storage.cerys.charging_rods[entity.unit_number] or {}
	storage.cerys.charging_rods[entity.unit_number] = rod_data

	if tags.circuit_controlled ~= nil then
		rod_data.circuit_controlled = tags.circuit_controlled
	end
	if tags.control_signal ~= nil then
		rod_data.control_signal = tags.control_signal
	end
end

script.on_event(defines.events.on_pre_build, function(event)
	local player = game.get_player(event.player_index)

	if not (player and player.valid) then
		return
	end

	local cursor_stack = player.cursor_stack

	if cursor_stack and cursor_stack.valid_for_read then
		local item_name = cursor_stack.name

		if item_name == "cerys-fulgoran-reactor-scaffold" then
			reactor_repair.scaffold_on_pre_build(event)
		end
	end

	-- When we overlap existing entities in the word, we should update their tags.
	-- We follow the documented example at https://github.com/project-cybersyn/bplib/blob/main/doc/example.lua

	local bp_build = BlueprintBuild:new(event)
	-- Will be `nil` if the event was not a blueprint build.
	if not bp_build then
		return
	end

	local overlap_map = bp_build:map_blueprint_indices_to_overlapping_entities(function(bp_entity)
		return bp_entity.name == "cerys-charging-rod"
	end)

	if not overlap_map or (not next(overlap_map)) then
		return
	end

	-- NOTE(thesixthroc: As of 1.1.4 this is bugged, it does not detect in-world ghosts whose position and ghost name matches the [name and position] of one of the blueprint entities.
	local bp_entities = bp_build:get_entities() --[[@as BlueprintEntity[] ]]

	for bp_index, entity in pairs(overlap_map) do
		local tags = bp_entities[bp_index].tags or {}
		update_overlapping_entity(tags, entity)
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	local research = event.research

	if research.name == "cerys-fulgoran-cryogenics" then
		research.force.recipes["cerys-discover-fulgoran-cryogenics"].enabled = false
	elseif research.name == "cerys-nuclear-scrap-recycling" then
		-- This usually shouldn't be necessary, but in case the player has reset their technologies, we take the opportunity here to undo the above.
		research.force.recipes["cerys-discover-fulgoran-cryogenics"].enabled = true
	elseif research.name == common.FULGORAN_TOWER_MINING_TECH_NAME then
		lib.make_radiative_towers_minable()
	elseif research.name == "cerys-z-disable-legacy-tech-when-researched" then
		research.force.technologies["cerys-legacy-reactor-fuel-productivity"].researched = false
		research.force.technologies["cerys-legacy-reactor-fuel-productivity"].visible_when_disabled = false
		research.force.technologies["cerys-legacy-reactor-fuel-productivity"].enabled = false
	end
end)

script.on_event(defines.events.on_player_changed_surface, function(event)
	local player = game.players[event.player_index]
	local new_surface = player.surface

	if new_surface.name == "cerys" then
		if storage.cerys and not storage.cerys.first_visit_tick then
			storage.cerys.first_visit_tick = game.tick

			new_surface.request_to_generate_chunks({ 0, 0 }, lib.get_cerys_semimajor_axis(new_surface) * 2 / 32)
		end
	end
end)

script.on_event(defines.events.on_tick, function(event)
	local tick = event.tick

	radiative_towers.tick_1_move_radiative_towers()

	if tick % radiative_towers.TOWER_TEMPERATURE_TICK_INTERVAL == 0 then
		radiative_towers.radiative_heaters_temperature_tick()
	end

	if tick % 25 == 0 then
		inserter.tick_inserters()
	end

	local surface
	if storage.cerys then
		surface = game.get_surface("cerys")
		if surface and surface.valid then
			Public.cerys_tick(surface, tick)

			if tick % 20 == 0 then
				radiative_towers.tick_20_contracted_towers(surface)
			end
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

local deepfreeze_factor = common.PARTICLE_NOBODY_LOOKING_SLOWDOWN_FACTOR

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

	local solar_wind_tick_multiplier = player_looking_at_surface and 1 or deepfreeze_factor

	background.tick_1_update_background_renderings(surface)

	nuclear_reactor.tick_1_move_radiation(game.tick)
	cryogenic_plant.tick_1_check_cryo_quality_upgrades(surface)
	crusher.tick_1_check_crusher_quality_upgrades(surface)

	local lights_check_interval = player_looking_at_surface and 3 or 60
	if tick % lights_check_interval == 0 then
		lighting.tick_update_lights()
	end

	if
		player_looking_at_surface or not settings.global["cerys-disable-solar-wind-when-not-looking-at-surface"].value
	then
		if tick % (1 * solar_wind_tick_multiplier) == 0 then
			space.tick_1_move_solar_wind()
		end

		if tick % (5 * solar_wind_tick_multiplier) == 0 then
			space.tick_5_solar_wind_destroy_check(surface)
		end

		if tick % (8 * solar_wind_tick_multiplier) == 0 then
			space.tick_8_solar_wind_collisions(surface, solar_wind_tick_multiplier)
		end

		if tick % (space.SOLAR_WIND_DEFLECTION_TICK_INTERVAL * solar_wind_tick_multiplier) == 0 then
			space.tick_solar_wind_deflection()
		end

		if tick % (7 * solar_wind_tick_multiplier) == 0 then
			local spawn_chance = 0.35 * settings.global["cerys-solar-wind-spawn-rate-percentage"].value / 100
			if math.random() < spawn_chance then
				space.spawn_solar_wind_particle(surface)
			end
		end

		if tick % (12 * solar_wind_tick_multiplier) == 0 then
			rods.tick_12_check_charging_rods()
		end
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
		reactor_repair.tick_15_nuclear_reactor_repair_check(surface)
		teleporter.tick_15_check_frozen_teleporter(surface)
		teleporter.tick_15_check_teleporter()
	end

	if tick % 20 == 0 then
		cryogenic_plant.tick_20_check_cryo_quality_upgrades(surface)
		crusher.tick_20_check_crusher_quality_upgrades(surface)
	end

	if (tick + 3) % 30 == 0 then
		cooling.tick_30_cool_heat_pipes()
	end

	if (tick + 30) % 60 == 0 then
		space.try_spawn_asteroid(surface)
		Public.check_rocket_timed_effects(surface)
	end

	if (tick + 45) % 60 == 0 then
		cooling.tick_60_cool_boilers()
	end

	if (player_looking_at_surface or player_on_surface) and tick % ice.ICE_CHECK_INTERVAL == 0 then
		ice.tick_ice(surface)
	end

	if tick % 240 == 0 then
		space.tick_240_clean_up_cerys_asteroids(surface)
		space.tick_240_clean_up_cerys_solar_wind_particles(surface)
	end
end

script.on_event(defines.events.on_script_trigger_effect, function(event)
	local effect_id = event.effect_id

	local entity = event.target_entity
	if not (entity and entity.valid) then
		return
	end

	if effect_id == "cerys-fulgoran-radiative-tower-contracted-container" then
		radiative_towers.register_radiative_tower_contracted(entity)
	elseif effect_id == "cerys-fulgoran-crusher-created" then
		crusher.register_crusher(entity)
	elseif effect_id == "cerys-fulgoran-cryogenic-plant-created" then
		cryogenic_plant.register_cryogenic_plant(entity)
	elseif effect_id == "cerys-player-radiative-tower-created" then
		radiative_towers.register_player_radiative_tower(entity)
	elseif effect_id == "cerys-fulgoran-cryogenic-plant-wreck-created" then
		if entity.name == "cerys-fulgoran-cryogenic-plant-wreck-frozen" then
			cryogenic_plant.register_broken_cryogenic_plant(entity, true)
		else
			cryogenic_plant.register_broken_cryogenic_plant(entity)
		end
	elseif effect_id == "cerys-fulgoran-crusher-wreck-created" then
		if entity.name == "cerys-fulgoran-crusher-wreck-frozen" then
			crusher.register_broken_crusher(entity, true)
		else
			crusher.register_broken_crusher(entity)
		end
	elseif effect_id == "cerys-create-solar-wind-particle-ghost" then
		local p = entity.position
		local surface = entity.surface

		if not (surface and surface.valid and surface.name == "cerys") then
			return
		end

		local p2 = {
			x = p.x + 0.6,
			y = p.y - 1.44 + (math.random() - 0.5),
		} -- Update Factoriopedia simulation if updating this

		local r = rendering.draw_sprite({
			sprite = "cerys-solar-wind-particle-ghost",
			target = p2,
			surface = surface,
			render_layer = "air-object",
			tint = { r = 0.9, g = 0.9, b = 0.9 }, -- Opacity 90% (since it's a glow)
		})

		table.insert(storage.cerys.solar_wind_particles, {
			rendering = r,
			age = 0,
			velocity = space.initial_solar_wind_velocity(),
			position = p2,
			is_ghost = true,
		})
	end
end)

script.on_event({
	defines.events.on_robot_built_tile,
	defines.events.on_player_built_tile,
}, function(event)
	local surface = game.surfaces[event.surface_index]
	if surface and surface.valid and surface.name == "cerys" then
		for _, tile in pairs(event.tiles) do
			if common.TILE_REPLACEMENTS[event.tile.name] then
				surface.set_tiles(
					{ {
						name = common.TILE_REPLACEMENTS[event.tile.name],
						position = tile.position,
					} },
					true
				)
			end

			local hidden_tile = surface.get_hidden_tile(tile.position)

			if hidden_tile == "cerys-empty-space-2" then -- It seems to be impossible to prevent this with collision masks
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
	else
		if common.TILE_REPLACEMENTS_INVERSE[event.tile.name] then
			for _, tile in pairs(event.tiles) do
				surface.set_tiles({
					{
						name = common.TILE_REPLACEMENTS_INVERSE[event.tile.name],
						position = tile.position,
					},
				}, true)
			end
		end
	end
end)

script.on_configuration_changed(function()
	if storage.background_renderings then
		for _, player in pairs(game.players) do
			if storage.background_renderings[player.index] then
				storage.background_renderings[player.index].destroy()
			end
			storage.background_renderings[player.index] = nil
		end
	end

	init.initialize_technologies()

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

				if not storage.cerys.teleporter and not storage.cerys.frozen_teleporter then
					local e = terrain.create_teleporter()

					if e and e.valid then
						game.print(
							"[CERYS]: Added a Fulgoran Teleporter to the Cerys surface: [gps="
								.. e.position.x
								.. ","
								.. e.position.y
								.. ",cerys]",
							{ color = common.FRIENDLY_COLOR }
						)
					end
				end
			end
		end
	end

	picker_dollies.add_picker_dollies_blacklists()

	-- Hard mode can toggle pitch black:
	if storage.cerys and storage.cerys.light.rendering_3 and storage.cerys.light.rendering_3.valid then
		storage.cerys.light.rendering_3.destroy()
		storage.cerys.light.rendering_3 = nil
	end
end)

function Public.check_rocket_timed_effects(surface)
	if storage.atmospheric_nuke_toast_timer and game.tick >= storage.atmospheric_nuke_toast_timer then
		storage.atmospheric_nuke_toast_timer = nil

		if settings.global["cerys-disable-kofi-toast"].value then
			return
		end

		surface.print({
			"",
			"[font=default-game] >> ",
			{ "cerys.kofi-toast" },
			"[/font]",
		}, { color = { 164, 135, 255 } })
	end

	if storage.atmospheric_nuke_timer and game.tick >= storage.atmospheric_nuke_timer then
		storage.atmospheric_nuke_timer = nil

		surface.create_entity({
			name = "cerys-atmospheric-nuke-effect",
			position = { x = 0, y = 0 },
			force = "neutral",
		})

		for _, player in pairs(game.connected_players) do
			if player and player.valid and player.surface and player.surface.valid then
				local player_surface = player.surface
				if
					player_surface.name == "cerys"
					or (
						player_surface.platform
						and player_surface.platform.valid
						and player_surface.platform.space_location
						and player_surface.platform.space_location.name == "cerys"
					)
				then
					player.play_sound({
						path = "cerys-atmospheric-nuke",
						volume_modifier = 1,
					})
				end
			end
		end
	end
end

script.on_event(defines.events.on_rocket_launch_ordered, function(event)
	local rocket = event.rocket
	if not (rocket and rocket.valid) then
		return
	end

	local surface = rocket.surface
	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	local cargo_pod = event.rocket.cargo_pod
	if not (cargo_pod and cargo_pod.valid) then
		return
	end

	if not storage.atmospheric_nuke_toast_timer then
		if
			cargo_pod.cargo_pod_destination
			and cargo_pod.cargo_pod_destination.type == defines.cargo_destination.orbit
		then
			local pod_contents = cargo_pod.get_inventory(defines.inventory.cargo_unit).get_contents()

			local has_hydrogen_bomb = false
			for _, item in pairs(pod_contents) do
				if item.name == "cerys-hydrogen-bomb" then
					has_hydrogen_bomb = true
				end
			end

			if has_hydrogen_bomb then
				storage.atmospheric_nuke_timer = game.tick + 22 * 60
				storage.atmospheric_nuke_toast_timer = game.tick + 27 * 60
			end
		end
	end
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

script.on_event(defines.events.on_surface_created, function(event)
	init.on_surface_created(event)
end)

script.on_event(defines.events.on_chunk_generated, function(event)
	init.on_chunk_generated(event)
end)

script.on_event(defines.events.on_gui_opened, function(event)
	if event.gui_type ~= defines.gui_type.entity then
		return
	end

	local player = game.players[event.player_index]
	if not (player and player.valid) then
		return
	end

	local entity = event.entity
	if not (entity and entity.valid) then
		return
	end

	if entity.name == "cerys-fulgoran-teleporter-frozen" then
		player.opened = nil
	elseif entity.name == "cerys-fulgoran-teleporter" then
		teleporter.toggle_gui(player, entity)
	elseif entity.name == "cerys-radiation-proof-inserter" then
		inserter.on_inserter_gui_opened(player, entity)
	elseif
		entity.name == "cerys-charging-rod"
		or (entity.name == "entity-ghost" and entity.ghost_name == "cerys-charging-rod")
	then
		rods.on_gui_opened(event)
	elseif entity.type == "accumulator" then -- Legacy code
		rods.destroy_guis(event.player_index)
	end
end)

script.on_event(defines.events.on_gui_closed, function(event)
	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	if event.gui_type == defines.gui_type.custom and event.element and event.element.name == "cerys_teleporter_gui" then
		Public.toggle_gui(player)
	elseif event.gui_type == defines.gui_type.entity then
		local entity = event.entity
		if not (entity and entity.valid) then
			return
		end

		if
			entity.name == "cerys-charging-rod"
			or (entity.name == "entity-ghost" and entity.ghost_name == "cerys-charging-rod")
		then
			rods.destroy_guis(event.player_index)
		end
	end
end)

-- script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
-- 	if event.setting_type == "runtime-global" and (event.setting == "cerys-disable-parallax") then
-- 		background.reset_background_renderings()
-- 	end
-- end)

return Public
