if settings.startup["cerys-infinite-braking-technology"].value then
	data:extend({
		{
			type = "technology",
			name = "braking-force-8",
			icons = util.technology_icon_constant_braking_force("__base__/graphics/technology/braking-force.png"),
			effects = {
				{
					type = "train-braking-force-bonus",
					modifier = 0.15,
				},
			},
			prerequisites = { "braking-force-7" },
			unit = {
				count_formula = "2^(L-7)*" .. data.raw.technology["braking-force-7"].unit.count,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack", 1 },
					{ "chemical-science-pack", 1 },
					{ "production-science-pack", 1 },
					{ "utility-science-pack", 1 },
				},
				time = 60,
			},
			upgrade = true,
		},
	})
end
