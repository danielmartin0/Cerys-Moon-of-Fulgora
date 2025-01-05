local Public = {}

local CHARGING_ROD_DISPLACEMENT = 0 -- Anything other than 0 tends to lead to player confusion.
local GUI_KEY = "cerys-gui-charging-rod"
local GUI_KEY_GHOST = "cerys-gui-charging-rod-ghost"

Public.built_charging_rod = function(entity, tags)
	if not (entity and entity.valid) then
		return
	end

	Public.register_charging_rod(entity)

	if tags and tags.is_negative ~= nil then
		Public.rod_set_state(entity, tags.is_negative)
	end
end

Public.robot_built_charging_rod = function(entity, tags)
	if not (entity and entity.valid) then
		return
	end

	Public.register_charging_rod(entity)

	if tags and tags.is_negative ~= nil then
		Public.rod_set_state(entity, tags.is_negative)
	end
end

function Public.register_charging_rod(entity)
	local surface = entity.surface
	local force = entity.force

	if not (surface and surface.valid and force and force.valid) then
		return
	end

	storage.cerys.charging_rods[entity.unit_number] = {
		entity = entity,
		rod_position = { x = entity.position.x, y = entity.position.y + CHARGING_ROD_DISPLACEMENT },
	}
end

Public.rod_set_state = function(entity, negative)
	if entity.name == "charging-rod" then
		if storage.cerys.charging_rod_is_negative[entity.unit_number] ~= negative then
			entity.energy = 0
		end

		storage.cerys.charging_rod_is_negative[entity.unit_number] = negative
	elseif entity.name == "entity-ghost" and entity.ghost_name == "charging-rod" then
		local tags = entity.tags or {}
		tags.is_negative = negative
		entity.tags = tags
	end
end

Public.built_ghost_charging_rod = function(entity, tags)
	if tags and tags.is_negative ~= nil then
		Public.rod_set_state(entity, tags.is_negative)
	end
end

function Public.tick_12_check_charging_rods()
	for unit_number, rod in pairs(storage.cerys.charging_rods) do
		local e = rod.entity

		if not (e and e.valid) then
			if rod.red_light_rendering and rod.red_light_rendering.valid then
				rod.red_light_rendering.destroy()
			end
			storage.cerys.charging_rods[unit_number] = nil
			goto continue
		end

		if storage.cerys.charging_rod_is_negative[unit_number] then
			if rod.red_light_rendering then
				if rod.red_light_rendering.valid then
					rod.red_light_rendering.destroy()
				end
				rod.red_light_rendering = nil
			end
		else
			if not (rod.red_light_rendering and rod.red_light_rendering.valid) then
				rod.red_light_rendering = rendering.draw_sprite({
					surface = e.surface,
					sprite = "cerys-charging-rod-red-light",
					target = e,
					render_layer = "object",
				})
			end
		end

		::continue::
	end
end

script.on_event(defines.events.on_gui_opened, function(event)
	if event.gui_type ~= defines.gui_type.entity then
		return
	end

	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local entity = event.entity

	if
		not (
			entity
			and entity.valid
			and (
				entity.name == "charging-rod"
				or (entity.name == "entity-ghost" and entity.ghost_name == "charging-rod")
			)
		)
	then
		return
	end

	local gui_key = entity.name == "charging-rod" and GUI_KEY or GUI_KEY_GHOST

	local relative = player.gui.relative
	if relative[gui_key] then
		if (relative[gui_key].tags or {}).mod_version ~= script.active_mods["Cerys-Moon-of-Fulgora"] then
			relative[gui_key].destroy()
		end
	end

	if not relative[gui_key] then
		local main_frame = relative.add({
			type = "frame",
			name = gui_key,
			direction = "vertical",
			tags = { mod_version = script.active_mods["Cerys-Moon-of-Fulgora"] },
			anchor = {
				name = entity.name,
				gui = defines.relative_gui_type.accumulator_gui,
				position = defines.relative_gui_position.right,
			},
		})

		local titlebar_flow = main_frame.add({
			type = "flow",
			direction = "horizontal",
			drag_target = main_frame,
		})

		titlebar_flow.add({
			type = "label",
			caption = { "cerys.charging-rod-polarity-setting-title" },
			style = "frame_title",
			ignored_by_interaction = true,
		})

		local drag_handle = titlebar_flow.add({
			type = "empty-widget",
			ignored_by_interaction = true,
			style = "draggable_space_header",
		})
		drag_handle.style.horizontally_stretchable = true
		drag_handle.style.height = 24
		drag_handle.style.right_margin = 4

		local content_frame = main_frame.add({
			type = "frame",
			name = "content",
			style = "inside_shallow_frame_with_padding",
			direction = "vertical",
		})

		content_frame.add({
			type = "switch",
			left_label_caption = { "cerys.charging-rod-negative-polarity-label" },
			right_label_caption = { "cerys.charging-rod-positive-polarity-label" },
			name = "charging-rod-switch",
			allow_none_state = false,
			switch_state = "right",
		})
	end

	local switch = relative[gui_key]["content"]["charging-rod-switch"]
	local is_negative = false

	if entity.name == "charging-rod" then
		is_negative = storage.cerys.charging_rod_is_negative[entity.unit_number] or false
	elseif entity.name == "entity-ghost" then
		is_negative = (entity.tags and entity.tags.is_negative) or false
	end

	switch.switch_state = is_negative and "left" or "right"
end)

