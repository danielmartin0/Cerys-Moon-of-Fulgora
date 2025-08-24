local common = require("common")

local surface = common.generated_cerys_surface()
if not surface then
	return
end

for _, force in pairs(game.forces) do
	if
		force.technologies["planetslib-cerys-cargo-drops"]
		and force.technologies["planetslib-cerys-cargo-drops"].researched
	then
		if force.technologies["cerys-reactor-fuel"] then
			force.technologies["cerys-reactor-fuel"].researched = true
		end
		-- This one is new, not part of an existing tech:
		-- if force.technologies["cerys-radioactive-module"] then
		-- 	force.technologies["cerys-radioactive-module"].researched = true
		-- end
		if force.technologies["cerys-mixed-oxide-reactors"] then
			force.technologies["cerys-mixed-oxide-reactors"].researched = true
		end
	end

	if
		force.technologies[common.FULGORAN_TOWER_MINING_TECH_NAME]
		and force.technologies[common.FULGORAN_TOWER_MINING_TECH_NAME].researched == true
	then
		common.make_radiative_towers_minable()
	end
end
