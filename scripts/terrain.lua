local radiative_towers = require("scripts.radiative-tower")
local simplex_noise = require("scripts.simplex_noise").d2
local find = require("lib").find
local repair = require("scripts.repair")
local common = require("common")

local Private = {}
local Public = {}

local function final_region(x, y)
	return -(((y / 64) ^ 2) + (30 - (x + y / 5)) / 32)
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

	local positions = {}
	for col = -max_cols, max_cols do
		for row = -max_rows, max_rows do
			local x = col * col_offset
			local y = row * hex_height + (col % 2) * row_offset

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

local tower_positions = hex_grid_positions({
	seed = 2100,
	grid_scale = 1,
	avoid_final_region = true,
	noise_size = 40,
	noise_scale = 500,
})

-- TODO: Switch cryo plant grid to use surface co-ordinates
local cryo_plant_positions = hex_grid_positions({
	seed = 4100,
	grid_scale = 2.2,
	avoid_final_region = false,
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

				local is_surface = existing_tile_name ~= "empty-space"

				if is_surface then
					Private.terrain(x, y, seed, existing_tile_name, entities, tiles, decoratives, hidden_tiles)
				end
			end
		end
	end

	Private.create_towers(surface, area)

	surface.set_tiles(tiles, true)

	if #hidden_tiles > 0 then
		for _, hidden_tile in ipairs(hidden_tiles) do
			surface.set_hidden_tile(hidden_tile.position, hidden_tile.name)
		end
	end

	Private.create_cryo_plants(surface, area)
	Private.create_crushers(surface, area)

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

	Private.create_lithium_brine(surface, area)
end

function Private.terrain(x, y, seed, existing_tile, entities, tiles, decoratives, hidden_tiles)
	local new_tile = nil

	local is_rock = find(common.ROCK_TILES, existing_tile)

	local resource_noise = simplex_noise(x / 30, y / 30, seed)

	if resource_noise < 0 then
		local decorative_noise = simplex_noise(x / 50, y / 50, seed + 400)
		if decorative_noise > -0.3 then
			local rng = math.random()
			if is_rock then
				if rng < 0.015 then
					table.insert(entities, {
						name = "cerys-methane-iceberg-huge",
						position = { x = x + 0.5, y = y + 0.5 },
					})
				elseif rng < 0.03 then
					table.insert(entities, {
						name = "cerys-methane-iceberg-big",
						position = { x = x + 0.5, y = y + 0.5 },
					})
				elseif rng < 0.05 then
					table.insert(decoratives, {
						name = "cerys-methane-iceberg-medium",
						position = { x = x + 0.5, y = y + 0.5 },
					})
				elseif rng < 0.06 then
					table.insert(decoratives, {
						name = "cerys-methane-iceberg-small",
						position = { x = x + 0.5, y = y + 0.5 },
					})
				elseif rng < 0.075 then
					table.insert(decoratives, {
						name = "cerys-methane-iceberg-tiny",
						position = { x = x + 0.5, y = y + 0.5 },
					})
				end
			else
				if rng < 0.06 then
					table.insert(decoratives, {
						name = "cerys-methane-iceberg-small",
						position = { x = x + 0.5, y = y + 0.5 },
					})
				elseif rng < 0.075 then
					table.insert(decoratives, {
						name = "cerys-methane-iceberg-tiny",
						position = { x = x + 0.5, y = y + 0.5 },
					})
				end
			end
		end
	end

	if common.CERYS_IS_FROZEN then
		table.insert(hidden_tiles, { name = new_tile or existing_tile, position = { x = x, y = y } })

		if is_rock then
			new_tile = "cerys-dry-ice-on-land"
		else
			new_tile = "cerys-dry-ice-on-water"
		end
	else
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
	end

	if new_tile then
		table.insert(tiles, { name = new_tile, position = { x = x, y = y } })
	end
end

function Private.create_towers(surface, area)
	for _, p in ipairs(tower_positions) do
		if
			p.x >= area.left_top.x
			and p.x < area.right_bottom.x
			and p.y >= area.left_top.y
			and p.y < area.right_bottom.y
		then
			local p2 = { x = p.x + 0.5, y = p.y }

			local existing_tiles = {
				surface.get_tile(p2.x - 1, p2.y - 1.5),
				surface.get_tile(p2.x, p2.y - 1.5),
				surface.get_tile(p2.x + 1, p2.y - 1.5),
				surface.get_tile(p2.x - 1, p2.y - 0.5),
				surface.get_tile(p2.x, p2.y - 0.5),
				surface.get_tile(p2.x + 1, p2.y - 0.5),
				surface.get_tile(p2.x - 1, p2.y + 0.5),
				surface.get_tile(p2.x, p2.y + 0.5),
				surface.get_tile(p2.x + 1, p2.y + 0.5),
				surface.get_tile(p2.x - 1, p2.y + 1.5),
				surface.get_tile(p2.x, p2.y + 1.5),
				surface.get_tile(p2.x + 1, p2.y + 1.5),
			}

			local can_place = true
			for _, tile in ipairs(existing_tiles) do
				if tile and tile.valid and not find(common.ROCK_TILES, tile.name) then
					can_place = false
				end
			end

			if can_place then
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

					if e and e.valid then
						e.minable_flag = false
						e.destructible = false

						local inv = e.get_inventory(defines.inventory.chest)
						if inv and inv.valid then
							inv.insert({ name = "iron-stick", count = 1 })
						end

						-- radiative_towers.register_heating_tower(e)
						radiative_towers.register_heating_tower_contracted(e)
					end
				end
			end
		end
	end
end

function Private.create_cryo_plants(surface, area)
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

			local frozen = true
			local name = frozen and "cerys-fulgoran-cryogenic-plant-wreck-frozen"
				or "cerys-fulgoran-cryogenic-plant-wreck"

			local p3 = surface.find_non_colliding_position(name, p2, 7, 3)

			if p3 then
				local tiles = {}
				for dx = -2, 2 do
					for dy = -2, 2 do
						table.insert(tiles, {
							name = "concrete",
							position = { x = math.floor(p3.x) + dx, y = math.floor(p3.y) + dy },
						})
					end
				end
				surface.set_tiles(tiles, true)

				local e = surface.create_entity({
					name = name,
					position = p3,
					force = "player",
				})

				if e and e.valid then
					e.minable_flag = false
					e.destructible = false
					repair.register_ancient_cryogenic_plant(e, true)
				end
			end
		end
	end
end

function Private.create_crushers(surface, area)
	for _, p in ipairs(crusher_positions) do
		if
			p.x >= area.left_top.x
			and p.x < area.right_bottom.x
			and p.y >= area.left_top.y
			and p.y < area.right_bottom.y
		then
			local p2 = { x = p.x + 0.5, y = p.y }

			local colliding_simple_entities = surface.find_entities_filtered({
				type = "simple-entity",
				area = {
					left_top = { x = p2.x - 1.5, y = p2.y - 1 },
					right_bottom = { x = p2.x + 1.5, y = p2.y + 1 },
				},
			})
			for _, entity in ipairs(colliding_simple_entities) do
				entity.destroy()
			end

			local p3 = surface.find_non_colliding_position("crusher", p2, 7, 3)

			if p3 then
				local tiles = {}
				for dx = -1, 1 do
					for dy = -1, 0 do
						table.insert(tiles, {
							name = "concrete",
							position = { x = math.floor(p3.x) + dx, y = math.floor(p3.y) + dy },
						})
					end
				end
				surface.set_tiles(tiles, true)

				local e = surface.create_entity({
					name = "crusher",
					position = p3,
					force = "player",
					direction = defines.direction.east,
				})

				if e and e.valid then
					e.minable_flag = false
					e.destructible = false
				end
			end
		end
	end
end

function Private.create_lithium_brine(surface, area)
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
			surface.create_entity({
				name = "lithium-brine",
				position = position,
				amount = 100000000000,
			})
		end
	end
end

return Public
