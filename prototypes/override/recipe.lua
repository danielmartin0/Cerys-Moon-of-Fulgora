local override_surface_conditions = require("lib").override_surface_conditions

--== Relaxations ==--

override_surface_conditions(data.raw.recipe["recycler"], {
	property = "magnetic-field",
	min = 99,
	max = 120,
})

override_surface_conditions(data.raw.recipe["cryogenic-plant"], {
	property = "pressure",
	min = 5,
	max = 600,
})

--== Restrictions ==--

override_surface_conditions(data.raw.recipe["lab"], {
	property = "magnetic-field",
	max = 119,
})

override_surface_conditions(data.raw.recipe["accumulator"], {
	property = "magnetic-field",
	max = 119,
})

override_surface_conditions(data.raw.recipe["nuclear-reactor"], {
	property = "magnetic-field",
	max = 119,
})

override_surface_conditions(data.raw.recipe["fusion-reactor"], {
	property = "magnetic-field",
	max = 119,
})

override_surface_conditions(data.raw.recipe["fusion-generator"], {
	property = "magnetic-field",
	max = 119,
})

override_surface_conditions(data.raw.recipe["fusion-power-cell"], {
	property = "magnetic-field",
	max = 119,
})

override_surface_conditions(data.raw.recipe["boiler"], {
	property = "pressure",
	min = 10,
})

override_surface_conditions(data.raw.recipe["steam-engine"], {
	property = "pressure",
	min = 10,
})

override_surface_conditions(data.raw.recipe["rocket-fuel"], {
	property = "temperature",
	min = 255,
})

override_surface_conditions(data.raw.recipe["space-platform-foundation"], {
	property = "magnetic-field",
	max = 119,
})

--== Forbid recycling certain items on Cerys ==--

local magnetic_field_restriction = {
	property = "magnetic-field",
	max = 119,
}

if data.raw.recipe["uranium-238-recycling"] then
	override_surface_conditions(data.raw.recipe["uranium-238-recycling"], magnetic_field_restriction)
end
if data.raw.recipe["construction-robot-recycling"] then
	override_surface_conditions(data.raw.recipe["construction-robot-recycling"], magnetic_field_restriction)
end
