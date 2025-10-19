local common = require("common")
local lib = require("lib")
local Public = {}

-- TODO: Remove the charging rod tick-checking code, and instead handle deletion of the lights by register_on_object_destroyed

Public.GUI_KEY = "cerys-gui-charging-rod-2"
-- These GUIs are attached to all accumulator entities on some old saves:
Public.OLD_GUI_KEY = "cerys-gui-charging-rod"
Public.OLD_GUI_KEY_GHOST = "cerys-gui-charging-rod-ghost"

function Public.tags_is_positive(tags)
	if not tags then
		return nil
	end
	return tags.is_positive or tags.is_negative -- is_negative is a deprecated name for is_positive
end

function Public.tags_set_is_positive(tags, is_positive)
	tags.is_positive = is_positive or false
	tags.is_negative = nil -- Clear the legacy field
	return tags
end

Public.built_charging_rod = function(entity, tags)
	if not storage.cerys then
		return
	end

	if not (entity and entity.valid) then
		return
	end

	Public.register_charging_rod(entity)

	if tags then
		local tags_is_positive = Public.tags_is_positive(tags)

		if tags_is_positive ~= nil then
			Public.rod_set_state(entity, tags_is_positive)
		else
			Public.rod_set_state(entity, true)
		end

		if tags.circuit_controlled ~= nil then
			storage.cerys.charging_rods[entity.unit_number].circuit_controlled = tags.circuit_controlled
		end
		if tags.control_signal ~= nil then
			storage.cerys.charging_rods[entity.unit_number].control_signal = tags.control_signal
		end
	else
		Public.rod_set_state(entity, true)
	end

	entity.tags = tags

	if not storage.cerys.given_charging_rod_performance_warning then
		local registered_charging_rod_count = 0
		for _, rod in pairs(storage.cerys.charging_rods) do
			if rod.entity and rod.entity.valid then
				registered_charging_rod_count = registered_charging_rod_count + 1
			end
		end

		if registered_charging_rod_count >= 400 then
			storage.cerys.given_charging_rod_performance_warning = true

			game.print({
				"cerys.charging-rod-performance-warning",
			}, { color = common.WARN_COLOR })
		end
	end
end

function Public.register_charging_rod(entity)
	local surface = entity.surface
	local force = entity.force

	if not (surface and surface.valid and force and force.valid) then
		return
	end

	-- We register storage for both real rods and ghosts. Ghosts need both this _and_ tags, so they can be blueprinted but also tracked by ghost particles.
	storage.cerys.charging_rods[entity.unit_number] = {
		entity = entity,
		rod_position = { x = entity.position.x, y = entity.position.y },
		circuit_controlled = false,
		control_signal = { type = "virtual", name = "signal-P" },
	}
end

local MAX_ROD_ENERGY = prototypes.entity["cerys-charging-rod"].electric_energy_source_prototype.buffer_capacity

