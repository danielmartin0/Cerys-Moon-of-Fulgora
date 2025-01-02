local init = require("scripts.init")
local lib = require("lib")
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

	storage.cerys.last_seen_version = script.active_mods["Cerys-Moon-of-Fulgora"]
end

return Public
