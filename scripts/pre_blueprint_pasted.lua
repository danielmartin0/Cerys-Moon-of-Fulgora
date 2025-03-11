local rods = require("scripts.charging-rod")

-- This code is adapted from bunshaman's library. For its MIT license, please see https://opensource.org/license/mit. Obviously it is excluded from the license of this mod.
-- This code still has bugs including when pasting multiple charging rods in the same blueprint.
-- Hopefully Factorio will support this event later so that we can replace this code.

local Public = {}

local function rotate_point(point, axis, clockwise)
	clockwise = clockwise or false
	point = { x = point[1] or point.x, y = point[2] or point.y }
	axis = { x = axis[1] or axis.x or 0, y = axis[2] or axis.y or 0 }

	-- Translate the point so the axis is the origin
	local x = point.x - axis.x
	local y = point.y - axis.y

	local rotated_point
	if clockwise == true then
		-- Apply 90-degree clockwise rotation
		local new_x = -y
		local new_y = x
		-- Translate back to the original axis
		rotated_point = { x = new_x + axis.x, y = new_y + axis.y }
	else
		-- Apply 90-degree counter-clockwise rotation
		local new_x = y
		local new_y = -x
		-- Translate back to the original axis
		rotated_point = { x = new_x + axis.x, y = new_y + axis.y }
	end
	return rotated_point
end

local function rotate_box(corner1, corner2, axis, clockwise)
	corner1 = { x = corner1[1] or corner1.x, y = corner1[2] or corner1.y }
	corner2 = { x = corner2[1] or corner2.x, y = corner2[2] or corner2.y }
	if axis == nil then
		axis = { x = (corner2.x + corner1.x) / 2, y = (corner2.y + corner1.y) / 2 }
	else
		axis = { x = axis[1] or axis.x, y = axis[2] or axis.y }
	end
	clockwise = clockwise or false

	local left_top
	local right_bottom
	left_top = rotate_point(corner1, axis, clockwise)
	right_bottom = rotate_point(corner2, axis, clockwise)

	-- Rotating the box does technically mean the left_top and right_bottom aren't exactly in the right positions...
	if left_top.x > right_bottom.x then
		local temp = left_top.x
		left_top.x = right_bottom.x
		right_bottom.x = temp
	end
	if left_top.y > right_bottom.y then
		local temp = left_top.y
		left_top.y = right_bottom.y
		right_bottom.y = temp
	end
	return left_top, right_bottom
end

local function round(number, place)
	place = place or 0
	place = 10 ^ place
	if number >= 0 then
		return math.floor(number * place + 0.5) / place
	else
		return math.ceil(number * place - 0.5) / place
	end
end

local function ceil(number, place)
	place = place or 0
	place = 10 ^ place
	return (math.ceil(number * place) / place)
end

local function get_pasted_position(mouse_pos, center_pos, entity, direction, flip_horizontal, flip_vertical)
	direction = direction or 0
	flip_horizontal = flip_horizontal or false
	flip_vertical = flip_vertical or false
	local relative_x = ceil((entity.position.x - center_pos.x), 1)
	local relative_y = ceil((entity.position.y - center_pos.y), 1)

	local rotated_point
	-- If the blueprint was flipped in any direction, gotta handle it here.
	if flip_horizontal then
		relative_x = -relative_x
	end
	if flip_vertical then
		relative_y = -relative_y
	end
	while direction >= 4 do
		rotated_point = rotate_point({ x = relative_x, y = relative_y }, { 0, 0 }, true)
		relative_x = rotated_point.x
		relative_y = rotated_point.y
		direction = direction - 4
	end

	local selection_box = prototypes.entity[entity.name].selection_box ----------------------------- Check cache here

	-- Need to round positions depending on the entities selection box (so the centers are properly placed)
	local pasted_x
	local pasted_y

	if (math.ceil(selection_box.right_bottom.x - selection_box.left_top.x) % 2) == 0 then -- Even
		pasted_x = round(mouse_pos.x + relative_x)
	else
		pasted_x = math.floor(mouse_pos.x + relative_x) + 0.5
	end
	if (math.ceil(selection_box.right_bottom.y - selection_box.left_top.y) % 2) == 0 then -- Even
		pasted_y = round(mouse_pos.y + relative_y)
	else
		pasted_y = math.floor(mouse_pos.y + relative_y) + 0.5
	end

	return { x = pasted_x, y = pasted_y }
end

