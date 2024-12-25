local init = require("scripts.init")
local lib = require("lib")
local Public = {}

function Public.run_migrations()
	local last_seen_version = storage.cerys.last_seen_version
	-- local new_version = script.active_mods["Cerys-Moon-of-Fulgora"]

	-- Add any missing storage tables:
	init.ensure_cerys_storage_and_tables()

	if not last_seen_version then
		local surface = game.surfaces["cerys"]
		if surface and surface.valid then
			local cryo_plants = surface.find_entities_filtered({ name = "cerys-fulgoran-cryogenic-plant-wreck" })

			for _, entity in pairs(cryo_plants) do
				if entity and entity.valid then
					entity.minable_flag = false
				end
			end
		end
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

	storage.cerys.last_seen_version = script.active_mods["Cerys-Moon-of-Fulgora"]
end

return Public
