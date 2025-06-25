local simplex_noise = require("scripts.simplex_noise").d2
local find = require("lib").find
local cryogenic_plant = require("scripts.cryogenic-plant")
local crusher = require("scripts.crusher")
local teleporter = require("scripts.teleporter")
local common = require("common")

local Public = {}

--== Entity positions ==--

local hex_scale = 22
local max_radius = common.CERYS_RADIUS * 4 -- Accounting for possible ribbonworlds

local hex_width = hex_scale
local hex_height = hex_scale * math.sqrt(3)
local col_offset = hex_width * 3 / 4 -- Horizontal distance between columns
local row_offset = hex_height / 2 -- Vertical offset for every other column

local max_cols = math.ceil(2 * max_radius / col_offset)
local max_rows = math.ceil(2 * max_radius / hex_height)

local function hex_grid_positions(args)
	local seed = args.seed
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

-- The following seeds aren't easy to get right. You need to put several plants in the final area, and not leave any plants with awkward heating coverage that trick the player into heating them up when they don't work. Radiative heaters should be able to reach the reactor, but only just, so the reactor doesn't heat too quickly after you turn them on. This all depends on the water seed. Ideally, the game should also be playable on ribbonworld.

local tower_positions = hex_grid_positions({
	seed = 2104,
	grid_scale = 1.07,
	noise_size = 40,
	noise_scale = 500,
})

local cryo_plant_positions = hex_grid_positions({
	seed = 4100,
	grid_scale = 2,
	displacement = { x = 2, y = -3.5 },
	noise_size = 17,
	noise_scale = 100,
})

local crusher_positions = hex_grid_positions({
	seed = 1400,
	grid_scale = 3.7,
	noise_size = 15,
	displacement = { x = 20, y = -20 },
	noise_scale = 240,
})

--== Terrain & entity generation ==--

function Public.on_cerys_chunk_generated(event, surface)
	local area = event.area
	local tiles = {}
	local entities = {}
	local decoratives = {}
	local hidden_tiles = {}

	local seed = event.surface.map_gen_settings.seed
	local stretch_factor = common.get_cerys_surface_stretch_factor(surface)
	local semimajor_axis = common.get_cerys_semimajor_axis(surface)

	--== Empty space ==--

	for x = area.left_top.x, area.right_bottom.x - 1 do
		for y = area.left_top.y, area.right_bottom.y - 1 do
			if x ^ 2 + y ^ 2 < (semimajor_axis * 1.5) ^ 2 then
				local existing_tile = surface.get_tile(x, y)
				local existing_tile_name = existing_tile and existing_tile.valid and existing_tile.name

				local is_surface = existing_tile_name ~= "empty-space"
					and existing_tile_name ~= "cerys-empty-space"
					and existing_tile_name ~= "cerys-empty-space-2"

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

	--== Structures ==--

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

	--== Reactor concrete ==--

	local adjusted_reactor_position = {
		x = math.ceil(common.REACTOR_POSITION_SEED.x),
		y = math.ceil(common.REACTOR_POSITION_SEED.y / stretch_factor),
	}

	if
		adjusted_reactor_position.x >= area.left_top.x
		and adjusted_reactor_position.x < area.right_bottom.x
		and adjusted_reactor_position.y >= area.left_top.y
		and adjusted_reactor_position.y < area.right_bottom.y
	then
		Public.ensure_solid_foundation(surface, adjusted_reactor_position, 34, 24)
	end

	--== Other ==--

	surface.create_decoratives({ check_collision = true, decoratives = decoratives })

	Public.create_lithium_brine(surface, area)
end

--luacheck: ignore
function Public.terrain(x, y, seed, existing_tile, entities, tiles, decoratives, hidden_tiles)
	local new_tile = nil

	local is_rock = find(common.ROCK_TILES, existing_tile)

	if find(common.SPACE_TILES_AROUND_CERYS, existing_tile) then -- Ribbonworld etc
		if existing_tile ~= "cerys-empty-space-2" then
			new_tile = "cerys-empty-space-2"
		end
	elseif common.DEBUG_DISABLE_FREEZING then
		if existing_tile == "cerys-ice-on-water" then
			new_tile = "cerys-water-puddles"
		elseif existing_tile == "cerys-ash-cracks-frozen" then
			new_tile = "cerys-ash-cracks"
		elseif existing_tile == "cerys-ash-dark-frozen" then
			new_tile = "cerys-ash-dark"
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
			-- new_tile = "dirt-1"
			new_tile = "cerys-dry-ice-on-water"
		end
	end

	if new_tile then
		table.insert(tiles, { name = new_tile, position = { x = x, y = y } })
	end
end

