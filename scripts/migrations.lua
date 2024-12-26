local init = require("scripts.init")
local lib = require("lib")
local Public = {}

function Public.run_migrations()
	if not storage.cerys then
		return
	end

	local surface = game.surfaces["cerys"]
	if not surface or not surface.valid then
		return
	end

	local last_seen_version = storage.cerys.last_seen_version
	-- local new_version = script.active_mods["Cerys-Moon-of-Fulgora"]

	-- Add any missing storage tables:
	init.ensure_cerys_storage_and_tables()

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

	if lib.is_newer_version(last_seen_version, "0.3.39") then
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

	if lib.is_newer_version(last_seen_version, "0.4.17") then
		local reactor = storage.cerys.reactor

		if reactor and not (reactor.entity and reactor.entity.valid) then
			local reactor_entity = surface.find_entities_filtered({
				name = {
					"cerys-fulgoran-reactor",
					"cerys-fulgoran-reactor-wreck-cleared",
					"cerys-fulgoran-reactor-wreck",
					"cerys-fulgoran-reactor-wreck-frozen",
					"cerys-fulgoran-reactor",
				},
			})

			if reactor_entity and reactor_entity.valid then
				reactor.entity = reactor_entity
			end
		end
	end

	storage.cerys.last_seen_version = script.active_mods["Cerys-Moon-of-Fulgora"]
end

return Public
