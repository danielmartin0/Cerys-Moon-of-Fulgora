local has_WU_mods = mods["wood-logistics"] and mods["fulgora-coralmium-agriculture"]
local has_lignumis = mods["lignumis"]
local has_lunaponics = mods["cerys-lunaponics"]

if has_WU_mods and not has_lunaponics then
	error(
		"\n\nPlaying Cerys alongside Wooden Logistics and Wooden Fulgora requires installing the mod Wooden Cerys: Lunaponics (https://mods.factorio.com/mod/cerys-lunaponics).\n\nPlease download and install this mod from the Mod Portal.\n"
	)
end

if has_lignumis and not has_lunaponics then
	error(
		"\n\nPlaying Cerys alongside Lignumis requires installing the mod Wooden Cerys: Lunaponics (https://mods.factorio.com/mod/cerys-lunaponics).\n\nPlease download and install this mod from the Mod Portal.\n"
	)
end

require("compat.forced-mods")
require("prototypes.categories")
require("prototypes.custom-input")
require("prototypes.collision-layers")
require("prototypes.decoratives")
require("prototypes.entity.charging-rod")
require("prototypes.entity.crusher")
require("prototypes.entity.cryogenic-plant")
require("prototypes.entity.icebergs")
require("prototypes.entity.lab")
require("prototypes.entity.nuclear-reactor")
require("prototypes.entity.particles-explosions")
require("prototypes.entity.player-nuclear-reactor")
require("prototypes.entity.player-radiative-tower")
require("prototypes.entity.projectiles")
require("prototypes.entity.radiative-tower")
require("prototypes.entity.ruins")
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
require("prototypes.resource")
require("prototypes.sound")
require("prototypes.sprites")
require("prototypes.technology")
require("prototypes.tile")
require("prototypes.tips-and-tricks")
require("compat.visible-planets")
