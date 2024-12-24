local common = require("common")
local repair = require("repair")
local terrain = require("terrain")
local Private = {}
local Public = {}

function Public.initialize_cerys(surface)
	if storage.cerys then
		if surface and surface.valid then
			-- Avoid double initialization.
			return
		else
			-- We're reinitializing after a surface deletion.
			storage.cerys = {}
		end
	end

	if not surface then
		surface = game.planets["cerys"].create_surface()
	end

	if not surface.valid then
		game.delete_surface("cerys")
		surface = game.planets["cerys"].create_surface()
	end

	surface.min_brightness = 0.2
	surface.brightness_visual_weights = { 0.12, 0.15, 0.12 }

	surface.request_to_generate_chunks({ 0, 0 }, (common.MOON_RADIUS * 2) / 32)

	Private.init_cerys_storage()

	Public.create_reactor(surface)

	return surface
end

function Public.create_reactor(surface)
	local name = common.DEBUG_REACTOR_START and "cerys-fulgoran-reactor" or "cerys-fulgoran-reactor-wreck-frozen"

	local e = surface.create_entity({
		name = name,
		position = common.REACTOR_POSITION,
		force = "player",
	})

	if not (e and e.valid) then
		local p2 = surface.find_non_colliding_position("character", common.REACTOR_POSITION, 35, 1)

		e = surface.create_entity({
			name = name,
			position = p2,
			force = "player",
		})
	end

	e.minable_flag = false
	e.destructible = false

	local stage = common.DEBUG_REACTOR_START and repair.REACTOR_STAGE_ENUM.active or repair.REACTOR_STAGE_ENUM.frozen

	storage.cerys.reactor = {
		stage = stage,
		entity = e,
		creation_tick = game.tick,
	}
end

script.on_init(function()
	if common.DEBUG_MOON_START then
		Public.initialize_cerys()
	end
end)

script.on_event(defines.events.on_surface_created, function(event)
	local surface = event.surface

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	Public.initialize_cerys(surface)
end)

script.on_event(defines.events.on_chunk_generated, function(event)
	local surface = event.surface

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	if not storage.cerys then
		Public.initialize_cerys(surface)
	end

	terrain.on_cerys_chunk_generated(event, surface)
end)

script.on_configuration_changed(function()
	Private.init_cerys_storage()
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
		player.force.technologies["uranium-ammo"].research_recursive() -- should we force this tech?
		player.force.technologies["solar-energy"].research_recursive() -- should we force this tech?
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
			-- game.print("teleporting to cerys")

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

function Private.init_cerys_storage()
	if not storage.cerys then
		storage.cerys = {}
	end

	if not storage.cerys.charging_rods then
		storage.cerys.charging_rods = {}
	end

	if not storage.cerys.charging_rod_is_negative then
		storage.cerys.charging_rod_is_negative = {}
	end

	if not storage.cerys.solar_wind_particles then
		storage.cerys.solar_wind_particles = {}
	end

	if not storage.cerys.radiation_particles then
		storage.cerys.radiation_particles = {}
	end

	if not storage.cerys.asteroids then
		storage.cerys.asteroids = {}
	end

	if not storage.cerys.heating_towers then
		storage.cerys.heating_towers = {}
	end

	if not storage.cerys.heating_towers_contracted then
		storage.cerys.heating_towers_contracted = {}
	end

	if not storage.cerys.broken_cryo_plants then
		storage.cerys.broken_cryo_plants = {}
	end

	if not storage.background_renderings then
		storage.background_renderings = {}
	end
end

return Public
