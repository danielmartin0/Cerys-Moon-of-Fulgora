local Public = {}
local rro = require("__PlanetsLib__.lib.remove-replace-object")

--Used to convert circles into sets of tiles
function Public.get_tiles_in_circle(radius,center)
    local radius_sq = radius * radius
    --local rounded_center = {x = math.ceil(center.x+0.5), y = math.ceil(center.y+0.5)}
    local tiles = {}

    -- Maximum tile center that could possibly intersect.
    local limit = math.ceil(radius + 0.5)

    for x = -limit+center.x, limit+center.x do
        for y = -limit+center.y, limit+center.y do
            -- Find closest point on this square to the origin.
            local dx = math.max(math.abs(x) - 0.5, 0)
            local dy = math.max(math.abs(y) - 0.5, 0)

            if dx * dx + dy * dy <= radius_sq then
                tiles[#tiles + 1] = {x = math.ceil(x+0.5), y = math.ceil(y+0.5)}
            end
        end
    end

    return tiles
end

function Public.get_tiles_in_rectangle(width,height,center)
    --local rounded_center = {x = math.ceil(center.x+0.5), y = math.ceil(center.y+0.5)}
    local tiles = {}

    -- Maximum tile center that could possibly intersect.
    -- For 3x3 rectangle, this creates limits of -1 to +1, recreating 3x3 rectangle
    local limit_x = math.ceil(width/2 - 0.5) 
    local limit_y = math.ceil(height/2 - 0.5)

    for x = -limit_x+center.x, limit_x+center.x do
        for y = -limit_y+center.y, limit_y+center.y do
            -- Find closest point on this square to the origin.
            --local dx = math.max(math.abs(x) - 0.5, 0)
            --local dy = math.max(math.abs(y) - 0.5, 0)

            
            tiles[#tiles + 1] = {x = math.ceil(x+0.5), y = math.ceil(y+0.5)}
            
        end
    end
    
    return tiles
end

function Public.get_tiles_in_square(height,center)
    return Public.get_tiles_in_rectangle(height,height,center)
end


--Checks for collisions of particles with grid-aligned static entities. Allows the mod to avoid expensive find_entities_filtered calls.
function Public.check_collision(particle,radius,types)
    local collided_tiles = Public.get_tiles_in_circle(radius,particle.position)
    local collisions = {}
    for i,collided_position in pairs(collided_tiles) do
        local collision 
        if storage.static_particle_colliders[collided_position.x] and 
            storage.static_particle_colliders[collided_position.x][collided_position.y] and
            storage.static_particle_colliders[collided_position.x][collided_position.y].colliders then
                for _,collider in pairs(storage.static_particle_colliders[collided_position.x][collided_position.y].colliders) do
                    if collider.valid and rro.contains(collider.types,collider.type) then
                        table.insert(collisions,collider)
                    else
                        collider = nil
                    end
                end
                
                
            end
        
    end
	
end



function Public.add_entity_to_collision_map(entity)
    local bounds = entity.prototype.selection_box
    local width = math.abs(bounds.right_bottom.x-bounds.left_top.x)
    local height = math.abs(bounds.right_bottom.y-bounds.left_top.y)
    local center = entity.position
    local collision_positions=Public.get_tiles_in_rectangle(width,height,entity.position)

    for _,collider_position in pairs(collision_positions) do
        game.print(serpent.block(collider_position))
        if not storage.static_particle_colliders[collider_position.x] then storage.static_particle_colliders[collider_position.x] = {} end
        if not storage.static_particle_colliders[collider_position.x][collider_position.y] then 
            storage.static_particle_colliders[collider_position.x][collider_position.y] = {}
        end
        if not storage.static_particle_colliders[collider_position.x][collider_position.y].colliders then
            storage.static_particle_colliders[collider_position.x][collider_position.y].colliders = {}
        end 
        table.insert(storage.static_particle_colliders[collider_position.x][collider_position.y].colliders,entity)
        
    end
end



return Public