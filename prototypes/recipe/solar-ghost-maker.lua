data:extend({
	{
		type = "recipe",
		name = "cerys-make-solar-wind-ghosts",
		hidden = true,
		enabled = false,
		energy_required = 1,
		ingredients = {},
		results = { { type = "item", name = "cerys-solar-wind-particle-ghost", amount = 1 } },
		category = "cerys-make-solar-wind-ghosts",
		result_is_always_fresh = true,
	},
	{
		type = "recipe",
		name = "cerys-solar-ghost-maker",
		enabled = false,
		energy_required = 1,
		ingredients = {
			{ type = "item", name = "iron-gear-wheel", amount = 1 },
			{ type = "item", name = "iron-plate", amount = 1 },
			{ type = "item", name = "inserter", amount = 1 },
		},
		results = { { type = "item", name = "cerys-solar-ghost-maker", amount = 1 } },
	},
})
