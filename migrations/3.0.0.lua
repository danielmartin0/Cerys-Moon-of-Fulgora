local common = require("common")
local terrain = require("scripts.terrain")

if not storage.cerys then
	return
end

local surface = common.generated_cerys_surface()
if not surface then
	return
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
