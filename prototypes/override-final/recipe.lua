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

--== Relaxations ==--

if data.raw.recipe["recycler"] then
	PlanetsLib.relax_surface_conditions(data.raw.recipe["recycler"], {
		property = "magnetic-field",
		max = 120,
	})
end

if data.raw.recipe["cryogenic-plant"] then
	PlanetsLib.relax_surface_conditions(data.raw.recipe["cryogenic-plant"], {
		property = "pressure",
		min = 5,
	})
end

--== Restrictions ==--

local magnetic_field_restriction = {
	property = "magnetic-field",
	max = 119,
}

if data.raw.recipe["lab"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["lab"], magnetic_field_restriction)
end

if data.raw.recipe["accumulator"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["accumulator"], magnetic_field_restriction)
end

if data.raw.recipe["nuclear-reactor"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["nuclear-reactor"], magnetic_field_restriction)
end

if data.raw.recipe["fusion-reactor"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["fusion-reactor"], magnetic_field_restriction)
end

if data.raw.recipe["fusion-generator"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["fusion-generator"], magnetic_field_restriction)
end

if data.raw.recipe["fusion-power-cell"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["fusion-power-cell"], magnetic_field_restriction)
end

if data.raw.recipe["boiler"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["boiler"], {
		property = "pressure",
		min = 10,
	})
end

if data.raw.recipe["steam-engine"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["steam-engine"], {
		property = "pressure",
		min = 10,
	})
end

if data.raw.recipe["rocket-fuel"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["rocket-fuel"], {
		property = "temperature",
		min = 255,
	})
end
