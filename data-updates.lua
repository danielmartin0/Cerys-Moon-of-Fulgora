require("prototypes.override.entity")
require("prototypes.override.recipe")
require("prototypes.override.item")
require("prototypes.override.planet")

PlanetsLib.add_entity_type_to_planet_cargo_drops_whitelist("cerys", "construction-robot")
PlanetsLib.add_item_name_to_planet_cargo_drops_whitelist("cerys", "cerys-hydrogen-bomb")

require("compat.aai")
require("compat.krastorio-2-data-updates")
