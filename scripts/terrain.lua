local simplex_noise = require("scripts.simplex_noise").d2
local find = require("lib").find
local cryogenic_plant = require("scripts.cryogenic-plant")
local crusher = require("scripts.crusher")
local common = require("common")

local Public = {}

local function final_region(x, y)
	return -(((y / 64) ^ 2) + (30 - x) / 32)
end

--== Entity positions ==--

local tower_separation = 22
local max_radius = common.MOON_RADIUS * 1.2

local hex_width = tower_separation
local hex_height = tower_separation * math.sqrt(3)
local col_offset = hex_width * 3 / 4 -- Horizontal distance between columns
local row_offset = hex_height / 2 -- Vertical offset for every other column

local max_cols = math.ceil(2 * max_radius / col_offset)
local max_rows = math.ceil(2 * max_radius / hex_height)

local function hex_grid_positions(args)
	local seed = args.seed
	local avoid_final_region = args.avoid_final_region or false
	local grid_scale = args.grid_scale or 1
	local noise_size = args.noise_size or 40
	local noise_scale = args.noise_scale or 500
	local displacement = args.displacement or { x = 0, y = 0 }

	local positions = {}
	for col = -max_cols, max_cols do
		for row = -max_rows, max_rows do
			local x = col * col_offset + displacement.x
			local y = row * hex_height + (col % 2) * row_offset + displacement.y

			local place = true
			if x ^ 2 + y ^ 2 > max_radius * max_radius then
				place = false
			end
			if x == 0 and y == 0 then
				place = false
			end
			if avoid_final_region and final_region(x, y) > 0 then
				place = false
			end

			if place then
				local noise_x = simplex_noise(x / noise_scale, y / noise_scale, seed + 100)
				local noise_y = simplex_noise(x / noise_scale, y / noise_scale, seed + 200)

				local p = {
					x = math.ceil(grid_scale * (x + noise_x * noise_size)),
					y = math.ceil(grid_scale * (y + noise_y * noise_size)),
				}

				table.insert(positions, p)
			end
		end
	end
	return positions
end

-- The following seeds aren't easy to get right. You need to put several plants in the final area, and not leave any plants with awkward heating coverage that trick the player into heating them up when they don't work. Radiative heaters should be able to reach the reactor, but only just, so the reactor doesn't heat too quickly after you turn them on.

local tower_positions = hex_grid_positions({
	seed = 2104,
	grid_scale = 1,
	avoid_final_region = true,
	noise_size = 40,
	noise_scale = 500,
})

local cryo_plant_positions = hex_grid_positions({
	seed = 4100,
	grid_scale = 2.2,
	avoid_final_region = false,
	displacement = { x = 0, y = -4.5 },
	noise_size = 17,
	noise_scale = 100,
})

local crusher_positions = hex_grid_positions({
	seed = 3500,
	grid_scale = 4.2,
	avoid_final_region = false,
	noise_size = 15,
	noise_scale = 200,
})

--== Terrain & entity generation ==--

function Public.on_cerys_chunk_generated(event, surface)
	local area = event.area
	local tiles = {}
	local entities = {}
	local decoratives = {}
	local hidden_tiles = {}

	local seed = event.surface.map_gen_settings.seed

	for x = area.left_top.x, area.right_bottom.x - 1 do
		for y = area.left_top.y, area.right_bottom.y - 1 do
			if x ^ 2 + y ^ 2 < (common.MOON_RADIUS * 1.5) ^ 2 then
				local existing_tile = surface.get_tile(x, y)
				local existing_tile_name = existing_tile and existing_tile.valid and existing_tile.name

				local is_surface = existing_tile_name ~= "empty-space" and existing_tile_name ~= "cerys-empty-space-2"

				if is_surface then
					Public.terrain(x, y, seed, existing_tile_name, entities, tiles, decoratives, hidden_tiles)
				end
			end
		end
	end

	surface.set_tiles(tiles, true)

	if #hidden_tiles > 0 then
		for _, hidden_tile in ipairs(hidden_tiles) do
			surface.set_hidden_tile(hidden_tile.position, hidden_tile.name)
		end
	end

	Public.create_towers(surface, area)
	Public.create_cryo_plants(surface, area)
	Public.create_crushers(surface, area)

	for _, entity_data in ipairs(entities) do
		local p = surface.find_non_colliding_position(entity_data.name, entity_data.position, 14, 2)

		if p then
			local entity = surface.create_entity({
				name = entity_data.name,
				position = p,
				force = entity_data.force,
				amount = entity_data.amount,
			})

			if entity and entity_data.post_create then
				entity_data.post_create(entity)
			end
		end
	end

	surface.create_decoratives({ check_collision = true, decoratives = decoratives })

	Public.create_lithium_brine(surface, area)
end

--luacheck: ignore
function Public.terrain(x, y, seed, existing_tile, entities, tiles, decoratives, hidden_tiles)
	local new_tile = nil

	local is_rock = find(common.ROCK_TILES, existing_tile)

	if common.DEBUG_DISABLE_FREEZING then
		if existing_tile == "cerys-ice-on-water" then
			new_tile = "cerys-water-puddles"
		elseif existing_tile == "cerys-ash-cracks-frozen" then
			new_tile = "cerys-ash-cracks"
		elseif existing_tile == "cerys-ash-dark-frozen" then
			new_tile = "cerys-ash-dark"
		elseif existing_tile == "cerys-ash-flats-frozen" then
			new_tile = "cerys-ash-flats"
		elseif existing_tile == "cerys-ash-light-frozen" then
			new_tile = "cerys-ash-light"
		elseif existing_tile == "cerys-pumice-stones-frozen" then
			new_tile = "cerys-pumice-stones"
		end
	else
		table.insert(hidden_tiles, { name = new_tile or existing_tile, position = { x = x, y = y } })

		if is_rock then
			new_tile = "cerys-dry-ice-on-land"
		else
			new_tile = "cerys-dry-ice-on-water"
		end
	end

	if new_tile then
		table.insert(tiles, { name = new_tile, position = { x = x, y = y } })
	end
