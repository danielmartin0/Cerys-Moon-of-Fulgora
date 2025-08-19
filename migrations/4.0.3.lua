local common = require("common")

local surface = common.generated_cerys_surface()
if not surface then
	return
end

for _, force in pairs(game.forces) do
	if
		force.technologies["cerys-legacy-reactor-fuel-productivity"]
		and force.technologies["cerys-lubricant-synthesis"]
		and force.technologies["cerys-lubricant-synthesis"].researched
	then
		force.technologies["cerys-legacy-reactor-fuel-productivity"].researched = true
		force.technologies["cerys-legacy-reactor-fuel-productivity"].visible_when_disabled = true
	end
end
