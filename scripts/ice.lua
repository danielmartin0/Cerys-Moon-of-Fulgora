local Private = {}
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
}

Public.ICE_CHECK_INTERVAL = 80 -- Only specific numbers work, see events.lua

function Public.tick_ice(surface)
	if not storage.transitioning_tiles then
		storage.transitioning_tiles = {}
	end
	if not storage.transitioning_tiles[surface.index] then
		storage.transitioning_tiles[surface.index] = {}
	end

	local transition_tile_names = {}
	for source_tile, _ in pairs(TILE_TRANSITIONS) do
		table.insert(transition_tile_names, source_tile)
	end

	local transitioning_tiles = surface.find_tiles_filtered({
		name = transition_tile_names,
	})

	local tiles_to_set = Private.process_transitions(surface, transitioning_tiles, Public.ICE_CHECK_INTERVAL)

	if #tiles_to_set > 0 then
		surface.set_tiles(tiles_to_set)
	end
end

function Private.process_transitions(surface, transitioning_tiles, interval)
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
			if TILE_TRANSITIONS[tile.name] ~= "nil" then
				tiles_to_set[#tiles_to_set + 1] = {
					name = TILE_TRANSITIONS[tile.name],
					position = pos,
				}
			end

			if Private.TILE_TRANSITION_EFFECTS[tile.name] then
				Private.TILE_TRANSITION_EFFECTS[tile.name](surface, pos)
			end

			storage.transitioning_tiles[surface.index][pos.x][pos.y] = nil
		else
			storage.transitioning_tiles[surface.index][pos.x][pos.y] = game.tick
		end
	end

	return tiles_to_set
end

local function melt_dry_ice(surface, pos)
	local tile = surface.get_hidden_tile(pos)
	if tile then
		surface.set_tiles({ { name = tile, position = pos } })
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
end

Private.TILE_TRANSITION_EFFECTS = {
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
	["cerys-ice-on-water-melting"] = function(surface, pos)
		local colliding_entities = surface.find_entities_filtered({
			area = {
				left_top = { x = pos.x + 0.2, y = pos.y + 0.2 },
				right_bottom = { x = pos.x + 0.8, y = pos.y + 0.8 },
			},
			collision_mask = "object",
		})

		for _, entity in pairs(colliding_entities) do
			if
				entity
				and entity.valid
				and entity.surface
				and entity.surface.valid
				and entity.name
				and entity.name == "character"
			then
				-- TODO: Fix this
				entity.teleport(surface.find_non_colliding_position("character", entity.position, 10, 0.5))
			else
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

return Public
