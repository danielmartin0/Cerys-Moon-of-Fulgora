local lib = require("lib")
local merge = lib.merge

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

--== Flare stack ==--

if settings.startup["cerys-disable-flare-stack-item-venting"].value then
	data.raw.recipe["electric-incinerator"].hidden = true
	data.raw.recipe["incinerator"].hidden = true
end
