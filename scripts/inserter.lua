local lib = require("lib")
local find = lib.find

local Public = {}

function Public.register_inserter(entity)
	storage.cerys_inserters = storage.cerys_inserters or {}

	storage.cerys_inserters[entity.unit_number] = {
		entity = entity,
	}
	entity.use_filters = true
end

local function flip_inserter_filter(inserter)
	inserter.use_filters = true

	local current_filter = inserter.get_filter(1)
	if current_filter and current_filter.name == "cerys-metastable-module-decayed" then
		inserter.set_filter(1, "cerys-metastable-module-charged")
	else
		inserter.set_filter(1, "cerys-metastable-module-decayed")
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

local function is_valid_module_machine(entity)
	if not entity then
		return false
	end

	local prototype = entity.prototype
	local type = prototype.type

	local is_furnace = type == "furnace"
	local is_assembling_machine = type == "assembling-machine"
	local is_rocket_silo = type == "rocket-silo"
	local is_lab = type == "lab"

	if not (is_furnace or is_assembling_machine or is_rocket_silo or is_lab) then
		return false
	end

	-- Quality can add module slots:
	-- if not (prototype.module_inventory_size and prototype.module_inventory_size > 0) then
	-- 	return false
	-- end

	if is_assembling_machine or is_rocket_silo then
		local recipe = entity.get_recipe()

		if not recipe then
			return false
		end

		local allowed_in_effects = recipe.prototype.allowed_effects["productivity"]

		if not allowed_in_effects then
			return false
		end

		local allowed_in_categories = not (
			recipe.prototype.allowed_module_categories
			and not recipe.prototype.allowed_module_categories["productivity"]
		)

		if not allowed_in_categories then
			return false
		end
	end

	return true
end

local function adjust_inserter_to_match_machine(inserter, machine)
	local module_inv_size = machine.prototype and machine.prototype.module_inventory_size or 0

	if not (module_inv_size and module_inv_size > 0) then
		return
	end

	local inv = machine.get_module_inventory()
	if not inv then
		return
	end

	local total_items = inv.get_item_count()

	local has_empty_slot = total_items < module_inv_size
	local decayed_count = inv.get_item_count("cerys-metastable-module-decayed")
	local charged_count = inv.get_item_count("cerys-metastable-module-charged")

	local decayed_held = inserter.held_stack
			and inserter.held_stack.valid_for_read
			and inserter.held_stack.name == "cerys-metastable-module-decayed"
			and inserter.held_stack.count
		or 0

	local desired_filter
	local desired_direction
	local desired_inserter_stack_size_override

	local dx = machine.position.x - inserter.position.x
	local dy = machine.position.y - inserter.position.y
	local toward_dir
	if math.abs(dx) > math.abs(dy) then
		toward_dir = (dx < 0) and 4 or 12
	else
		toward_dir = (dy < 0) and 8 or 0
	end

	if has_empty_slot and decayed_held <= 0 then
		desired_filter = "cerys-metastable-module-charged"
		desired_direction = toward_dir
		desired_inserter_stack_size_override = module_inv_size - total_items
	elseif charged_count > 0 or decayed_count > 0 or decayed_held > 0 then
		desired_filter = "cerys-metastable-module-decayed"
		desired_direction = (toward_dir + 8) % 16 -- Opposite cardinal direction
		desired_inserter_stack_size_override = decayed_count + decayed_held
	end

	local current_filter = inserter.get_filter(1)

	if desired_filter then
		if not current_filter or current_filter.name ~= desired_filter then
			inserter.set_filter(1, desired_filter)
		end
		if inserter.direction ~= desired_direction then
			inserter.direction = desired_direction
		end
		if desired_inserter_stack_size_override then
			inserter.inserter_stack_size_override = desired_inserter_stack_size_override
		else
			inserter.inserter_stack_size_override = 0
		end
	end
end

local function adjust_inserter(inserter_data)
	local inserter = inserter_data.entity

	local proxy_for_drop = inserter.drop_target
		and inserter.drop_target.valid
		and inserter.drop_target.name == "cerys-proxy-drop"
		and inserter.drop_target

	local proxy_for_drop_target = (proxy_for_drop and is_valid_module_machine(proxy_for_drop.proxy_target_entity))
		and proxy_for_drop

	if proxy_for_drop and not proxy_for_drop_target then
		proxy_for_drop.destroy()
		inserter_data.drop_proxy = nil
	end

	local new_machine_for_drop = (
		inserter.drop_target
		and inserter.drop_target.valid
		and is_valid_module_machine(inserter.drop_target)

	) and inserter.drop_target

	if new_machine_for_drop then
		proxy_for_drop = inserter.surface.create_entity({
			name = "cerys-proxy-drop",
			position = inserter.drop_position,
			force = inserter.force,
			create_build_effect_smoke = false,
			preserve_ghosts_and_corpses = true,
		})
		proxy_for_drop.proxy_target_entity = inserter.drop_target
		proxy_for_drop.proxy_target_inventory = defines.inventory.crafter_modules
		inserter.drop_target = proxy_for_drop
		inserter_data.drop_proxy = proxy_for_drop
	end

	local valid_drop_machine = proxy_for_drop and proxy_for_drop.valid and proxy_for_drop.proxy_target_entity

	local proxy_for_pickup = inserter.pickup_target
		and inserter.pickup_target.valid
		and inserter.pickup_target.name == "cerys-proxy-pickup"
		and inserter.pickup_target

	local proxy_for_pickup_target = (proxy_for_pickup and is_valid_module_machine(proxy_for_pickup.proxy_target_entity))
		and proxy_for_pickup

	if proxy_for_pickup and not proxy_for_pickup_target then
		proxy_for_pickup.destroy()
		inserter_data.pickup_proxy = nil
	end

	local new_machine_for_pickup = (
		inserter.pickup_target
		and inserter.pickup_target.valid
		and is_valid_module_machine(inserter.pickup_target)

	) and inserter.pickup_target

	if new_machine_for_pickup then
		proxy_for_pickup = inserter.surface.create_entity({
			name = "cerys-proxy-pickup",
			position = inserter.pickup_position,
			force = inserter.force,
			create_build_effect_smoke = false,
			preserve_ghosts_and_corpses = true,
		})
		proxy_for_pickup.proxy_target_entity = inserter.pickup_target
		proxy_for_pickup.proxy_target_inventory = defines.inventory.crafter_modules
		inserter.pickup_target = proxy_for_pickup
		inserter_data.pickup_proxy = proxy_for_pickup
	end

	local valid_pickup_machine = proxy_for_pickup and proxy_for_pickup.valid and proxy_for_pickup.proxy_target_entity

	local machine
	if valid_drop_machine then
		machine = valid_drop_machine
	elseif valid_pickup_machine then
		machine = valid_pickup_machine
	end

	if machine then
		adjust_inserter_to_match_machine(inserter, machine)
	else
		inserter.set_filter(1, nil)
	end
end

function Public.tick_inserters()
	for unit_number, inserter_data in pairs(storage.cerys_inserters or {}) do
		local inserter = inserter_data.entity

		if inserter and inserter.valid then
			adjust_inserter(inserter_data)
		else
			if inserter_data.drop_proxy and inserter_data.drop_proxy.valid then
				inserter_data.drop_proxy.destroy()
			end
			if inserter_data.pickup_proxy and inserter_data.pickup_proxy.valid then
				inserter_data.pickup_proxy.destroy()
			end
			storage.cerys_inserters[unit_number] = nil
		end
	end
end

return Public
