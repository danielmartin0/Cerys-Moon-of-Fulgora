local init = require("scripts.init")
local lib = require("lib")
local common = require("common")
local crusher = require("scripts.crusher")
local radiative_towers = require("scripts.radiative-tower")

local Public = {}

function Public.run_migrations()
	if not storage.cerys then
		return
	end

	local last_seen_version = storage.cerys.last_seen_version
	-- local new_version = script.active_mods["Cerys-Moon-of-Fulgora"]

	init.delete_cerys_storage_if_necessary()

	-- Add any missing storage tables:
	init.ensure_cerys_storage_and_tables()

	local surface = game.surfaces["cerys"]
	if not surface or not surface.valid then
		return
	end

	if lib.is_newer_version(last_seen_version, "0.3.27") then
		local reactor = storage.cerys.nuclear_reactor
		if
			reactor
			and reactor.entity
			and reactor.entity.valid
			and (reactor.entity.name == "cerys-fulgoran-reactor-wreck")
		then
			reactor.entity.minable_flag = false
		end
	end

	if lib.is_newer_version(last_seen_version, "0.3.41") then
		local cryo_plant_wrecks = surface.find_entities_filtered({ name = "cerys-fulgoran-cryogenic-plant-wreck" })

		for _, entity in pairs(cryo_plant_wrecks) do
			if entity and entity.valid then
				entity.minable_flag = false
				entity.destructible = false
			end
		end

		local cryo_plants = surface.find_entities_filtered({ name = "cerys-fulgoran-cryogenic-plant" })
		for _, entity in pairs(cryo_plants) do
			if entity and entity.valid then
				entity.minable_flag = false
				entity.destructible = false
			end
		end
	end

	if lib.is_newer_version(last_seen_version, "0.5.23") then
		storage.cerys.ground_chunks = {}
		local ground_chunks = surface.find_entities_filtered({ name = "item-on-ground" })

		for _, entity in pairs(ground_chunks) do
			if entity and entity.valid and entity.stack and entity.stack.name then
				if
					entity.stack.name == "metallic-asteroid-chunk"
					or entity.stack.name == "carbonic-asteroid-chunk"
					or entity.stack.name == "oxide-asteroid-chunk"
				then
					if #storage.cerys.ground_chunks < 15 then
						storage.cerys.ground_chunks[#storage.cerys.ground_chunks + 1] = entity
					else
						entity.destroy()
					end
				end
			end
		end
	end

	if lib.is_newer_version(last_seen_version, "0.6.6") then
		local reactor = storage.cerys.reactor

		if
			reactor
			and reactor.entity
			and reactor.entity.valid
			and reactor.entity.name == "cerys-fulgoran-reactor-wreck-cleared"
		then
			reactor.entity.minable_flag = true
		end
	end

	if lib.is_newer_version(last_seen_version, "0.6.15") then
		storage.radiative_towers = storage.radiative_towers or {
			towers = {},
			contracted_towers = {},
		}

		if storage.cerys.heating_towers then
			storage.radiative_towers.towers = storage.cerys.heating_towers
		end

		if storage.cerys.heating_towers_contracted then
			storage.radiative_towers.contracted_towers = storage.cerys.heating_towers_contracted
		end
	end

	if lib.is_newer_version(last_seen_version, "0.9.2") then
		-- Destroy all solar wind particles:
		for _, particle in pairs(storage.cerys.solar_wind_particles) do
			if particle.entity and particle.entity.valid then
				particle.entity.destroy()
			end

			particle.entity = nil
		end
	end

	if lib.is_newer_version(last_seen_version, "0.9.8") then
		local lithium_brines = surface.find_entities_filtered({ name = "lithium-brine" })

		for _, entity in pairs(lithium_brines) do
			if entity and entity.valid then
				local dx = entity.position.x - common.LITHIUM_POSITION.x
				local dy = entity.position.y - common.LITHIUM_POSITION.y
				local d2 = dx * dx + dy * dy
				if d2 > 15 * 15 then
					game.print(
						"[CERYS]: Migrating save: destroying bugged lithium brine at "
							.. entity.position.x
							.. ", "
							.. entity.position.y
					)
					entity.destroy()
				end
			end
		end
	end

	if lib.is_newer_version(last_seen_version, "1.0.0") then
		for _, rod in pairs(storage.cerys.charging_rods) do
			if rod.red_light_rendering and rod.red_light_rendering.valid then
				rod.red_light_rendering.destroy()
			end
		end
	end

	if lib.is_newer_version(last_seen_version, "1.3.0") then
		storage.cerys_fulgoran_crushers = storage.cerys_fulgoran_crushers or {}

		local crushers = surface.find_entities_filtered({
			name = "cerys-fulgoran-crusher",
		})

		for _, e in pairs(crushers) do
			crusher.register_crusher(e)
		end
	end

	if lib.is_newer_version(last_seen_version, "1.3.9") then
		for _, rod in pairs(storage.cerys.charging_rods) do
			if rod.circuit_controlled == nil then
				rod.circuit_controlled = false
			end
			if rod.control_signal == nil then
				rod.control_signal = { type = "virtual", name = "signal-P" }
			end
		end
	end

	if lib.is_newer_version(last_seen_version, "1.3.12") then
		if storage.radiative_towers and storage.radiative_towers.towers then
			for r = 1, 17 do
				local existing_lamps = surface.find_entities_filtered({ name = "radiative-tower-lamp-" .. r })
				for _, lamp in pairs(existing_lamps) do
					lamp.destroy()
				end
			end

			for _, tower in pairs(storage.radiative_towers.towers) do
				local e = tower.entity

				if e and e.valid then
					local temperature_above_zero = e.temperature - radiative_towers.TEMPERATURE_ZERO

					local heating_radius =
						radiative_towers.heating_radius_from_temperature_above_zero(temperature_above_zero)

					for _, lamp in pairs(tower.lamps or {}) do
						if lamp and lamp.valid then
							lamp.destroy()
						end
					end
					tower.lamps = nil

					if heating_radius > 0 then
						local new_lamp = e.surface.create_entity({
							name = "radiative-tower-lamp-" .. heating_radius,
							position = e.position,
							force = e.force,
						})
						new_lamp.destructible = false
						new_lamp.minable_flag = false
						tower.current_lamp = new_lamp
					end
				end
			end
		end

		surface.brightness_visual_weights = { 0.2, 0.23, 0.21 }
	end

	if lib.is_newer_version(last_seen_version, "1.4.0") then
		local tower_prototypes = {
			"cerys-fulgoran-radiative-tower",
			"cerys-fulgoran-radiative-tower-frozen",
			"cerys-fulgoran-radiative-tower-rising-reactor-base",
			"cerys-fulgoran-radiative-tower-rising-reactor-tower-1",
			"cerys-fulgoran-radiative-tower-rising-reactor-tower-2",
			"cerys-fulgoran-radiative-tower-rising-reactor-tower-3",
			"cerys-fulgoran-radiative-tower-base",
			"cerys-fulgoran-radiative-tower-base-frozen",
			"cerys-fulgoran-radiative-tower-contracted-container",
		}

		for _, prototype_name in pairs(tower_prototypes) do
			local entities = surface.find_entities_filtered({ name = prototype_name })
			for _, entity in pairs(entities) do
				if entity.valid and entity.force.name == "neutral" then
					entity.force = "player"
				end
			end
		end
	end

	storage.cerys.last_seen_version = script.active_mods["Cerys-Moon-of-Fulgora"]
end

return Public