local function get_blueprint_bounding_box(blueprint)
	local left_top_x = blueprint[1].position.x
	local left_top_y = blueprint[1].position.y
	local right_bottom_x = blueprint[1].position.x
	local right_bottom_y = blueprint[1].position.y

	for _, component in pairs(blueprint) do
		if component.entity_number then -- If entity
			local selection_box = prototypes.entity[component.name].selection_box ------------------------------------- cache here as well!

			-- If a pasted entity is rotated, it will have its own extra direction
			local entity_direction = component.direction
			if entity_direction and entity_direction % 4 == 0 then
				while entity_direction >= 4 do
					selection_box.left_top, selection_box.right_bottom =
						rotate_box(selection_box.left_top, selection_box.right_bottom, { 0, 0 }, false)

					entity_direction = entity_direction - 4 -- Rotate 90 degrees counter-clockwise
				end
			end

			-- Expand the bounding box
			if component.position.x + selection_box.left_top.x < left_top_x then
				left_top_x = component.position.x + selection_box.left_top.x
			end
			if component.position.x + selection_box.right_bottom.x > right_bottom_x then
				right_bottom_x = component.position.x + selection_box.right_bottom.x
			end
			if component.position.y + selection_box.left_top.y < left_top_y then
				left_top_y = component.position.y + selection_box.left_top.y
			end
			if component.position.y + selection_box.right_bottom.y > right_bottom_y then
				right_bottom_y = component.position.y + selection_box.right_bottom.y
			end
		else -- If tile
			-- Expand the bounding box
			if component.position.x < left_top_x then
				left_top_x = component.position.x
			end
			if component.position.x + 1 > right_bottom_x then
				right_bottom_x = component.position.x + 1
			end
			if component.position.y < left_top_y then
				left_top_y = component.position.y
			end
			if component.position.y + 1 > right_bottom_y then
				right_bottom_y = component.position.y + 1
			end
		end
	end

	local left_top = { x = left_top_x, y = left_top_y }
	local right_bottom = { x = right_bottom_x, y = right_bottom_y }

	return left_top, right_bottom
end

local function get_center_of_coordinates(corner1, corner2)
	local corner1_x = corner1.x or corner1[1]
	local corner1_y = corner1.y or corner1[2]
	local corner2_x = corner2.x or corner2[1]
	local corner2_y = corner2.y or corner2[2]

	local x = corner1_x + (corner2_x - corner1_x) / 2
	local y = corner1_y + (corner2_y - corner1_y) / 2
	return { x = x, y = y }
end

function Public.on_pre_build(event)
	local player = game.players[event.player_index] -- Player who placed the blueprint
	local mouse_pos = event.position -- Position of the MOUSE when placing the blueprint.
	local direction = event.direction

	if not player.is_cursor_blueprint() then
		return
	end
	local cursor_stack = player.cursor_stack
	if cursor_stack.valid_for_read == false then
		return
	end

	if cursor_stack.name ~= "blueprint" then
		-- TODO: Handle blueprint books
		return
	end

	local blueprint_entities = cursor_stack.get_blueprint_entities() -- Blueprint entities has the format of {{entity_number = 1, name = 1, position = {1,1}}, {entity_number = 2, name = 2, position = {2,2}}}
	if blueprint_entities == nil then
		return
	end

	local left_top, right_bottom = get_blueprint_bounding_box(blueprint_entities)

	-- Get the center_pos of the blueprint selection. This is from where the original entities are. Treat mouse_pos as the "new" center_pos
	local center_pos
	if left_top and right_bottom then
		center_pos = get_center_of_coordinates(left_top, right_bottom)
	else
		return
	end

	-- Rotate the bounding box about the "center_pos" depending on the direction of the placement.
	while direction >= 4 do
		left_top, right_bottom = rotate_box(left_top, right_bottom, center_pos, false)
		direction = direction - 4
	end

	if (math.ceil(right_bottom.x - left_top.x) % 2) == 0 then
		mouse_pos.x = math.floor(mouse_pos.x + 0.5) -- Snap to edge
	else
		mouse_pos.x = math.floor(mouse_pos.x) + 0.5 -- Snap to center
	end
	if (math.ceil(right_bottom.y - left_top.y) % 2) == 0 then
		mouse_pos.y = math.floor(mouse_pos.y + 0.5) -- Snap to edge
	else
		mouse_pos.y = math.floor(mouse_pos.y) + 0.5 -- Snap to center
	end

	local pasted_positions = {}
	for entity_index, entity in pairs(blueprint_entities) do
		if
			not (
				entity.type == "car"
				or entity.type == "spider-vehicle"
				or entity.type == "locomotive"
				or entity.type == "cargo-wagon"
				or entity.type == "fluid-wagon"
				or entity.type == "artillery-wagon"
			)
		then
			pasted_positions[entity_index] = get_pasted_position(
				mouse_pos,
				center_pos,
				entity,
				event.direction,
				event.flip_horizontal,
				event.flip_vertical
			)
		end
	end

	local surface = player.surface

	for entity_index, position in pairs(pasted_positions) do
		local entity = blueprint_entities[entity_index]

		if entity.name == "cerys-charging-rod" then
			local existing_rod = surface.find_entity("cerys-charging-rod", position)

			if
				existing_rod
				and existing_rod.valid
				and existing_rod.position.x == position.x
				and existing_rod.position.y == position.y
			then
				entity.tags = entity.tags or {}
				rods.rod_set_state(existing_rod, entity.tags.is_negative)

				local rod_data = storage.cerys.charging_rods[existing_rod.unit_number]
				if rod_data then
					if entity.tags.circuit_controlled then
						rod_data.circuit_controlled = entity.tags.circuit_controlled
					end
					if entity.tags.control_signal then
						rod_data.control_signal = entity.tags.control_signal
					end
				end
			end
		end
	end

	return pasted_positions
end

return Public
