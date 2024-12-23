data.raw.recipe["superconductor"].category = "electromagnetics-or-fulgoran-cryogenics"
data.raw.recipe["sulfuric-acid"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
data.raw.recipe["plastic-bar"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
data.raw.recipe["lithium"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
data.raw.recipe["battery"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
data.raw.recipe["ammonia-rocket-fuel"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"

local recipe = data.raw.recipe["cryogenic-plant"]
if recipe and recipe.surface_conditions then
	for _, condition in pairs(recipe.surface_conditions) do
		if condition.pressure and condition.pressure.min and condition.pressure.min > 5 then
			condition.pressure.min = 5
		end
	end
end
