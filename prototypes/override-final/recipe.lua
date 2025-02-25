local merge = require("lib").merge

if data.raw.recipe["superconductor"] then
	data.raw.recipe["superconductor"].category = "electromagnetics-or-fulgoran-cryogenics"
end
if data.raw.recipe["sulfuric-acid"] then
	data.raw.recipe["sulfuric-acid"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
end
if data.raw.recipe["plastic-bar"] then
	data.raw.recipe["plastic-bar"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
end
if data.raw.recipe["lithium"] then
	data.raw.recipe["lithium"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
end
if data.raw.recipe["battery"] then
	data.raw.recipe["battery"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
end
if data.raw.recipe["ammonia-rocket-fuel"] then
	data.raw.recipe["ammonia-rocket-fuel"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
end

if data.raw.recipe["plutonium-239-recycling"] then
	data.raw.recipe["plutonium-239-recycling"].energy_required = 1 -- Dropping the energy of the U->Pu dummy recipe affects this for some reason
end

data:extend({
	{
		type = "recipe",
		name = "cerys-construction-bot-recycling",
		enabled = false,
		energy_required = 1,
		ingredients = {
			{ "construction-robot", 1 },
		},
		result = "construction-robot",
	},
})

data:extend({
	merge(data.raw.recipe["construction-robot-recycling"], {
		name = "cerys-construction-bot-recycling",
		enabled = false,
	}),
})
