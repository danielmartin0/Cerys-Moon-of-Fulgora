local merge = require("lib").merge

data:extend({
	merge(data.raw["generator-equipment"]["fission-reactor-equipment"], {
		name = "mixed-oxide-reactor-equipment",
		sprite = {
			filename = "__Cerys-Moon-of-Fulgora__/graphics/equipment/mixed-oxide-reactor-equipment.png",
			width = 256,
			height = 256,
			priority = "high",
			scale = 0.5,
		},
		power = "1500kW", -- from 750kW
	}),
})
