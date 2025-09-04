local Public = {}

local TEMPERATURE_LOSS_RATE = 0.3

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

	storage.cerys.heat_pipes[entity.unit_number] = entity
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

	-- Use the new heat_neighbours API to find neighboring heat entities
	local neighbors = entity.heat_neighbours
	if neighbors then
		for _, neighbor in pairs(neighbors) do
			if neighbor.valid and neighbor.temperature then
				multiplier = multiplier - 0.3
			end
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
		for unit_number, entity in pairs(storage.cerys.heat_pipes) do
			if entity.valid and entity.temperature then
				if entity.temperature > 15 then
					local effective_cooling = TEMPERATURE_LOSS_RATE * get_heat_pipe_cooling_multiplier(entity)
					entity.temperature = math.max(15, entity.temperature - effective_cooling)
				end
			else
				table.insert(invalid_entities, unit_number)
			end
		end

		for _, unit_number in pairs(invalid_entities) do
			storage.cerys.heat_pipes[unit_number] = nil
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
