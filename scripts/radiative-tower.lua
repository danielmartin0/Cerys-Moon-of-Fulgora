local Public = {}

local common = require("common")

local TEMPERATURE_ZERO = 15
local TEMPERATURE_INTERVAL = 6
local TEMPERATURE_MAX_STEPS = 16 -- TODO: No more radius when above this, and no more heating either
local TEMPERATURE_LOSS_RATE = 1 / 350
-- Stefan–Boltzmann has no hold on us here:
local TEMPERATURE_LOSS_POWER = 1.6

Public.register_heating_tower_contracted = function(entity)
	if not (entity and entity.valid) then
		return
	end

	local starting_tower_position = {
		x = entity.position.x,
		y = entity.position.y + common.RADIATIVE_TOWER_SHIFT_PIXELS / 32,
	}

	local shadow = rendering.draw_sprite({
		sprite = "radiative-tower-tower-shadow-1",
		target = {
			x = entity.position.x + 1 - common.RADIATIVE_TOWER_SHIFT_PIXELS / 32,
			y = entity.position.y,
		},
		surface = entity.surface,
	})

	storage.cerys.heating_towers_contracted[entity.unit_number] = {
		entity = entity,
		starting_tower_position = starting_tower_position,
		stage = 0,
		shadow = shadow,
	}
end

Public.register_heating_tower = function(entity, contracted_tower_parent_data)
	if not (entity and entity.valid) then
		return
	end

	local surface = entity.surface

	if not (surface and surface.valid) then
		return
	end

	if contracted_tower_parent_data.top_entity then
		contracted_tower_parent_data.top_entity.destroy()
	end

	local base = surface.create_entity({
		name = "cerys-fulgoran-radiative-tower-base-frozen",
		position = entity.position,
		force = entity.force,
	})

	if base and base.valid then
		base.minable_flag = false
		base.destructible = false
	end

	-- TODO: Create lamps for each heating radius that don't require power

	storage.cerys.heating_towers[entity.unit_number] = {
		entity = entity,
		reactors = {},
		base_entity = base,
		frozen = true,
	}
end

Public.TOWER_CHECK_INTERVAL = 32
function Public.tick_towers(surface)
	for unit_number, tower in pairs(storage.cerys.heating_towers) do
		local e = tower.entity

		if not (e and e.valid) then
			if tower.reactors then
				for _, reactor in pairs(tower.reactors) do
					if reactor and reactor.valid then
						reactor.destroy()
					end
				end
			end

			storage.cerys.heating_towers[unit_number] = nil
		else
			local temperature_above_zero = e.temperature - TEMPERATURE_ZERO

			local heating_radius =
				math.min(TEMPERATURE_MAX_STEPS, math.floor(temperature_above_zero / TEMPERATURE_INTERVAL))

			if not tower.last_radius then
				tower.last_radius = 0
			end

			local skip = (heating_radius == tower.last_radius - 1) -- Don't update the reactor in this case, avoiding reactor count oscillation

			if heating_radius ~= tower.last_radius and not skip then
				if not tower.reactors then
					tower.reactors = {}
				end

				if heating_radius > tower.last_radius then -- If radius increased, add new reactors
					for r = tower.last_radius + 1, heating_radius do
						local new_reactor = surface.create_entity({
							name = "hidden-reactor-" .. r,
							position = e.position,
							force = e.force,
						})
						new_reactor.temperature = 40
						tower.reactors[r] = new_reactor
					end
				elseif heating_radius < tower.last_radius then -- If radius decreased, remove excess reactors
					for r = tower.last_radius, heating_radius + 1, -1 do
						if tower.reactors[r] and tower.reactors[r].valid then
							tower.reactors[r].destroy()
							tower.reactors[r] = nil
						end
					end
				end
			end

			if not skip then
				tower.last_radius = heating_radius
			end

			local temperature_to_apply_loss_for =
				math.min(temperature_above_zero, TEMPERATURE_MAX_STEPS * TEMPERATURE_INTERVAL)

			e.temperature = e.temperature
				- (temperature_to_apply_loss_for ^ TEMPERATURE_LOSS_POWER)
					* TEMPERATURE_LOSS_RATE
					* (Public.TOWER_CHECK_INTERVAL / 60)

			if tower.frozen then
				if temperature_above_zero > 1 then
					Public.unfreeze_tower(surface, tower)
				end
			end
		end
	end
end

function Public.unfreeze_tower(surface, tower)
	local e = tower.entity

	if not (e and e.valid) then
		return
	end

	if tower.base_entity and tower.base_entity.valid then
		tower.base_entity.destroy()
		local base = surface.create_entity({
			name = "cerys-fulgoran-radiative-tower-base",
			position = e.position,
			force = e.force,
		})

		if base and base.valid then
			base.minable_flag = false
			base.destructible = false
			tower.base_entity = base
		end
	end

	local new_tower = surface.create_entity({
		name = "cerys-fulgoran-radiative-tower",
		position = e.position,
		force = e.force,
		fast_replace = true,
	})

	if new_tower and new_tower.valid then
		new_tower.minable_flag = false
		new_tower.destructible = false
		tower.entity = new_tower

		for _, player in pairs(game.connected_players) do
			if player and player.valid and player.opened == e then
				player.opened = new_tower
			end
		end
	end

	if e and e.valid then
		local inv = e.get_inventory(defines.inventory.fuel)
		if inv and inv.valid then
			for i = 1, #inv do
				local stack = inv[i]
				if stack and stack.valid_for_read then
					new_tower.insert(stack)
				end
			end
		end
		new_tower.temperature = e.temperature

		e.destroy()
	end

	tower.frozen = false