function Public.create_towers(surface, area)
	local stretch_factor = common.get_cerys_surface_stretch_factor(surface)

	local positions = {}
	for _, p in ipairs(tower_positions) do
		local xx = p.x / stretch_factor
		local yy = p.y * stretch_factor

		if (((yy / 64) ^ 2) + (30 - xx) / 32) > 0 then
			table.insert(positions, p)
		end
	end

	if common.HARD_MODE_ON then
		-- needed to heat reactor:
		local displacement_from_corner = { x = -4, y = -2 }

		table.insert(positions, {
			x = math.ceil(common.REACTOR_POSITION_SEED.x) - 16 + displacement_from_corner.x,
			y = math.ceil(common.REACTOR_POSITION_SEED.y / stretch_factor) - 11 + displacement_from_corner.y,
		})
	else
		local displacement_from_corner = { x = 9, y = 2 }

		table.insert(positions, {
			x = math.ceil(common.REACTOR_POSITION_SEED.x) + 16 + displacement_from_corner.x,
			y = math.ceil(common.REACTOR_POSITION_SEED.y / stretch_factor) + 11 + displacement_from_corner.y,
		})
	end

	table.insert(positions, {
		x = 33.5,
		y = -41,
	})
	table.insert(positions, {
		x = -93.5,
		y = -80,
	})

	local positions_in_area = {}
	for _, p in ipairs(positions) do
		if
			p.x >= area.left_top.x
			and p.x < area.right_bottom.x
			and p.y >= area.left_top.y
			and p.y < area.right_bottom.y
		then
			table.insert(positions_in_area, p)
		end
	end

	for _, p in ipairs(positions_in_area) do
		local p2 = { x = p.x, y = p.y }

		Public.deal_with_existing_entities(surface, p2, 3, 4)

		if
			surface.can_place_entity({
				name = "cerys-fulgoran-radiative-tower-contracted-container",
				position = p2,
				force = "player",
			})
		then
			Public.ensure_solid_foundation(surface, p2, 3, 4)

			local e = surface.create_entity({
				name = "cerys-fulgoran-radiative-tower-contracted-container",
				position = p2,
				force = "player",
			})
			script.raise_script_built({ entity = e })

			if e and e.valid then
				e.minable_flag = false
				e.destructible = false
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

			Public.deal_with_existing_entities(surface, p2, 5, 5)

			local p3 = surface.find_non_colliding_position("cerys-fulgoran-cryogenic-plant-wreck-frozen", p2, 1.5, 1.2) -- searching too far will bias cryogenic plants to spawn on the edge of the moon

			if p3 then
				Public.ensure_solid_foundation(surface, p3, 5, 5)

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

function Public.create_teleporter()
	local surface = game.surfaces["cerys"]
	if not (surface and surface.valid) then
		return
	end

	local p = {
		x = common.TELEPORTER_POSITION_SEED.x,
		y = common.TELEPORTER_POSITION_SEED.y,
	}

	local p2 = surface.find_non_colliding_position("cerys-fulgoran-teleporter-frozen", p, 100, 1) or p

	Public.ensure_solid_foundation(surface, p2, 7, 7)

	local e = surface.create_entity({
		name = "cerys-fulgoran-teleporter-frozen",
		position = p2,
		force = "player",
	})

	if e and e.valid then
		e.minable_flag = false
		e.destructible = false
		teleporter.register_frozen_teleporter(e)
	end

	return e
end

function Public.create_crushers(surface, area)
	for _, p in ipairs(crusher_positions) do -- Fortunately these positions also work on ribbonworlds
		if
			p.x >= area.left_top.x
			and p.x < area.right_bottom.x
			and p.y >= area.left_top.y
			and p.y < area.right_bottom.y
		then
			local p2 = { x = p.x, y = p.y }

			Public.deal_with_existing_entities(surface, p2, 4, 3)

			local p3 = surface.find_non_colliding_position("cerys-fulgoran-crusher-wreck-frozen", p2, 3, 3)

			if p3 then
				Public.ensure_solid_foundation(surface, { x = p3.x, y = p3.y }, 4, 3)

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

function Public.deal_with_existing_entities(surface, position, width, height)
	local colliding_characters = surface.find_entities_filtered({
		type = "character",
		area = {
			left_top = { x = position.x - width / 2, y = position.y - height / 2 },
			right_bottom = { x = position.x + width / 2, y = position.y + height / 2 },
		},
	})
	for _, character in ipairs(colliding_characters) do
		local desired_position = {
			x = character.position.x - 6,
			y = character.position.y - 6,
		}

		local new_position = surface.find_non_colliding_position("character", desired_position, 1, 1)
			or desired_position

		character.teleport(new_position)
	end

	local colliding_entities = surface.find_entities_filtered({
		area = {
			left_top = { x = position.x - width / 2, y = position.y - height / 2 },
			right_bottom = { x = position.x + width / 2, y = position.y + height / 2 },
		},
	})
	for _, entity in ipairs(colliding_entities) do
		if entity.prototype.type and entity.prototype.type ~= "assembling-machine" then
			entity.destroy()
		end
	end
end

function Public.create_lithium_brine(surface, area)
	local adjusted_lithium_position = {
		x = common.LITHIUM_ACTUAL_POSITION.x,
		y = common.LITHIUM_ACTUAL_POSITION.y,
	}

	if
		not (
			adjusted_lithium_position.x >= area.left_top.x
			and adjusted_lithium_position.x < area.right_bottom.x
			and adjusted_lithium_position.y >= area.left_top.y
			and adjusted_lithium_position.y < area.right_bottom.y
		)
	then
		return
	end

	local stretch_factor = common.get_cerys_surface_stretch_factor(surface)

	for _ = 1, 10 do
		local angle = math.random() * 2 * math.pi
		local d = ((math.random()) ^ (1 / 2)) * 58
		local test_pos = {
			x = adjusted_lithium_position.x + math.cos(angle) * d / 3 * stretch_factor,
			y = adjusted_lithium_position.y + math.sin(angle) * d / stretch_factor,
		}

		local position = surface.find_non_colliding_position("lithium-brine", test_pos, 5, 1)

		if position then
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
	for dx = -width / 2 + 0.5, width / 2 - 0.5 do
		for dy = -height / 2 + 0.5, height / 2 - 0.5 do
			local x, y = center.x + dx, center.y + dy
			local tile_underneath = surface.get_tile(x, y)
			local tile_underneath_is_water = tile_underneath
				and (tile_underneath.name == "cerys-dry-ice-on-water" or tile_underneath.name == "cerys-ice-on-water")

			if tile_underneath_is_water then
				table.insert(tiles, {
					name = "cerys-concrete",
					position = { x = x, y = y },
				})
			end
		end
	end
	surface.set_tiles(tiles, true)
end

return Public
