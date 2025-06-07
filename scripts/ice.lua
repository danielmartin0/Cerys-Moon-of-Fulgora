local common = require("common")

local Public = {}

local TILE_TRANSITIONS = {
	["cerys-water-puddles-freezing"] = "cerys-ice-on-water",
	["cerys-ice-on-water-melting"] = "cerys-water-puddles",
	-- ["nuclear-scrap-under-ice-melting"] = "ice-supporting-nuclear-scrap",
	-- ["ice-supporting-nuclear-scrap-freezing"] = "nuclear-scrap-under-ice",
	["cerys-dry-ice-on-water-melting"] = "nil",
	["cerys-dry-ice-on-land-melting"] = "nil",
	-- ["cerys-dry-ice-smooth-melting"] = "nil",
	-- ["cerys-dry-ice-smooth-land-melting"] = "nil",
	["cerys-ash-cracks-frozen-from-dry-ice"] = "cerys-ash-cracks",
	["cerys-ash-dark-frozen-from-dry-ice"] = "cerys-ash-dark",
	["cerys-ash-light-frozen-from-dry-ice"] = "cerys-ash-light",
	["cerys-pumice-stones-frozen-from-dry-ice"] = "cerys-pumice-stones",
}

local HIDDEN_TILE_TO_MELTING_TILE = {
	["cerys-ash-cracks-frozen"] = "cerys-ash-cracks-frozen-from-dry-ice",
	["cerys-ash-dark-frozen"] = "cerys-ash-dark-frozen-from-dry-ice",
	["cerys-ash-light-frozen"] = "cerys-ash-light-frozen-from-dry-ice",
	["cerys-pumice-stones-frozen"] = "cerys-pumice-stones-frozen-from-dry-ice",
}

Public.ICE_CHECK_INTERVAL = 80

local TRANSITION_TILE_NAMES = {}
for source_tile, _ in pairs(TILE_TRANSITIONS) do
	table.insert(TRANSITION_TILE_NAMES, source_tile)
end

function Public.tick_ice(surface)
	if not storage.transitioning_tiles then
		storage.transitioning_tiles = {}
	end
	if not storage.transitioning_tiles[surface.index] then
		storage.transitioning_tiles[surface.index] = {}
	end

	local transitioning_tiles
	local stretch_factor = common.get_cerys_surface_stretch_factor(surface)
	if stretch_factor > 1 then
		transitioning_tiles = surface.find_tiles_filtered({
			name = TRANSITION_TILE_NAMES,
			area = {
				left_top = {
					x = -common.CERYS_RADIUS * 1.1 * stretch_factor,
					y = -common.CERYS_RADIUS * 1.1 / stretch_factor,
				},
				right_bottom = {
					x = common.CERYS_RADIUS * 1.1 * stretch_factor,
					y = common.CERYS_RADIUS * 1.1 / stretch_factor,
				},
			},
		})
	else
		transitioning_tiles = surface.find_tiles_filtered({
			name = TRANSITION_TILE_NAMES,
			position = { x = 0, y = 0 },
			radius = common.CERYS_RADIUS * 1.05,
		})
	end

	if #transitioning_tiles > 0 then
		local tiles_to_set = Public.process_transitions(surface, transitioning_tiles, Public.ICE_CHECK_INTERVAL)

		if #tiles_to_set > 0 then
			surface.set_tiles(tiles_to_set)
		end
	end
end

function Public.process_transitions(surface, transitioning_tiles, interval)
	local tiles_to_set = {}

	for _, tile in pairs(transitioning_tiles) do
		local pos = tile.position
		if not storage.transitioning_tiles[surface.index][pos.x] then
			storage.transitioning_tiles[surface.index][pos.x] = {}
		end

		local last_observed_tick = storage.transitioning_tiles[surface.index][pos.x][pos.y]

		if
			last_observed_tick
			and (game.tick - last_observed_tick >= interval)
			and (game.tick - last_observed_tick < interval * 2)
		then
			if TILE_TRANSITIONS[tile.name] and TILE_TRANSITIONS[tile.name] ~= "nil" then
				tiles_to_set[#tiles_to_set + 1] = {
					name = TILE_TRANSITIONS[tile.name],
					position = pos,
				}
			end

			if Public.TILE_TRANSITION_EFFECTS[tile.name] then
				Public.TILE_TRANSITION_EFFECTS[tile.name](surface, pos)
			end

			storage.transitioning_tiles[surface.index][pos.x][pos.y] = nil
		else
			storage.transitioning_tiles[surface.index][pos.x][pos.y] = game.tick
		end
	end

	return tiles_to_set
end

local function melt_dry_ice(surface, pos)
	local hidden_tile = surface.get_hidden_tile(pos)
	if hidden_tile then
		if HIDDEN_TILE_TO_MELTING_TILE[hidden_tile] then
			hidden_tile = HIDDEN_TILE_TO_MELTING_TILE[hidden_tile]
		end

		surface.set_tiles({ { name = hidden_tile, position = pos } })
		surface.set_hidden_tile(pos, nil)
	end

	local colliding_simple_entities = surface.find_entities_filtered({
		name = {
			"cerys-methane-iceberg-huge",
			"cerys-methane-iceberg-big",
		},
		position = pos,
	})

	for _, e in pairs(colliding_simple_entities) do
		e.destroy()
	end

	surface.destroy_decoratives({
		name = {
			"cerys-methane-iceberg-medium",
			"cerys-methane-iceberg-small",
			"cerys-methane-iceberg-tiny",
		},
		position = pos,
	})

	surface.destroy_decoratives({
		name = {
			"cerys-ice-decal-white",
		},
		area = {
			left_top = { x = pos.x - 2, y = pos.y - 2 },
			right_bottom = { x = pos.x + 2, y = pos.y + 2 },
		},
	})
