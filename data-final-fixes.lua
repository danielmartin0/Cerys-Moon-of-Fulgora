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


local recipe_count = 0

for name, value in ipairs(data.raw.mod_data) do
    if value.data_type == "cerys-solar-wind-recipe" then
        local chance = value.chance

        -- The chest is about 30 times better than the belt.
        value.chance_belt = chance / 334 --0,002994011976
        --chest chance at base has to be 0.0001
		value.chance_chest = chance / 10000 --0.0001
        recipe_count = recipe_count + 1
    end
end

if settings.startup["cerys-plutonium-recipe-limit"].value > recipe_count then
    error({ "cerys-error.plutonium-limit-reached" }, recipe_count)
end
