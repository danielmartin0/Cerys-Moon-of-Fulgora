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
	{
		type = "double-setting",
		name = "cerys-solar-wind-spawn-rate-percentage",
		setting_type = "runtime-global",
		default_value = 100.0,
		minimum_value = 0.0,
		maximum_value = 200.0,
	},
	{
		type = "bool-setting",
		name = "cerys-disable-flare-stack-item-venting",
		setting_type = "startup",
		default_value = true,
	},
	{
		type = "double-setting",
		name = "cerys-plutonium-generation-rate-multiplier",
		setting_type = "runtime-global",
		default_value = 1.0,
		minimum_value = 0.1,
		maximum_value = 1000.0,
	},
	{
		type = "bool-setting",
		name = "cerys-technology-compatibility-mode",
		setting_type = "startup",
		default_value = false,
	},
	{
		type = "bool-setting",
		name = "cerys-mark-chunks-for-deconstruction",
		setting_type = "runtime-global",
		default_value = true,
	},
	{
		type = "bool-setting",
		name = "cerys-mark-chunks-to-be-looted",
		setting_type = "runtime-global",
		default_value = true,
	},
})

data.raw["bool-setting"]["PlanetsLib-enable-temperature"].forced_value = true