function Public.update_rod_lights(entity, rod)
	if not (entity and entity.valid) then
		return
	end

	local positive = storage.cerys.charging_rod_is_positive[entity.unit_number] == true

	if positive then
		if not (rod.blue_glow_entity and rod.blue_glow_entity.valid) then
			rod.blue_glow_entity = entity.surface.create_entity({
				name = "cerys-charging-rod-glow-blue",
				position = { x = entity.position.x, y = entity.position.y + 1 },
			})
		end
		Public.destroy_red_glow_entity(rod)
	else
		if not (rod.red_glow_entity and rod.red_glow_entity.valid) then
			rod.red_glow_entity = entity.surface.create_entity({
				name = "cerys-charging-rod-glow-red",
				position = { x = entity.position.x, y = entity.position.y + 1 },
			})
		end
		Public.destroy_blue_glow_entity(rod)
	end

	-- Update light entities based on energy fraction
	local max_charging_rod_energy = MAX_ROD_ENERGY * (entity.quality.level + 1)

	local energy_fraction
	if common.DEBUG_CHARGING_RODS_FULL then
		energy_fraction = positive and 1 or -1
	else
		energy_fraction = math.min(1, entity.energy / max_charging_rod_energy) * (positive and 1 or -1)
	end

	if energy_fraction > 0.999 then
		if not (rod.blue_light_entity and rod.blue_light_entity.valid) then
			rod.blue_light_entity = entity.surface.create_entity({
				name = "cerys-charging-rod-animation-blue",
				position = { x = entity.position.x, y = entity.position.y + 1 },
			})
		end
		Public.destroy_red_light_entity(rod)
	elseif energy_fraction < -0.999 then
		if not (rod.red_light_entity and rod.red_light_entity.valid) then
			rod.red_light_entity = entity.surface.create_entity({
				name = "cerys-charging-rod-animation-red",
				position = { x = entity.position.x, y = entity.position.y + 1 },
			})
		end
		Public.destroy_blue_light_entity(rod)
	else
		Public.destroy_blue_light_entity(rod)
		Public.destroy_red_light_entity(rod)
	end

	if energy_fraction < 0.001 and energy_fraction > -0.001 then
		Public.destroy_lamp_entity(rod)
	else
		if not (rod.lamp_entity and rod.lamp_entity.valid) then
			rod.lamp_entity = entity.surface.create_entity({
				name = "charging-rod-lamp",
				position = { x = entity.position.x, y = entity.position.y },
			})
		end
	end

	-- Update polarity fraction
	if not rod.max_polarity_fraction then -- TODO: Move this to moment of creation
		rod.max_polarity_fraction = lib.calculate_max_polarity_fraction(entity.quality.level)
	end
	rod.polarity_fraction = rod.max_polarity_fraction * energy_fraction
end

Public.rod_set_state = function(entity, positive)
	storage.cerys.charging_rod_is_positive[entity.unit_number] = positive or false

	if entity.name == "entity-ghost" then
		local tags = entity.tags or {}
		Public.tags_set_is_positive(tags, positive)
		entity.tags = tags
	end

	Public.update_rod_lights(entity, storage.cerys.charging_rods[entity.unit_number])
end

function Public.tick_12_check_charging_rods()
	for unit_number, rod in pairs(storage.cerys.charging_rods) do
		local e = rod.entity

		if not (e and e.valid) then
			Public.destroy_red_light_entity(rod)
			Public.destroy_blue_light_entity(rod)
			Public.destroy_red_glow_entity(rod)
			Public.destroy_blue_glow_entity(rod)
			Public.destroy_lamp_entity(rod)
			storage.cerys.charging_rods[unit_number] = nil
		else
			local positive = storage.cerys.charging_rod_is_positive[unit_number] == true

			for _, player in pairs(game.connected_players) do
				if player.opened == e then
					local gui = player.gui.relative[Public.GUI_KEY]
					if gui then
						local switch = gui.content["charging-rod-switch"]
						if not switch.enabled then -- Only sync disabled switches (circuit controlled)
							local current_state = switch.switch_state == "left"
							if current_state ~= positive then
								switch.switch_state = positive and "left" or "right"
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

					if signal_value > 0 and positive then
						Public.rod_set_state(e, false)
					elseif signal_value <= 0 and not positive then
						Public.rod_set_state(e, true)
					end
				end
			end

			Public.update_rod_lights(e, rod)

			local max_charging_rod_energy = MAX_ROD_ENERGY * (e.quality.level + 1)

			local energy_fraction
			if common.DEBUG_CHARGING_RODS_FULL then
				energy_fraction = positive and 1 or -1
			else
				energy_fraction = math.min(1, e.energy / max_charging_rod_energy) * (positive and 1 or -1)
			end

			-- Update polarity fraction
			if not rod.max_polarity_fraction then -- TODO: Move this to moment of creation
				rod.max_polarity_fraction = lib.calculate_max_polarity_fraction(e.quality.level)
			end
			rod.polarity_fraction = rod.max_polarity_fraction * energy_fraction
		end
	end
end

function Public.destroy_lamp_entity(rod)
	if rod.lamp_entity then
		if rod.lamp_entity.valid then
			rod.lamp_entity.destroy()
		end
		rod.lamp_entity = nil
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

function Public.destroy_red_glow_entity(rod)
	if rod.red_glow_entity then
		if rod.red_glow_entity.valid then
			rod.red_glow_entity.destroy()
		end
		rod.red_glow_entity = nil
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

function Public.destroy_blue_glow_entity(rod)
	if rod.blue_glow_entity then
		if rod.blue_glow_entity.valid then
			rod.blue_glow_entity.destroy()
		end
		rod.blue_glow_entity = nil
	end
