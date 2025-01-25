local relax_surface_conditions = require("lib").relax_surface_conditions
local restrict_surface_conditions = require("lib").restrict_surface_conditions

--== Relaxations ==--

if data.raw.recipe["recycler"] then
	relax_surface_conditions(data.raw.recipe["recycler"], {
		property = "magnetic-field",
		max = 120,
	})
end

if data.raw.recipe["cryogenic-plant"] then
	relax_surface_conditions(data.raw.recipe["cryogenic-plant"], {
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
	restrict_surface_conditions(data.raw.recipe["lab"], magnetic_field_restriction)
end

if data.raw.recipe["accumulator"] then
	restrict_surface_conditions(data.raw.recipe["accumulator"], magnetic_field_restriction)
end

if data.raw.recipe["nuclear-reactor"] then
	restrict_surface_conditions(data.raw.recipe["nuclear-reactor"], magnetic_field_restriction)
end

if data.raw.recipe["fusion-reactor"] then
	restrict_surface_conditions(data.raw.recipe["fusion-reactor"], magnetic_field_restriction)
end

if data.raw.recipe["fusion-generator"] then
	restrict_surface_conditions(data.raw.recipe["fusion-generator"], magnetic_field_restriction)
end

if data.raw.recipe["fusion-power-cell"] then
	restrict_surface_conditions(data.raw.recipe["fusion-power-cell"], magnetic_field_restriction)
end

if data.raw.recipe["boiler"] then
	restrict_surface_conditions(data.raw.recipe["boiler"], {
		property = "pressure",
		min = 10,
	})
end

if data.raw.recipe["steam-engine"] then
	restrict_surface_conditions(data.raw.recipe["steam-engine"], {
		property = "pressure",
		min = 10,
	})
end

if data.raw.recipe["rocket-fuel"] then
	restrict_surface_conditions(data.raw.recipe["rocket-fuel"], {
		property = "temperature",
		min = 255,
	})
end

--== Forbid recycling certain items on Cerys ==--

if data.raw.recipe["uranium-238-recycling"] then
	restrict_surface_conditions(data.raw.recipe["uranium-238-recycling"], magnetic_field_restriction)
end
if data.raw.recipe["construction-robot-recycling"] then
	restrict_surface_conditions(data.raw.recipe["construction-robot-recycling"], magnetic_field_restriction)
end
if data.raw.recipe["exoskeleton-equipment-recycling"] then
	restrict_surface_conditions(data.raw.recipe["exoskeleton-equipment-recycling"], magnetic_field_restriction)
end

--== Flare stack ==--

if settings.startup["cerys-disable-flare-stack-item-venting"].value then
	data.raw.recipe["electric-incinerator"].hidden = true
	data.raw.recipe["incinerator"].hidden = true
end
