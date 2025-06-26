local common_data = require("common-data-only")

data:extend({
	{
		type = "fluid",
		name = "methane",
		subgroup = "fluid",
		default_temperature = 15,
		gas_temperature = 15,
		max_temperature = 535,
		heat_capacity = "0.22kJ",
		fuel_value = "5kJ", -- TODO: Balance this? It's simply half the thruster fuel value right now
		order = "b[new-fluid]-c[fulgora]-a[cerys]-a[methane]",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/methane.png",
		icon_size = 64,
		icon_mipmaps = 4,
		base_color = { r = 0.5, g = 0.5, b = 1, a = 1 },
		flow_color = { r = 1, g = 1, b = 1, a = 0 },
		auto_barrel = false,
	},

	{
		type = "fluid",
		name = common_data.NITRIC_ACID_NAME,
		subgroup = "fluid",
		default_temperature = 15,
		base_color = { 0.384, 0.271, 0.792 },
		flow_color = { 0.384, 1, 0.792 },
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nitric-acid.png",
		icon_size = 64,
		icon_mipmaps = 4,
		order = "a[fluid]-b[oil]-f[sulfuric-acid]-b[nitric-acid]",
	},

	{
		type = "fluid",
		name = "mixed-oxide-waste-solution",
		subgroup = "fluid",
		default_temperature = 15,
		base_color = { 0.7, 0.5, 1 }, -- nitric
		flow_color = { 0.7, 0.5, 1 }, -- nitric
		-- base_color = { 0.75, 0.65, 0.1 }, -- sulfuric
		-- flow_color = { 0.7, 1, 0.1 }, -- sulfuric
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/nuclear-waste-solution-nitric.png",
		icon_size = 64,
		icon_mipmaps = 4,
		order = "b[new-fluid]-j[cerys]-b[mixed-oxide-waste-solution]",
	},
})
