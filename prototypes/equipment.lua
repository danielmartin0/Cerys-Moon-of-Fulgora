local merge = require("lib").merge

data:extend({
	merge(data.raw["generator-equipment"]["fission-reactor-equipment"], {
		name = "mixed-oxide-reactor-equipment",
		sprite = {
			filename = "__Cerys-Moon-of-Fulgora__/graphics/equipment/mixed-oxide-reactor-equipment.png",
			width = 256,
			height = 256,
			priority = "high",
			scale = 0.4,
		},
		power = "900kW",
		shape = {
			width = 3,
			height = 3,
			type = "full",
		},
	}),
})