end

function Public.create_towers(surface, area)
	for _, p in ipairs(tower_positions) do
		if
			p.x >= area.left_top.x
			and p.x < area.right_bottom.x
			and p.y >= area.left_top.y
			and p.y < area.right_bottom.y
		then
			local p2 = { x = p.x + 0.5, y = p.y }

			Public.ensure_solid_foundation(surface, p2, 1, 1.5)

			local colliding_simple_entities = surface.find_entities_filtered({
				type = "simple-entity",
				area = {
					left_top = { x = p2.x - 1.5, y = p2.y - 2 },
					right_bottom = { x = p2.x + 1.5, y = p2.y + 2 },
				},
			})
			for _, entity in ipairs(colliding_simple_entities) do
				entity.destroy()
			end

			if
				surface.can_place_entity({
					name = "cerys-fulgoran-radiative-tower-contracted-container",
					position = p2,
				})
			then
				local e = surface.create_entity({
					name = "cerys-fulgoran-radiative-tower-contracted-container",
					position = p2,
					force = "neutral",
				})
				script.raise_script_built({ entity = e })

				if e and e.valid then
					e.minable_flag = false
					e.destructible = false
				end
			end
		end
	end
end

function Public.create_cryo_plants(surface, area)
	for _, p in ipairs(cryo_plant_positions) do
		if
			p.x >= area.left_top.x
			and p.x < area.right_bottom.x
			and p.y >= area.left_top.y
			and p.y < area.right_bottom.y
		then
			local p2 = { x = p.x + 0.5, y = p.y + 0.5 }

			local colliding_simple_entities = surface.find_entities_filtered({
				type = "simple-entity",
				area = {
					left_top = { x = p2.x - 2.5, y = p2.y - 2.5 },
					right_bottom = { x = p2.x + 2.5, y = p2.y + 2.5 },
				},
			})
			for _, entity in ipairs(colliding_simple_entities) do
				entity.destroy()
			end

			local p3 = surface.find_non_colliding_position("cerys-fulgoran-cryogenic-plant-wreck-frozen", p2, 5, 1) -- searching too far will bias cryogenic plants to spawn on the edge of the moon

			if p3 then
				Public.ensure_solid_foundation(surface, p3, 2, 2)

				local e = surface.create_entity({
					name = "cerys-fulgoran-cryogenic-plant-wreck-frozen",
					position = p3,
					force = "player",
				})

				if e and e.valid then
					e.minable_flag = false
					e.destructible = false
					cryogenic_plant.register_ancient_cryogenic_plant(e, true)
				end
			end
		end
	end
end

function Public.create_crushers(surface, area)
	for _, p in ipairs(crusher_positions) do
		if
			p.x >= area.left_top.x
			and p.x < area.right_bottom.x
			and p.y >= area.left_top.y
			and p.y < area.right_bottom.y
		then
			local p2 = { x = p.x, y = p.y }

			local colliding_simple_entities = surface.find_entities_filtered({
				type = "simple-entity",
				area = {
					left_top = { x = p2.x - 2, y = p2.y - 1.5 },
					right_bottom = { x = p2.x + 2, y = p2.y + 1.5 },
				},
			})
			for _, entity in ipairs(colliding_simple_entities) do
				entity.destroy()
			end

			local p3 = surface.find_non_colliding_position("cerys-fulgoran-crusher-wreck-frozen", p2, 7, 3)

			if p3 then
				Public.ensure_solid_foundation(surface, p3, 4, 3)

				local e = surface.create_entity({
					name = "cerys-fulgoran-crusher-wreck-frozen",
					position = p3,
					force = "player",
				})

				if e and e.valid then
					e.minable_flag = false
					e.destructible = false
					crusher.register_ancient_crusher(e, true)
				end
			end
		end
	end
end

function Public.create_lithium_brine(surface, area)
	if
		not (
			common.LITHIUM_POSITION.x >= area.left_top.x
			and common.LITHIUM_POSITION.x < area.right_bottom.x
			and common.LITHIUM_POSITION.y >= area.left_top.y
			and common.LITHIUM_POSITION.y < area.right_bottom.y
		)
	then
		return
	end

	for _ = 1, 14 do
		local angle = math.random() * 2 * math.pi
		local distance = math.random() * 11
		local test_pos = {
			x = common.LITHIUM_POSITION.x + math.cos(angle) * distance,
			y = common.LITHIUM_POSITION.y + math.sin(angle) * distance,
		}

		local position = surface.find_non_colliding_position("lithium-brine", test_pos, 11, 1)

		if position then
			log("creating lithium brine at " .. position.x .. ", " .. position.y)
			surface.create_entity({
				name = "lithium-brine",
				position = position,
				amount = 100000000000,
			})
		end
	end
end

function Public.ensure_solid_foundation(surface, center, width, height)
	local tiles = {}
	for dx = -width, width do
		for dy = -height, height do
			local tile_underneath = surface.get_tile(center.x + dx, center.y + dy)
			local tile_underneath_is_water = tile_underneath and tile_underneath.name == "cerys-dry-ice-on-water"

			if tile_underneath_is_water then
				table.insert(tiles, {
					name = "cerys-concrete",
					position = { x = math.floor(center.x) + dx, y = math.floor(center.y) + dy },
				})
			end
		end
	end
	surface.set_tiles(tiles, true)
end

return Public