end

function Public.destroy_guis(player_index)
	local player = game.players[player_index]

	if not (player and player.valid) then
		return
	end

	local relative = player.gui.relative

	if relative[Public.GUI_KEY] then
		relative[Public.GUI_KEY].destroy()
	end
	if relative[Public.OLD_GUI_KEY] then
		relative[Public.OLD_GUI_KEY].destroy()
	end
	if relative[Public.OLD_GUI_KEY_GHOST] then
		relative[Public.OLD_GUI_KEY_GHOST].destroy()
	end
end

function Public.on_gui_opened(event)
	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local entity = event.entity
	local relative = player.gui.relative

	if relative[Public.OLD_GUI_KEY] then
		relative[Public.OLD_GUI_KEY].destroy()
	end
	if relative[Public.OLD_GUI_KEY_GHOST] then
		relative[Public.OLD_GUI_KEY_GHOST].destroy()
	end

	local gui_key = Public.GUI_KEY

	-- We always destroy the GUI when leaving it now, so this is no longer needed:
	-- if relative[gui_key] then
	-- 	if (relative[gui_key].tags or {}).mod_version ~= script.active_mods["Cerys-Moon-of-Fulgora"] then
	-- 		relative[gui_key].destroy()
	-- 	end
	-- end

	if player.surface and player.surface.valid and player.surface.name ~= "cerys" then
		return
	end

	local tags = entity.tags or {}

	local rod_circuit_data = storage.cerys.charging_rods[entity.unit_number]

	local tags_is_positive = Public.tags_is_positive(tags)
	local storage_is_positive = storage.cerys.charging_rod_is_positive[entity.unit_number]

	if tags_is_positive ~= nil and (storage_is_positive or tags_is_positive ~= storage_is_positive) then
		-- Something has gone wrong, let's treat storage as authoritative since it affects the solar wind:
		Public.rod_set_state(entity, storage_is_positive)
		log("[CERYS]: Fixed bugged polarity for " .. entity.name .. " to " .. tostring(storage_is_positive))

		-- Should we do this for circuit data as well?
	end

	local is_positive = storage_is_positive ~= nil and storage_is_positive or tags_is_positive

	if not relative[gui_key] then
		local main_frame = relative.add({
			type = "frame",
			name = gui_key,
			direction = "vertical",
			tags = { mod_version = script.active_mods["Cerys-Moon-of-Fulgora"] },
			anchor = {
				gui = defines.relative_gui_type.accumulator_gui,
				position = defines.relative_gui_position.right,
				ghost_mode = "both",
				name = "cerys-charging-rod",
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

		content_frame.add({
			type = "switch",
			left_label_caption = { "cerys.charging-rod-negative-polarity-label" },
			right_label_caption = { "cerys.charging-rod-positive-polarity-label" },
			name = "charging-rod-switch",
			allow_none_state = false,
			switch_state = is_positive and "left" or "right",
			enabled = not (rod_circuit_data and rod_circuit_data.circuit_controlled),
		})

		content_frame.add({
			type = "line",
			direction = "horizontal",
		})

		content_frame.add({
			type = "checkbox",
			name = "circuit-control-checkbox",
			caption = { "cerys.charging-rod-polarity-circuit-control-label" },
			state = rod_circuit_data.circuit_controlled and true or false,
			tooltip = { "cerys.charging-rod-polarity-circuit-control-tooltip" },
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
		signal_label.style.font_color = rod_circuit_data.circuit_controlled and { 1, 1, 1 } or { 0.5, 0.5, 0.5 }

		flow.add({
			type = "choose-elem-button",
			name = "control-signal-button",
			elem_type = "signal",
			signal = rod_circuit_data.control_signal,
			enabled = rod_circuit_data.circuit_controlled and true or false,
		})
	end
end

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

	local is_positive = event.element.switch_state == "left"
	Public.rod_set_state(entity, is_positive)

	local gui_key = entity.name == "cerys-charging-rod" and Public.GUI_KEY or Public.GUI_KEY_GHOST

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

	if
		not (
			source.name == "cerys-charging-rod"
			or (source.name == "entity-ghost" and source.ghost_name == "cerys-charging-rod")
		)
	then
		return
	end
	if
		not (
			destination.name == "cerys-charging-rod"
			or (destination.name == "entity-ghost" and destination.ghost_name == "cerys-charging-rod")
		)
	then
		return
	end

	if not storage.cerys then
		return
	end

	local positive
	if source.name == "cerys-charging-rod" then
		positive = storage.cerys.charging_rod_is_positive[source.unit_number]
	else
		positive = Public.tags_is_positive(source.tags)
	end

	Public.rod_set_state(destination, positive)

	local source_circuit_data = source.name == "cerys-charging-rod" and storage.cerys.charging_rods[source.unit_number]
		or (source.tags or {})

	storage.cerys.charging_rods[destination.unit_number].circuit_controlled = source_circuit_data.circuit_controlled
	storage.cerys.charging_rods[destination.unit_number].control_signal = source_circuit_data.control_signal

	if destination.name == "entity-ghost" then
		local tags = destination.tags or {}
		tags.circuit_controlled = source_circuit_data.circuit_controlled
		tags.control_signal = source_circuit_data.control_signal
		destination.tags = tags
	end
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

	Public.rod_set_state(destination, storage.cerys.charging_rod_is_positive[source.unit_number])
end)

script.on_event(defines.events.on_gui_checked_state_changed, function(event)
	if event.element.name == "circuit-control-checkbox" then
		local player = game.players[event.player_index]
		if not (player and player.valid) then
			return
		end

		local entity = player.opened
		if not (entity and entity.valid) then
			return
		end

		storage.cerys.charging_rods[entity.unit_number].circuit_controlled = event.element.state
		if entity.name == "entity-ghost" then
			local tags = entity.tags or {}
			tags.circuit_controlled = event.element.state
			storage.cerys.charging_rods[entity.unit_number] = storage.cerys.charging_rods[entity.unit_number] or {}
			storage.cerys.charging_rods[entity.unit_number].circuit_controlled = event.element.state
			entity.tags = tags
		end

		local content_frame = event.element.parent
		if content_frame and content_frame["charging-rod-switch"] then
			content_frame["charging-rod-switch"].enabled = not event.element.state
		end
		if content_frame and content_frame["signal_flow"] and content_frame["signal_flow"]["control-signal-button"] then
			content_frame["signal_flow"]["control-signal-button"].enabled = event.element.state
		end

		if
			content_frame
			and content_frame["signal_flow"]
			and content_frame["signal_flow"].children
			and content_frame["signal_flow"].children[1]
		then
			local label = content_frame["signal_flow"].children[1]
			label.style.font_color = event.element.state and { 1, 1, 1 } or { 0.5, 0.5, 0.5 }
		end
	end
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

	storage.cerys.charging_rods[entity.unit_number].control_signal = event.element.elem_value
	if entity.name == "entity-ghost" then
		local tags = entity.tags or {}
		tags.control_signal = event.element.elem_value
		storage.cerys.charging_rods[entity.unit_number] = storage.cerys.charging_rods[entity.unit_number] or {}
		storage.cerys.charging_rods[entity.unit_number].control_signal = event.element.elem_value
		entity.tags = tags
	end
end)

script.on_event("cerys-toggle-entity", function(event)
	if not storage.cerys then
		return
	end

	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local e = player.selected

	if
		not (
			e
			and e.valid
			and (e.name == "cerys-charging-rod" or (e.name == "entity-ghost" and e.ghost_name == "cerys-charging-rod"))
		)
	then
		return
	end

	local is_ghost = e.name == "entity-ghost"

	local current_state
	if is_ghost then
		current_state = Public.tags_is_positive(e.tags) or false
	else
		current_state = storage.cerys.charging_rod_is_positive[e.unit_number]
	end

	local new_state = not current_state
	Public.rod_set_state(e, new_state)

	local gui_key = is_ghost and Public.GUI_KEY_GHOST or Public.GUI_KEY
	for _, player in pairs(game.connected_players) do
		if player.opened == e then
			local gui = player.gui.relative[gui_key]
			if gui and gui.valid and gui.content and gui.content.valid then
				local switch = gui.content["charging-rod-switch"]
				if switch and switch.valid then
					switch.switch_state = new_state and "left" or "right"
				end
			end
		end
	end
end)

return Public
