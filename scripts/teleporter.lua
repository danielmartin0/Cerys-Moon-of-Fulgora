local Public = {}

function Public.toggle_gui(player, entity)
	if not (player and player.valid) then
		return
	end

	if player.gui.screen.cerys_teleporter_gui then
		player.gui.screen.cerys_teleporter_gui.destroy()
		player.opened = nil

		return
	end

	local frame = player.gui.screen.add({
		type = "frame",
		name = "cerys_teleporter_gui",
		direction = "vertical",
		style = "frame",
	})
	frame.auto_center = true

	local button = frame.add({
		type = "button",
		name = "cerys_teleporter_button",
		caption = "Teleport",
		style = "button",
	})
	button.tooltip = "Click to teleport"

	player.opened = frame
end

function Public.tick_15_check_frozen_teleporter(surface)
	local e = storage.cerys.frozen_teleporter

	if not (e and e.valid) then
		return
	end

	if not e.frozen and game.tick > e.creation_tick + 300 then
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
	end

	if not storage.cerys then
		return
	end

	storage.cerys.frozen_teleporter = nil
	storage.cerys.teleporter = e2
end

Public.register_frozen_teleporter = function(entity)
	if not (entity and entity.valid) then
		return
	end

	if not storage.cerys then
		return
	end

	storage.cerys.frozen_teleporter = entity
end

return Public
