local lib = require("lib")
local common = require("common")

if not storage.cerys then
	return
end

local surface = lib.generated_cerys_surface()
if not surface then
	return
end

for _, player in pairs(game.connected_players) do
	if player and player.valid and storage.background_renderings[player.index] then
		if storage.background_renderings[player.index].valid then
			storage.background_renderings[player.index].destroy()
		end
		storage.background_renderings[player.index] = nil
	end
end
