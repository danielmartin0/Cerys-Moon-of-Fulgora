--== Relaxations ==--

data.raw.recipe.recycler.surface_conditions = {
	{
		property = "magnetic-field",
		min = 99,
		max = 120,
	},
}

data.raw.recipe["cryogenic-plant"].surface_conditions = {
	{
		property = "pressure",
		min = 5,
		max = 600,
	},
}

--== Restrictions ==--

data.raw.recipe["lab"].surface_conditions = {
	{
		property = "magnetic-field",
		max = 119,
	},
}
data.raw.recipe["accumulator"].surface_conditions = {
	{
		property = "magnetic-field",
		max = 119,
	},
}
data.raw.recipe["nuclear-reactor"].surface_conditions = {
	{
		property = "magnetic-field",
		max = 119,
	},
}
data.raw.recipe["fusion-reactor"].surface_conditions = {
	{
		property = "magnetic-field",
		max = 119,
	},
}
data.raw.recipe["fusion-generator"].surface_conditions = {
	{
		property = "magnetic-field",
		max = 119,
	},
}
data.raw.recipe["fusion-power-cell"].surface_conditions = {
	{
		property = "magnetic-field",
		max = 119,
	},
}

data.raw.recipe["boiler"].surface_conditions = {
	{
		property = "pressure",
		min = 10,
	},
}
data.raw.recipe["steam-engine"].surface_conditions = {
	{
		property = "pressure",
		min = 10,
	},
}
data.raw.recipe["rocket-fuel"].surface_conditions = {
	{
		property = "temperature",
		min = 253,
	},
}

--== Forbid recycling certain items on Cerys ==--

local magnetic_field_restriction = {
	{ property = "magnetic-field", max = 119 },
}

if data.raw.recipe["uranium-238-recycling"] then
	data.raw.recipe["uranium-238-recycling"].surface_conditions = magnetic_field_restriction
end
if data.raw.recipe["construction-robot-recycling"] then
	data.raw.recipe["construction-robot-recycling"].surface_conditions = magnetic_field_restriction
end
