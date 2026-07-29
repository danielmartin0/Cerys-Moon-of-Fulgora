local collisions = require("scripts.collisions")
if game.planets.cerys then
    local surface = game.planets.cerys.surface
    for _,entity in pairs(surface.find_entities_filtered{type = {"transport-belt","container","logistic-container"}}) do
        collisions.add_entity_to_collision_map(entity)
    end
        
end
