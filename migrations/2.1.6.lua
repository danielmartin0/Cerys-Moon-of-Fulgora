local lib = require("lib")
local common = require("common")

local surface = game.surfaces["cerys"]
if surface and surface.valid then
	local ghosts = surface.find_entities_filtered({ type = "tile-ghost" })
	for _, ghost in pairs(ghosts) do
		if ghost.valid then
			local tile = ghost.surface.get_tile(ghost.position.x, ghost.position.y)
			if tile and lib.find(common.SPACE_TILES_AROUND_CERYS, tile.name) then
				ghost.destroy()
			end
		end
	end
end

if storage.cerys and storage.cerys.solar_panels then
	for unit_number, panel in pairs(storage.cerys.solar_panels) do
		if
			panel.entity
			and panel.entity.valid
			and panel.entity.surface
			and panel.entity.surface.valid
			and panel.entity.surface.name == "cerys"
		then
			storage.cerys.solar_panels[unit_number] = nil
		end
	end
end
