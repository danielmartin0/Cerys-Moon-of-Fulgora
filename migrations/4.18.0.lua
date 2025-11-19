local common = require("common")
local lib = require("lib")

local surface = lib.generated_cerys_surface()
if not surface then
	return
end

for _, force in pairs(game.forces) do
	if
		(
			force.technologies["cerys-electromagnetic-tooling"]
			and force.technologies["cerys-electromagnetic-tooling"].researched
		)
		or (
			force.technologies["cerys-radioactive-module"]
			and force.technologies["cerys-radioactive-module"].researched
		)
	then
		if force.technologies["cerys-space-science-pack-from-methane-ice"] then
			force.technologies["cerys-space-science-pack-from-methane-ice"].researched = true
		end
	end
end
