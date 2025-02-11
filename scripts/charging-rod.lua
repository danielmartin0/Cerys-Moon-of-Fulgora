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
		circuit_controlled = false,
		control_signal = { type = "virtual", name = "signal-P" },
	}
end

Public.rod_set_state = function(entity, negative)
	if entity.name == "cerys-charging-rod" then
		-- if storage.cerys.charging_rod_is_negative[entity.unit_number] ~= negative then
		-- 	entity.energy = 0
		-- end

		storage.cerys.charging_rod_is_negative[entity.unit_number] = negative
	elseif entity.name == "entity-ghost" and entity.ghost_name == "cerys-charging-rod" then
		local tags = entity.tags or {}
		tags.is_negative = negative
		tags.circuit_controlled = storage.cerys.charging_rods[entity.unit_number]
			and storage.cerys.charging_rods[entity.unit_number].circuit_controlled
		tags.control_signal = storage.cerys.charging_rods[entity.unit_number]
			and storage.cerys.charging_rods[entity.unit_number].control_signal
		entity.tags = tags
	end
end

Public.built_ghost_charging_rod = function(entity, tags)
	if tags and tags.is_negative ~= nil then
		Public.rod_set_state(entity, tags.is_negative)
	end
end

local max_charging_rod_energy = prototypes.entity["cerys-charging-rod"].electric_energy_source_prototype.buffer_capacity

function Public.tick_12_check_charging_rods()
	for unit_number, rod in pairs(storage.cerys.charging_rods) do
		local e = rod.entity

		if not (e and e.valid) then
			Public.destroy_red_light_entity(rod)
			Public.destroy_blue_light_entity(rod)
			storage.cerys.charging_rods[unit_number] = nil
			goto continue
		end

		local negative = storage.cerys.charging_rod_is_negative[unit_number]

		for _, player in pairs(game.connected_players) do
			if player.opened == e then
				local gui = player.gui.relative[GUI_KEY]
				if gui then
					local switch = gui.content["charging-rod-switch"]
					if not switch.enabled then -- Only sync disabled switches (circuit controlled)
						local current_state = switch.switch_state == "left"
						if current_state ~= negative then
							switch.switch_state = negative and "left" or "right"
						end
					end
				end
			end
		end

		if rod.circuit_controlled and rod.control_signal then
			local red_network = e.get_circuit_network(defines.wire_connector_id.circuit_red)
			local green_network = e.get_circuit_network(defines.wire_connector_id.circuit_green)

			if red_network or green_network then
				local signal_value = (red_network and red_network.get_signal(rod.control_signal) or 0)
					+ (green_network and green_network.get_signal(rod.control_signal) or 0)

				if signal_value > 0 and negative then
					Public.rod_set_state(e, false)
				elseif signal_value <= 0 and not negative then
					Public.rod_set_state(e, true)
				end
			end
		end

		local polarity_fraction = (e.energy / max_charging_rod_energy) * (negative and 1 or -1)
		rod.polarity_fraction = polarity_fraction

		if polarity_fraction > 0.999 then
			if not (rod.blue_light_entity and rod.blue_light_entity.valid) then
				rod.blue_light_entity = e.surface.create_entity({
					name = "cerys-charging-rod-animation-blue",
					position = { x = e.position.x, y = e.position.y + 1 },
				})
			end
			Public.destroy_red_light_entity(rod)
		elseif polarity_fraction < -0.999 then
			if not (rod.red_light_entity and rod.red_light_entity.valid) then
				rod.red_light_entity = e.surface.create_entity({
					name = "cerys-charging-rod-animation-red",
					position = { x = e.position.x, y = e.position.y + 1 },
				})
			end
			Public.destroy_blue_light_entity(rod)
		else
			Public.destroy_blue_light_entity(rod)
			Public.destroy_red_light_entity(rod)
		end

		::continue::
	end
end

function Public.destroy_red_light_entity(rod)
	if rod.red_light_entity then
		if rod.red_light_entity.valid then
			rod.red_light_entity.destroy()
		end
		rod.red_light_entity = nil
	end
end

