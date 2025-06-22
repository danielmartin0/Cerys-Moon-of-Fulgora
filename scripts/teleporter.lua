local common = require("common")

local Public = {}

function Public.teleport_to_fulgora(player)
	if not (player and player.valid) then
		return
	end

	local character = player.character
	if not (character and character.valid) then
		return
	end

	local original_surface = player.surface
	local fulgora_surface = game.planets.fulgora.surface

	local p
	p = { math.random(-50, 50), math.random(-50, 50) }

	if fulgora_surface then
		p = fulgora_surface.find_non_colliding_position("character", p, 50, 1)
	else
		fulgora_surface = game.planets.fulgora.create_surface()
	end

	character.teleport(p, fulgora_surface)
	Public.close_gui(player)

	player.play_sound({
		path = "cerys-teleporter-1",
		volume_modifier = 0.6,
	})
	player.play_sound({
		path = "cerys-teleporter-2",
		volume_modifier = 0.6,
	})

	original_surface.play_sound({
		path = "cerys-teleporter-1",
		volume_modifier = 0.6,
	})
	original_surface.play_sound({
		path = "cerys-teleporter-2",
		volume_modifier = 0.6,
	})
end

function Public.close_gui(player)
	if not (player and player.valid) then
		return
	end

	player.gui.screen.cerys_teleporter_gui.destroy()
	player.opened = nil
	if storage.teleporter_gui then
		storage.teleporter_gui[player.index] = nil
	end
end

function Public.toggle_gui(player, entity)
	if player.gui.screen.cerys_teleporter_gui then
		Public.close_gui(player)
		return
	end

	if entity.frozen then
		player.opened = nil
		return
	end

	if player.controller_type ~= defines.controllers.character then
		player.opened = nil
		return
	end

	if not storage.teleporter_gui then
		storage.teleporter_gui = {}
	end
	if not storage.teleporter_gui[player.index] then
		storage.teleporter_gui[player.index] = {
			confirmed = false,
			revert_tick = nil,
		}
	end

	local frame = player.gui.screen.add({
		type = "frame",
		name = "cerys_teleporter_gui",
		direction = "vertical",
		style = "frame",
	})
	frame.auto_center = true

	local titlebar = frame.add({
		type = "flow",
		name = "titlebar",
		direction = "horizontal",
		style = "horizontal_flow",
	})
	titlebar.style.horizontal_spacing = 8
	titlebar.drag_target = frame

	titlebar.add({
		type = "label",
		name = "title",
		caption = { "cerys.teleporter-title" },
		style = "frame_title",
		ignored_by_interaction = true,
	})

	local drag_handle = titlebar.add({
		type = "empty-widget",
		name = "drag_handle",
		style = "draggable_space_header",
	})
	drag_handle.style.horizontally_stretchable = true
	drag_handle.style.height = 24
	drag_handle.style.right_margin = 4
	drag_handle.style.left_margin = 4
	drag_handle.drag_target = frame

	titlebar.add({
		type = "sprite-button",
		name = "cerys_teleporter_close",
		style = "frame_action_button",
		sprite = "utility/close",
		hovered_sprite = "utility/close_black",
		clicked_sprite = "utility/close_black",
	})

	local content_frame = frame.add({
		type = "frame",
		name = "content_frame",
		direction = "vertical",
		style = "inside_shallow_frame_with_padding",
	})

	local vertical_flow = content_frame.add({
		type = "flow",
		name = "vertical_flow",
		direction = "vertical",
		style = "vertical_flow",
		vertical_spacing = 8,
	})

	local preview_frame = vertical_flow.add({
		type = "frame",
		style = "deep_frame_in_shallow_frame",
	})

	local preview = preview_frame.add({
		type = "entity-preview",
		name = "teleporter_preview",
		style = "wide_entity_button",
	})
	preview.entity = entity
	preview.style.width = 280
	preview.style.height = 280

	local button_flow = vertical_flow.add({
		type = "flow",
		name = "button_flow",
		direction = "horizontal",
		style = "horizontal_flow",
	})
	button_flow.style.horizontal_align = "center"
	button_flow.style.top_margin = 8
	button_flow.style.horizontally_stretchable = true

	local button = button_flow.add({
		type = "button",
		name = "cerys_teleporter_button",
		caption = { "cerys.teleporter-button-text" },
		style = "green_button",
		enabled = game.planets.fulgora and not game.planets.fulgora.prototype.hidden,
		tooltip = { "cerys.teleporter-button-tooltip" },
	})
	button.style.minimal_width = 160

	player.opened = frame
