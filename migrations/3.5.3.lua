local lib = require("lib")
local common = require("common")

local surface = lib.generated_cerys_surface()
if not surface then
	return
end

surface.wind_speed = 0
surface.wind_orientation_change = 0
