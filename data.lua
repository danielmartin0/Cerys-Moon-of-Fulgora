local common = require("common")

data:extend({
	{
		type = "mod-data",
		name = "Cerys",
		data = {
			fulgora_image_size = common.DEFAULT_FULGORA_IMAGE_SIZE,
		},
	},
})

require("compat.forced-mods")
require("prototypes.categories")
require("prototypes.custom-input")
require("prototypes.collision-layers")
require("prototypes.decoratives")
require("prototypes.entity.charging-rod")
require("prototypes.entity.crusher")
require("prototypes.entity.cryogenic-plant")
require("prototypes.entity.icebergs")
require("prototypes.entity.inserter")
require("prototypes.entity.lab")
require("prototypes.entity.nuclear-reactor")
require("prototypes.entity.particles-explosions")
require("prototypes.entity.player-nuclear-reactor")
require("prototypes.entity.player-radiative-tower")
require("prototypes.entity.projectiles")
require("prototypes.entity.proxy-container")
require("prototypes.entity.radiative-tower")
require("prototypes.entity.ruins")
require("prototypes.entity.solar-ghost-maker")
require("prototypes.entity.space")
require("prototypes.entity.teleporter")
require("prototypes.equipment")
require("prototypes.fluid")
require("prototypes.item")
require("prototypes.planet.map-gen")
require("prototypes.planet.planet")
require("prototypes.recipe.nuclear")
require("prototypes.recipe.recipe")
require("prototypes.recipe.repair")
require("prototypes.recipe.scrap")
require("prototypes.recipe.solar-ghost-maker")
require("prototypes.resource")
require("prototypes.sound")
require("prototypes.sprites")
require("prototypes.technology")
require("prototypes.tile")
require("prototypes.tips-and-tricks")
require("compat.visible-planets")
require("compat.resource-spawner-overhaul")
