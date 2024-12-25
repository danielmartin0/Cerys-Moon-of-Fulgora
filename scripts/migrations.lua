local init = require("scripts.init")

local Public = {}

function Public.run_migrations()
	local old_version = storage.cerys.last_seen_version
	-- local new_version = script.active_mods["Cerys-Moon-of-Fulgora"]

	-- Add any missing storage tables:
	init.ensure_cerys_storage_and_tables()

	if not old_version then
		local surface = game.surfaces["cerys"]
		if surface and surface.valid then
			local cryo_plants = surface.find_entities_filtered({ name = "cerys-fulgoran-cryogenic-plant-wreck" })

			for _, entity in pairs(cryo_plants) do
				if entity and entity.valid then
					game.print("[Cerys-Moon-of-Fulgora] Making cryogenic plant wrecks non-minable.")
					entity.minable_flag = false
				end
			end
		end
	end
end

return Public
