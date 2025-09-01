data:extend({
	{
		type = "recipe",
		name = "cerys-make-solar-wind-ghosts",
		icon = "__core__/graphics/empty.png",
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
			{ type = "item", name = "steel-plate", amount = 2 },
			{ type = "item", name = "copper-cable", amount = 8 },
			{ type = "item", name = "advanced-circuit", amount = 4 },
		},
		results = { { type = "item", name = "cerys-solar-ghost-maker", amount = 1 } },
	},
})