function Public.destroy_blue_light_entity(rod)
	if rod.blue_light_entity then
		if rod.blue_light_entity.valid then
			rod.blue_light_entity.destroy()
		end
		rod.blue_light_entity = nil
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
				entity.name == "cerys-charging-rod"
				or (entity.name == "entity-ghost" and entity.ghost_name == "cerys-charging-rod")
			)
		)
	then
		return
	end

	local gui_key = entity.name == "cerys-charging-rod" and GUI_KEY or GUI_KEY_GHOST

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
			style = "inside_shallow_frame_with_padding_and_vertical_spacing",
			direction = "vertical",
		})

		local rod = storage.cerys.charging_rods[entity.unit_number]

		content_frame.add({
			type = "switch",
			left_label_caption = { "cerys.charging-rod-negative-polarity-label" },
			right_label_caption = { "cerys.charging-rod-positive-polarity-label" },
			name = "charging-rod-switch",
			allow_none_state = false,
			switch_state = "right",
			enabled = entity.name == "cerys-charging-rod" and not rod.circuit_controlled, -- ghosts not supported
		})

		if entity.name == "cerys-charging-rod" then -- We don't support circuit control for ghosts yet
			content_frame.add({
				type = "line",
				direction = "horizontal",
			})

			content_frame.add({
				type = "checkbox",
				name = "circuit-control-checkbox",
				caption = "Set polarity from circuit",
				state = rod.circuit_controlled,
				tooltip = "The polarity of the charging rod will be negative if the selected circuit network signal is zero.",
			})

			local flow = content_frame.add({
				type = "flow",
				direction = "horizontal",
				name = "signal_flow",
				style = "player_input_horizontal_flow",
			})
			flow.style.horizontally_stretchable = true

			local signal_label = flow.add({
				type = "label",
				caption = "Control signal:",
				style = "label",
			})
			signal_label.style.minimal_width = 110 -- Why is this needed?
			signal_label.style.horizontally_stretchable = true
			signal_label.style.font_color = rod.circuit_controlled and { 1, 1, 1 } or { 0.5, 0.5, 0.5 }

			flow.add({
				type = "choose-elem-button",
				name = "control-signal-button",
				elem_type = "signal",
				signal = rod.control_signal,
				enabled = rod.circuit_controlled,
			})
		end
	end

	local switch = relative[gui_key]["content"]["charging-rod-switch"]
	local is_negative = false

	if entity.name == "cerys-charging-rod" then
		is_negative = storage.cerys.charging_rod_is_negative[entity.unit_number] or false
	elseif entity.name == "entity-ghost" then
		is_negative = (entity.tags and entity.tags.is_negative) or false
	end

	switch.switch_state = is_negative and "left" or "right"

	if entity.name == "cerys-charging-rod" then
		local rod = storage.cerys.charging_rods[entity.unit_number]
		local content = relative[gui_key]["content"]
		local checkbox = content["circuit-control-checkbox"]
		local signal_flow = content["signal_flow"]

		checkbox.state = rod.circuit_controlled
		content["charging-rod-switch"].enabled = not rod.circuit_controlled
		signal_flow["control-signal-button"].enabled = rod.circuit_controlled
		signal_flow["control-signal-button"].elem_value = rod.control_signal
		signal_flow.children[1].style.font_color = rod.circuit_controlled and { 1, 1, 1 } or { 0.5, 0.5, 0.5 }
	end
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

	local gui_key = entity.name == "cerys-charging-rod" and GUI_KEY or GUI_KEY_GHOST

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

	if not storage.cerys then
		return
	end

	local negative
	local source_rod = storage.cerys.charging_rods[source.unit_number]
	if source.name == "cerys-charging-rod" then
		negative = storage.cerys.charging_rod_is_negative[source.unit_number]
		if source_rod and destination.name == "cerys-charging-rod" then
			local dest_rod = storage.cerys.charging_rods[destination.unit_number]
			if dest_rod then
				dest_rod.circuit_controlled = source_rod.circuit_controlled
				dest_rod.control_signal = source_rod.control_signal
			end
		end
	elseif source.name == "entity-ghost" and source.ghost_name == "cerys-charging-rod" then
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

	if source.name ~= "cerys-charging-rod" then
		return
	end

	if not storage.cerys then
		return
	end

	local source_rod = storage.cerys.charging_rods[source.unit_number]
	if source_rod and destination.name == "cerys-charging-rod" then
		local dest_rod = storage.cerys.charging_rods[destination.unit_number]
		if dest_rod then
			dest_rod.circuit_controlled = source_rod.circuit_controlled
			dest_rod.control_signal = source_rod.control_signal
		end
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
			if entity.name == "cerys-charging-rod" and storage.cerys then
				local tags = blueprint.get_blueprint_entity_tags(blueprint_entity_number) or {}
				tags.is_negative = storage.cerys.charging_rod_is_negative[entity.unit_number]
				blueprint.set_blueprint_entity_tags(blueprint_entity_number, tags)
			end
		end
	else
		local cursor_stack = player.cursor_stack

		if cursor_stack and cursor_stack.valid_for_read and cursor_stack.is_blueprint then
			local source_entity = event.mapping.get()[1]
			if
				source_entity
				and source_entity.valid
				and source_entity.name == "cerys-charging-rod"
				and storage.cerys
			then
				local tags = cursor_stack.get_blueprint_entity_tags(1) or {}
				tags.is_negative = storage.cerys.charging_rod_is_negative[source_entity.unit_number]
				cursor_stack.set_blueprint_entity_tags(1, tags)
			end
		end
	end
end)

function Public.on_pre_build(event)
	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local blueprint = player.cursor_stack

	if not (blueprint and blueprint.valid_for_read) then
		return
	end

	if event.ghost_name == "cerys-charging-rod" then
		local tags = blueprint.get_blueprint_entity_tags(event.blueprint_entity_number) or {}
		event.tags = event.tags or {}
		event.tags.is_negative = tags.is_negative
	end
end

script.on_event(defines.events.on_gui_checked_state_changed, function(event)
	if event.element.name ~= "circuit-control-checkbox" then
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

	local rod = storage.cerys.charging_rods[entity.unit_number]
	if not rod then
		return
	end

	rod.circuit_controlled = event.element.state

	local content_frame = event.element.parent
	content_frame["charging-rod-switch"].enabled = not event.element.state
	content_frame["signal_flow"]["control-signal-button"].enabled = event.element.state

	local label = content_frame["signal_flow"].children[1]
	label.style.font_color = event.element.state and { 1, 1, 1 } or { 0.5, 0.5, 0.5 }
end)

script.on_event(defines.events.on_gui_elem_changed, function(event)
	if event.element.name ~= "control-signal-button" then
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

	if not storage.cerys then
		return
	end

	local rod = storage.cerys.charging_rods[entity.unit_number]
	if not rod then
		return
	end

	rod.control_signal = event.element.elem_value
end)

return Public
