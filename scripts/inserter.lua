local lib = require("lib")
local find = lib.find

local Public = {}

function Public.register_inserter(entity)
	storage.cerys_inserters = storage.cerys_inserters or {}
	storage.cerys_inserters[entity.unit_number] = {
		entity = entity,
	}
	entity.use_filters = true
	-- Default to metastable-module-1; the periodic logic will correct this on the next evaluation
	entity.set_filter(1, "cerys-metastable-module-1")
end

local function flip_inserter_filter(inserter)
	inserter.use_filters = true

	local current_filter = inserter.get_filter(1)
	if current_filter and current_filter.name == "cerys-metastable-module-1" then
		inserter.set_filter(1, "cerys-metastable-module-2")
	else
		inserter.set_filter(1, "cerys-metastable-module-1")
	end
end

function Public.on_inserter_flipped(entity)
	if entity.name == "cerys-radiation-proof-inserter" then
		flip_inserter_filter(entity)
	end
end

function Public.on_inserter_gui_opened(player)
	player.opened = nil
end

function Public.tick_inserters()
	for unit_number, inserter_data in pairs(storage.cerys_inserters or {}) do
		local inserter = inserter_data.entity

		if inserter and inserter.valid then
			Public.process_inserter(inserter)
		else
			storage.cerys_inserters[unit_number] = nil
		end
	end
end

function Public.process_inserter(inserter)
	local valid_drop_target = (
		inserter.drop_target
		and inserter.drop_target.valid
		and inserter.drop_target.prototype.type == "assembling-machine"
		and inserter.drop_target.get_recipe()

	) and inserter.drop_target

	local valid_pickup_target = (
		inserter.pickup_target
		and inserter.pickup_target.valid
		and inserter.pickup_target.prototype.type == "assembling-machine"
		and inserter.pickup_target.get_recipe()
	) and inserter.pickup_target

	local machine
	if valid_drop_target and not valid_pickup_target then
		machine = valid_drop_target
	elseif valid_pickup_target and not valid_drop_target then
		machine = valid_pickup_target
	end

	if not machine then
		return
	end

	local module_inv_size = machine.prototype and machine.prototype.module_inventory_size or 0

	if not (module_inv_size and module_inv_size > 0) then
		return
	end

	local inv = machine.get_module_inventory()
	if not inv then
		return
	end

	local module1 = "cerys-metastable-module-1"
	local module2 = "cerys-metastable-module-2"

	local total_items = inv.get_item_count()
	local metastable_count = inv.get_item_count(module1) + inv.get_item_count(module2)

	local has_empty_slot = total_items < module_inv_size
	local has_metastable = metastable_count > 0

	local desired_filter
	local desired_direction

	local dx = machine.position.x - inserter.position.x
	local dy = machine.position.y - inserter.position.y
	local toward_dir
	if math.abs(dx) > math.abs(dy) then
		toward_dir = (dx < 0) and 4 or 12
	else
		toward_dir = (dy < 0) and 8 or 0
	end

	if has_empty_slot then
		desired_filter = module2
		desired_direction = toward_dir
	elseif has_metastable then
		desired_filter = module1
		desired_direction = (toward_dir + 8) % 16 -- Opposite cardinal direction
	end

	local current_filter = inserter.get_filter(1)

	if desired_filter then
		if not inserter.get_filter(1) or inserter.get_filter(1).name ~= desired_filter then
			inserter.set_filter(1, desired_filter)
		end
		if inserter.direction ~= desired_direction then
			inserter.direction = desired_direction
		end
	end
end

return Public
