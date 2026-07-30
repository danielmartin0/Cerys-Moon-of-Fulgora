local collisions = require("scripts.collisions")

local ROD_MAX_GRID_RANGE = 25 + 3
for _,rod in pairs(storage.charging_rods) do
    local entity = rod.entity
    local deflection_lookup_table_entries = collisions.get_tiles_in_circle(ROD_MAX_GRID_RANGE,entity.position)
    storage.charging_rods[entity.unit_number].tiles_in_range = {}
	for _,new_tile in pairs(deflection_lookup_table_entries) do
		if not storage.static_particle_colliders[new_tile.x] then storage.static_particle_colliders[new_tile.x] = {} end
        if not storage.static_particle_colliders[new_tile.x][new_tile.y] then 
            storage.static_particle_colliders[new_tile.x][new_tile.y] = {}
        end
		local tile = storage.static_particle_colliders[new_tile.x][new_tile.y]
		if not tile.charging_rods then
			tile.charging_rods = {}
		end
		tile.charging_rods[entity.unit_number]=entity
        
		table.insert(storage.charging_rods[entity.unit_number].tiles_in_range,new_tile)
	end
end

