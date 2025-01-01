data:extend({
	{
		type = "double-setting",
		name = "cerys-fulgoran-reactor-repair-cost-multiplier",
		setting_type = "runtime-global",
		default_value = 1.0,
		minimum_value = 0.1,
		maximum_value = 100.0,
	},
	{
		type = "double-setting",
		name = "cerys-gamma-radiation-damage-multiplier",
		setting_type = "runtime-global",
		default_value = 1.0,
		minimum_value = 0.0,
		maximum_value = 100.0,
	},
	{
		type = "bool-setting",
		name = "cerys-disable-solar-wind-when-not-looking-at-surface",
		setting_type = "runtime-global",
		default_value = false,
	},
})

data.raw["bool-setting"]["PlanetsLib-enable-temperature"].forced_value = true