end

function Public.tick_20_contracted_towers(surface)
	for unit_number, contracted_tower in pairs(storage.cerys.heating_towers_contracted) do
		if contracted_tower.open_tick then
			return
		end

		local e = contracted_tower.entity
		if not (e and e.valid) then
			storage.cerys.heating_towers_contracted[unit_number] = nil
		else
			local inv = e.get_inventory(defines.inventory.chest)
			if inv and inv.get_item_count("iron-stick") == 0 then
				for _, player in pairs(game.connected_players) do
					if player.opened == e then
						player.opened = nil
					end
				end

				surface.play_sound({
					path = "cerys-fulgoran-tower-opening",
					volume_modifier = 0.7,
					position = contracted_tower.position,
				})

				contracted_tower.open_tick = game.tick

				contracted_tower.rendering = rendering.draw_sprite({
					sprite = "radiative-tower-base-ice",
					target = e.position,
					surface = e.surface,
					render_layer = "above-inserters",
				})

				local e2 = surface.create_entity({
					name = "cerys-fulgoran-radiative-tower-rising-reactor-base",
					position = e.position,
					force = e.force,
				})

				if e2 and e2.valid then
					e2.minable_flag = false
					e2.destructible = false
				end

				local top_entity = surface.create_entity({
					name = "cerys-fulgoran-radiative-tower-rising-reactor-tower-1",
					position = {
						x = e.position.x,
						y = e.position.y + common.RADIATIVE_TOWER_SHIFT_PIXELS / 32,
					},
					force = e.force,
				})
				contracted_tower.top_entity = top_entity

				if inv then
					for i = 1, #inv do
						local stack = inv[i]
						if stack.valid_for_read then
							if stack.name == "solid-fuel" then
								e2.insert(stack)
							else
								e.surface.spill_item_stack({
									position = e.position,
									stack = stack,
								})
							end
						end
					end
				end

				e.destroy()
				contracted_tower.entity = e2
			end
		end
	end
end

local EXPAND_SPEED = 0.03

function Public.tick_1_move_radiative_towers(surface)
	local expand_distance = common.RADIATIVE_TOWER_SHIFT_PIXELS

	for unit_number, contracted_tower in pairs(storage.cerys.heating_towers_contracted) do
		local top_entity = contracted_tower.top_entity

		local open_tick = contracted_tower.open_tick
		if open_tick then
			local ticks_since_open = game.tick - open_tick
			if ticks_since_open < (expand_distance / 32) / EXPAND_SPEED then
				if top_entity and top_entity.valid then
					top_entity.teleport({
						x = contracted_tower.starting_tower_position.x,
						y = contracted_tower.starting_tower_position.y - ticks_since_open * EXPAND_SPEED,
					})
				end

				if contracted_tower.shadow and contracted_tower.shadow.valid then
					contracted_tower.shadow.target = {
						x = contracted_tower.entity.position.x
							+ 1
							- (expand_distance / 32)
							+ ticks_since_open * EXPAND_SPEED,
						y = contracted_tower.entity.position.y,
					}
				end

				if contracted_tower.stage == 0 and ticks_since_open > 1 / EXPAND_SPEED then
					contracted_tower.stage = 1

					local new_top_entity = surface.create_entity({
						name = "cerys-fulgoran-radiative-tower-rising-reactor-tower-2",
						position = top_entity.position,
						force = top_entity.force,
					})
					contracted_tower.top_entity.destroy()
					contracted_tower.top_entity = new_top_entity

					if contracted_tower.shadow and contracted_tower.shadow.valid then
						contracted_tower.shadow.sprite = "radiative-tower-tower-shadow-2"
					end
				elseif contracted_tower.stage == 1 and ticks_since_open > 2 / EXPAND_SPEED then
					contracted_tower.stage = 2

					local new_top_entity = surface.create_entity({
						name = "cerys-fulgoran-radiative-tower-rising-reactor-tower-3",
						position = top_entity.position,
						force = top_entity.force,
					})
					contracted_tower.top_entity.destroy()
					contracted_tower.top_entity = new_top_entity
				end
			else
				local new_tower = surface.create_entity({
					name = "cerys-fulgoran-radiative-tower-frozen",
					position = contracted_tower.entity.position,
					force = contracted_tower.entity.force,
				})

				if new_tower and new_tower.valid then
					new_tower.minable_flag = false
					new_tower.destructible = false
				end

				local inv = contracted_tower.entity.get_inventory(defines.inventory.chest)
				if inv and inv.valid then
					for i = 1, #inv do
						local stack = inv[i]
						if stack and stack.valid_for_read then
							if stack.name == "solid-fuel" then
								new_tower.insert(stack)
							else
								surface.spill_item_stack({
									position = contracted_tower.entity.position,
									stack = stack,
								})
							end
						end
					end
				end

				if contracted_tower.rendering and contracted_tower.rendering.valid then
					contracted_tower.rendering.destroy()
				end

				Public.register_heating_tower(new_tower, contracted_tower)

				for _, player in pairs(game.connected_players) do
					if player.opened == contracted_tower.entity then
						player.opened = new_tower
					end
				end

				contracted_tower.entity.destroy()
				storage.cerys.heating_towers_contracted[unit_number] = nil
			end
		end
	end
end

return Public