script.on_event(defines.events.on_gui_switch_state_changed, function(event)
	if event.element.name ~= "charging-rod-switch" then
		return
	end

	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local entity = player.opened

	if not (entity and entity.valid) then
		return
	end

	local is_negative = event.element.switch_state == "left"
	Public.rod_set_state(entity, is_negative)

	local gui_key = entity.name == "charging-rod" and GUI_KEY or GUI_KEY_GHOST

	for _, other_player in pairs(game.connected_players) do
		if
			other_player.valid
			and other_player.index ~= event.player_index
			and other_player.opened
			and other_player.opened.valid
			and other_player.opened == entity
		then
			local gui = other_player.gui.relative[gui_key]
			if gui then
				local other_switch = gui["content"]["charging-rod-switch"]
				if other_switch.switch_state ~= event.element.switch_state then
					other_switch.switch_state = event.element.switch_state
				end
			end
		end
	end
end)

script.on_event(defines.events.on_entity_settings_pasted, function(event)
	local source = event.source
	local destination = event.destination

	if not (source and source.valid and destination and destination.valid) then
		return
	end

	local negative
	if source.name == "charging-rod" then
		negative = storage.cerys.charging_rod_is_negative[source.unit_number]
	elseif source.name == "entity-ghost" and source.ghost_name == "charging-rod" then
		negative = source.tags.is_negative
	end

	Public.rod_set_state(destination, negative)
end)

script.on_event(defines.events.on_entity_cloned, function(event)
	local source = event.source
	local destination = event.destination

	if not (source and source.valid and destination and destination.valid) then
		return
	end

	if source.name ~= "charging-rod" then
		return
	end

	Public.rod_set_state(destination, storage.cerys.charging_rod_is_negative[source.unit_number])
end)

script.on_event(defines.events.on_player_setup_blueprint, function(event)
	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local blueprint = player.blueprint_to_setup

	if blueprint and blueprint.valid_for_read then
		local mapping = event.mapping.get()
		for blueprint_entity_number, entity in pairs(mapping) do
			if entity.name == "charging-rod" then
				local tags = blueprint.get_blueprint_entity_tags(blueprint_entity_number) or {}
				tags.is_negative = storage.cerys.charging_rod_is_negative[entity.unit_number]
				blueprint.set_blueprint_entity_tags(blueprint_entity_number, tags)
			end
		end
	else
		local cursor_stack = player.cursor_stack

		if cursor_stack and cursor_stack.valid_for_read and cursor_stack.is_blueprint then
			local source_entity = event.mapping.get()[1]
			if source_entity and source_entity.valid and source_entity.name == "charging-rod" then
				local tags = cursor_stack.get_blueprint_entity_tags(1) or {}
				tags.is_negative = storage.cerys.charging_rod_is_negative[source_entity.unit_number]
				cursor_stack.set_blueprint_entity_tags(1, tags)
			end
		end
	end
end)

script.on_event(defines.events.on_pre_build, function(event)
	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local blueprint = player.cursor_stack

	if not (blueprint and blueprint.valid_for_read) then
		return
	end

	if event.ghost_name == "charging-rod" then
		local tags = blueprint.get_blueprint_entity_tags(event.blueprint_entity_number) or {}
		event.tags = event.tags or {}
		event.tags.is_negative = tags.is_negative
	end
end)

return Public