end

function Public.reset_button_state(player_index)
	local player = game.players[player_index]
	if not (player and player.valid) then
		return
	end

	local gui = player.gui.screen.cerys_teleporter_gui
	if not gui then
		return
	end

	local button = gui.content_frame.vertical_flow.button_flow.cerys_teleporter_button
	if button then
		button.caption = { "cerys.teleporter-button-text" }
	end

	storage.teleporter_gui[player_index].confirmed = false
	storage.teleporter_gui[player_index].revert_tick = nil
end

script.on_event(defines.events.on_gui_click, function(event)
	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	if event.element and event.element.name == "cerys_teleporter_button" then
		local state = storage.teleporter_gui[player.index]
		if not state then
			return
		end

		if not state.confirmed then
			event.element.caption = { "cerys.teleporter-button-text-confirm" }
			state.confirmed = true
			state.revert_tick = game.tick + 60 * 2
		else
			Public.teleport_to_fulgora(player)
			Public.reset_button_state(player.index)
		end
	elseif event.element and event.element.name == "cerys_teleporter_close" then
		Public.toggle_gui(player)
	end
end)

script.on_event(defines.events.on_gui_closed, function(event)
	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	if event.gui_type == defines.gui_type.custom and event.element and event.element.name == "cerys_teleporter_gui" then
		Public.toggle_gui(player)
	end
end)

Public.tick_15_check_teleporter = function()
	if storage.cerys and storage.cerys.teleporter then
		local e = storage.cerys.teleporter.entity
		if e and e.valid then
			if e.frozen then
				e.custom_status = {
					diode = defines.entity_status_diode.red,
					label = { "entity-status.frozen" },
				}
			else
				e.custom_status = {
					diode = defines.entity_status_diode.green,
					label = { "cerys.teleporter-status-label" },
				}
			end
		end
	end

	if not storage.teleporter_gui then
		return
	end

	for player_index, state in pairs(storage.teleporter_gui) do
		if state.revert_tick and game.tick >= state.revert_tick then
			Public.reset_button_state(player_index)
		end
	end
end

function Public.tick_15_check_frozen_teleporter(surface)
	if not storage.cerys.frozen_teleporter then
		return
	end

	local e = storage.cerys.frozen_teleporter.entity

	if not (e and e.valid) then
		return
	end

	local creation_tick = storage.cerys.frozen_teleporter.creation_tick

	if not e.frozen and game.tick > creation_tick then
		Public.unfreeze_teleporter(surface, e)
	end
end

function Public.unfreeze_teleporter(surface, e)
	local e2 = surface.create_entity({
		name = "cerys-fulgoran-teleporter",
		position = e.position,
		force = e.force,
		fast_replace = true,
	})

	if e2 and e2.valid then
		e2.minable_flag = false
		e2.destructible = false
		e2.custom_status = {
			diode = defines.entity_status_diode.green,
			label = { "cerys.teleporter-status-label" },
		}
	end

	e.destroy()

	if not storage.cerys then
		return
	end

	storage.cerys.frozen_teleporter = nil
	storage.cerys.teleporter = {
		entity = e2,
		creation_tick = game.tick,
	}
end

Public.register_frozen_teleporter = function(entity)
	if not (entity and entity.valid) then
		return
	end

	if not storage.cerys then
		return
	end

	storage.cerys.frozen_teleporter = {
		entity = entity,
		creation_tick = game.tick,
	}
end

return Public
