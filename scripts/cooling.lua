local Public = {}

local TEMPERATURE_LOSS_RATE = 0.12

local function get_position_key(position)
	return (position.x + 0.5) .. "," .. (position.y + 0.5)
end

function Public.register_heat_pipe(entity)
	if not storage.cerys then
		return
	end

	if not (entity and entity.valid) then
		return
	end

	if not storage.cerys.heat_pipes then
		storage.cerys.heat_pipes = {}
	end

	local pos_key = get_position_key(entity.position)

	storage.cerys.heat_pipes[pos_key] = entity
end

function Public.register_boiler(entity)
	if not storage.cerys then
		return
	end

	if not (entity and entity.valid) then
		return
	end

	if not storage.cerys.boilers then
		storage.cerys.boilers = {}
	end

	storage.cerys.boilers[entity.unit_number] = entity
end

local function get_heat_pipe_cooling_multiplier(entity)
	local multiplier = 1.6
	local pos = entity.position

	local neighbors = {
		{ x = pos.x, y = pos.y - 1 },
		{ x = pos.x, y = pos.y + 1 },
		{ x = pos.x - 1, y = pos.y },
		{ x = pos.x + 1, y = pos.y },
	}

	for _, neighbor_pos in pairs(neighbors) do
		local pos_key = get_position_key(neighbor_pos)
		if storage.cerys.heat_pipes[pos_key] then
			multiplier = multiplier - 0.3
		end
	end

	return multiplier
end

function Public.tick_60_cool_heat_entities()
	if not storage.cerys then
		return
	end

	if storage.cerys.heat_pipes then
		local invalid_entities = {}
		for pos_key, entity in pairs(storage.cerys.heat_pipes) do
			if entity.valid and entity.temperature then
				if entity.temperature > 15 then
					local effective_cooling = TEMPERATURE_LOSS_RATE * get_heat_pipe_cooling_multiplier(entity)
					entity.temperature = math.max(15, entity.temperature - effective_cooling)
				end
			else
				table.insert(invalid_entities, pos_key)
			end
		end

		for _, pos_key in pairs(invalid_entities) do
			storage.cerys.heat_pipes[pos_key] = nil
		end
	end

	if storage.cerys.boilers then
		local invalid_entities = {}
		for unit_number, entity in pairs(storage.cerys.boilers) do
			if entity.valid and entity.temperature then
				if entity.temperature > 15 then
					entity.temperature = math.max(15, entity.temperature - TEMPERATURE_LOSS_RATE)
				end
			else
				table.insert(invalid_entities, unit_number)
			end
		end

		for _, unit_number in pairs(invalid_entities) do
			storage.cerys.boilers[unit_number] = nil
		end
	end
end

return Public
