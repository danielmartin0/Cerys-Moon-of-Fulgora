local common = require("common")

local Public = {}

local TEMPERATURE_LOSS_RATE = 0.3
local TEMPERATURE_ZERO = 15

local function cool_entity(entity, cooling_rate)
	if entity.temperature > TEMPERATURE_ZERO then
		entity.temperature = math.max(TEMPERATURE_ZERO, entity.temperature - cooling_rate)
	end
end

local function get_batch_parameters()
	if not storage.cerys or not storage.cerys.heat_pipes then
		return 1, 0 -- 1 batch, 0 pipes
	end

	local pipe_count = #storage.cerys.heat_pipes

	local num_batches = math.ceil(math.max(1, math.log(pipe_count / 50, 2)))

	return num_batches, pipe_count
end

local function recreate_heat_pipes_array()
	if not storage.cerys or not storage.cerys.heat_pipes then
		return
	end

	local valid_pipes = {}
	for _, entity in pairs(storage.cerys.heat_pipes) do
		if entity.valid then
			table.insert(valid_pipes, entity)
		end
	end

	storage.cerys.heat_pipes = valid_pipes
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

	storage.cerys.heat_pipes[#storage.cerys.heat_pipes + 1] = entity
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

function Public.tick_60_cool_heat_pipes()
	if not storage.cerys then
		return
	end

	if not storage.cerys.heat_pipes then
		return
	end

	-- Process heat pipes in batches using skip logic

	local num_batches, pipe_count = get_batch_parameters()

	if pipe_count > 0 then
		-- Get current batch index from storage
		if not storage.cerys.current_batch_index then
			storage.cerys.current_batch_index = 0
		end
		local current_batch = storage.cerys.current_batch_index

		-- Cycle to next batch
		current_batch = current_batch + 1
		if current_batch > num_batches then
			current_batch = 1
		end

		storage.cerys.current_batch_index = current_batch

		-- Calculate batch size and starting index
		local batch_size = math.ceil(pipe_count / num_batches)
		local start_index = (current_batch - 1) * batch_size + 1
		local end_index = math.min(start_index + batch_size - 1, pipe_count)

		-- Process current batch
		local invalid_entities_found = false
		local cooling_multiplier = num_batches -- Scale cooling by number of batches

		for i = start_index, end_index do
			local entity = storage.cerys.heat_pipes[i]
			if entity and entity.valid and entity.temperature then
				local effective_cooling = TEMPERATURE_LOSS_RATE
					* get_heat_pipe_cooling_multiplier(entity)
					* cooling_multiplier
				cool_entity(entity, effective_cooling)
			elseif entity then
				invalid_entities_found = true
			end
		end

		-- If invalid entities were found, recreate the array
		if invalid_entities_found then
			recreate_heat_pipes_array()
		end
	end
end

function Public.tick_60_cool_boilers()
	if not storage.cerys then
		return
	end

	if not storage.cerys.boilers then
		return
	end

	local invalid_entities = {}
	for unit_number, entity in pairs(storage.cerys.boilers) do
		if entity.valid and entity.temperature then
			cool_entity(entity, TEMPERATURE_LOSS_RATE)
		else
			table.insert(invalid_entities, unit_number)
		end
	end

	for _, unit_number in pairs(invalid_entities) do
		storage.cerys.boilers[unit_number] = nil
	end
end

function Public.cool_reactor(reactor_entity, tick_interval)
	local rate = common.REACTOR_COOLING_PER_SECOND * math.max(0.2, 1 - 0.1 * reactor_entity.quality.level)
	local cooling_amount = rate * (tick_interval / 60)

	cool_entity(reactor_entity, cooling_amount)
end

return Public
