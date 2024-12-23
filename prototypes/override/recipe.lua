-- Allow these:
data.raw.recipe.recycler.surface_conditions = {
	{
		property = "magnetic-field",
		min = 99,
		max = 120,
	},
}

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

-- Avoid the player trying to make these:
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
		min = 259,
	},
}

-- Prevent destruction of uranium-238:
local r = data.raw.recipe["uranium-238-recycling"]
if r then
	r.results = {
		{ type = "item", name = "uranium-238", amount = 1 },
	}
end
