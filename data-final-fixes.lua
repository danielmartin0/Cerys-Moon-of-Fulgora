require("compat.autoban")
require("prototypes.override-final.entity")
require("prototypes.override-final.item")
require("prototypes.override-final.hidden")
require("prototypes.override-final.recipe")
require("prototypes.override-final.sprites")
require("prototypes.override-final.technology")
require("prototypes.override-final.tooltips")

require("compat.compat")
require("compat.static-recycling")
require("compat.any-planet-start")
require("compat.categories")
require("compat.maraxsis")
require("compat.mulana")
require("compat.plutonium-energy")
require("compat.krastorio-2-final-fixes")
require("compat.wooden-cerys-lunaponics")
require("compat.hard-mode")

-- for _, character in pairs(data.raw.character) do
-- 	if
-- 		character.footstep_particle_triggers
-- 		and character.footstep_particle_triggers[1]
-- 		and character.footstep_particle_triggers[1].tiles
-- 	then
-- 		table.insert(character.footstep_particle_triggers[1].tiles, "cerys-water-puddles")
-- 		table.insert(character.footstep_particle_triggers[1].tiles, "cerys-water-puddles-freezing")
-- 	end
-- end
