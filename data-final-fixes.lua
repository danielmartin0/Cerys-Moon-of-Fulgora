require("prototypes.override-final.entity")
require("prototypes.override-final.item")
require("prototypes.override-final.recipe")
require("prototypes.override-final.technology")

require("compat.categories")
require("compat.compat")
require("compat.any-planet-start")
require("compat.maraxsis")
require("compat.static-recycling")
require("compat.mulana")

-- Hiding this here:
data:extend({
	{
		type = "tool",
		name = "fulgoran-cryogenics-progress",
		hidden = true,
		icon = "__PlanetsLib__/graphics/icons/research-progress-product.png",
		icon_size = 64,
		subgroup = "science-pack",
		order = "j-a[cerys]-b[fulgoran-cryogenics-progress]",
		stack_size = 200,
		default_import_location = "cerys",
		weight = 1 * 1000 * 1000000,
		durability = 1,
	},
})