end

Public.TILE_TRANSITION_EFFECTS = {
	["cerys-dry-ice-on-water-melting"] = function(surface, pos)
		melt_dry_ice(surface, pos)
	end,
	["cerys-dry-ice-on-land-melting"] = function(surface, pos)
		melt_dry_ice(surface, pos)
	end,
	-- ["cerys-dry-ice-smooth-melting"] = function(surface, pos)
	-- 	melt_dry_ice(surface, pos)
	-- end,
	-- ["cerys-dry-ice-smooth-land-melting"] = function(surface, pos)
	-- 	melt_dry_ice(surface, pos)
	-- end,
	["cerys-water-puddles-freezing"] = function(surface, pos)
		local colliding_entities = surface.find_entities_filtered({
			area = {
				left_top = { x = pos.x + 0.2, y = pos.y + 0.2 },
				right_bottom = { x = pos.x + 0.8, y = pos.y + 0.8 },
			},
			type = "offshore-pump",
		})

		for _, entity in pairs(colliding_entities) do
			entity.die()
		end

		surface.create_entity({
			name = "water-splash",
			position = { x = pos.x + 0.5, y = pos.y + 0.5 },
		})
	end,
	["cerys-ice-on-water-melting"] = function(surface, pos)
		local colliding_entities = surface.find_entities_filtered({
			area = {
				left_top = { x = pos.x + 0.2, y = pos.y + 0.2 },
				right_bottom = { x = pos.x + 0.8, y = pos.y + 0.8 },
			},
			collision_mask = "object",
		})

		for _, entity in pairs(colliding_entities) do
			if entity and entity.valid and entity.type ~= "asteroid" and entity.type ~= "offshore-pump" then
				if entity.type ~= "offshore-pump" and entity.prototype.create_ghost_on_death then
					Public.place_ghost_foundation_under_entity(surface, entity)
				end

				entity.die()
			end
		end

		surface.create_entity({
			name = "water-splash",
			position = { x = pos.x + 0.5, y = pos.y + 0.5 },
		})
	end,
	-- ["nuclear-scrap-under-ice-melting"] = function(surface, pos)
	-- 	if not storage.frozen_scrap_amounts then
	-- 		storage.frozen_scrap_amounts = {}
	-- 	end

	-- 	local amount = 1000

	-- 	if storage.frozen_scrap_amounts[pos.x] and storage.frozen_scrap_amounts[pos.x][pos.y] then
	-- 		amount = storage.frozen_scrap_amounts[pos.x][pos.y]
	-- 	end

	-- 	if amount > 0 then
	-- 		surface.create_entity({
	-- 			name = "cerys-nuclear-scrap",
	-- 			position = { x = pos.x + 0.5, y = pos.y + 0.5 },
	-- 			amount = amount,
	-- 		})
	-- 	end
	-- end,
	-- ["ice-supporting-nuclear-scrap-freezing"] = function(surface, pos)
	-- 	local amount = 0
	-- 	local scrap = surface.find_entities_filtered({
	-- 		name = "cerys-nuclear-scrap",
	-- 		position = { x = pos.x + 0.5, y = pos.y + 0.5 },
	-- 	})

	-- 	for _, entity in pairs(scrap) do
	-- 		if entity and entity.valid then
	-- 			amount = amount + entity.amount
	-- 			entity.destroy()
	-- 		end
	-- 	end

	-- 	if not storage.frozen_scrap_amounts then
	-- 		storage.frozen_scrap_amounts = {}
	-- 	end

	-- 	if not storage.frozen_scrap_amounts[pos.x] then
	-- 		storage.frozen_scrap_amounts[pos.x] = {}
	-- 	end

	-- 	storage.frozen_scrap_amounts[pos.x][pos.y] = amount
	-- end,
}

function Public.place_ghost_foundation_under_entity(surface, entity)
	for i = -entity.tile_width / 2 + 0.5, entity.tile_width / 2 - 0.5 do
		for j = -entity.tile_height / 2 + 0.5, entity.tile_height / 2 - 0.5 do
			local tile = surface.get_tile(entity.position.x + i, entity.position.y + j)

			if
				tile
				and tile.valid
				and (tile.name == "cerys-ice-on-water-melting" or tile.name == "cerys-ice-on-water")
			then
				local ghosts = tile.get_tile_ghosts()

				local has_floor_layer = false
				for _, ghost in pairs(ghosts) do
					local prototype = ghost.ghost_prototype
					local layers = prototype.collision_mask.layers

					if layers and layers.floor then
						has_floor_layer = true
					end
				end

				if not has_floor_layer then
					surface.create_entity({
						force = entity.force,
						name = "tile-ghost",
						position = { x = entity.position.x + i, y = entity.position.y + j },
						ghost_name = "foundation",
					})
				end
			end
		end
	end
end

return Public
