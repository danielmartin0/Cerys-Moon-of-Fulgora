local common = require("common")

if data.raw.recipe["superconductor"] then
	data.raw.recipe["superconductor"].additional_categories = data.raw.recipe["superconductor"].additional_categories
		or {}
	table.insert(data.raw.recipe["superconductor"].additional_categories, "fulgoran-cryogenics")
end
if data.raw.recipe["sulfuric-acid"] then
	data.raw.recipe["sulfuric-acid"].additional_categories = data.raw.recipe["sulfuric-acid"].additional_categories
		or {}
	table.insert(data.raw.recipe["sulfuric-acid"].additional_categories, "fulgoran-cryogenics")
end
if data.raw.recipe["plastic-bar"] then
	data.raw.recipe["plastic-bar"].additional_categories = data.raw.recipe["plastic-bar"].additional_categories or {}
	table.insert(data.raw.recipe["plastic-bar"].additional_categories, "fulgoran-cryogenics")
end
if data.raw.recipe["lithium"] then
	data.raw.recipe["lithium"].additional_categories = data.raw.recipe["lithium"].additional_categories or {}
	table.insert(data.raw.recipe["lithium"].additional_categories, "fulgoran-cryogenics")
end
if data.raw.recipe["battery"] then
	data.raw.recipe["battery"].additional_categories = data.raw.recipe["battery"].additional_categories or {}
	table.insert(data.raw.recipe["battery"].additional_categories, "fulgoran-cryogenics")
end
if data.raw.recipe["ammonia-rocket-fuel"] then
	data.raw.recipe["ammonia-rocket-fuel"].additional_categories = data.raw.recipe["ammonia-rocket-fuel"].additional_categories
		or {}
	table.insert(data.raw.recipe["ammonia-rocket-fuel"].additional_categories, "fulgoran-cryogenics")
end
if data.raw.recipe["fusion-power-cell"] then
	data.raw.recipe["fusion-power-cell"].additional_categories = data.raw.recipe["fusion-power-cell"].additional_categories
		or {}
	table.insert(data.raw.recipe["fusion-power-cell"].additional_categories, "fulgoran-cryogenics")
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

if data.raw.recipe["lab"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["lab"], common.MAGNETIC_FIELD_MAX)
end

if data.raw.recipe["accumulator"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["accumulator"], common.MAGNETIC_FIELD_MAX)
end

if data.raw.recipe["nuclear-reactor"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["nuclear-reactor"], common.MAGNETIC_FIELD_MAX)
end

if data.raw.recipe["fusion-reactor"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["fusion-reactor"], common.MAGNETIC_FIELD_MAX)
end

if data.raw.recipe["fusion-generator"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["fusion-generator"], common.MAGNETIC_FIELD_MAX)
end

if data.raw.recipe["fusion-power-cell"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["fusion-power-cell"], common.MAGNETIC_FIELD_MAX)
end

if data.raw.recipe["boiler"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["boiler"], common.TEN_PRESSURE_MIN)
end

if data.raw.recipe["steam-engine"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["steam-engine"], common.TEN_PRESSURE_MIN)
end

if data.raw.recipe["rocket-fuel"] then
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["rocket-fuel"], common.TEMPERATURE_MIN)
end
