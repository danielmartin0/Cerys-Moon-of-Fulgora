local Public = {}

Public.REACTOR_STAGE_ENUM = {
	frozen = 0,
	needs_excavation = 1,
	needs_scaffold = 2,
	needs_repair = 3,
	active = 4,
}

Public.REACTOR_STONE_BRICKS_TO_EXCAVATE = 8000
Public.BASE_REACTOR_REPAIR_RECIPES_NEEDED = 15

function Public.tick_15_nuclear_reactor_repair_check(surface)
	if not (storage.cerys and storage.cerys.reactor) then
		return
	end

	local reactor = storage.cerys.reactor

	local e = reactor.entity

	if not (e and e.valid) then
		return
	end

	if reactor.stage == Public.REACTOR_STAGE_ENUM.needs_excavation then
		Public.reactor_excavation_check(surface, reactor)
	elseif reactor.stage == Public.REACTOR_STAGE_ENUM.needs_repair then
		Public.reactor_repair_check(surface, reactor)
	end
end

local bricks_per_excavation_recipe = prototypes.recipe["cerys-excavate-nuclear-reactor"].products[1].amount

function Public.reactor_excavation_check(surface, reactor)
	local e = reactor.entity
	local r = reactor.rendering

	local inv = e.get_output_inventory()
	local bricks_in_machine = inv and inv.valid and inv.get_item_count() or 0

	local products_remaining = Public.REACTOR_STONE_BRICKS_TO_EXCAVATE
		- e.products_finished * bricks_per_excavation_recipe
		+ bricks_in_machine

	local last_observed = reactor.excavation_products_remaining_last_observed
	if not last_observed then
		reactor.excavation_products_remaining_last_observed = products_remaining
	else
		if products_remaining < last_observed - 10 then
			surface.play_sound({
				position = e.position,
				path = "cerys-excavation",
			})

			reactor.excavation_products_remaining_last_observed = products_remaining
		end
	end

	if products_remaining <= 0 then
		r.destroy()
		reactor.rendering = nil

		local e2 = surface.create_entity({
			name = "cerys-fulgoran-reactor-wreck-cleared",
			position = e.position,
			force = e.force,
			fast_replace = true,
		})

		if e2 and e2.valid then
			e2.destructible = false

			if e and e.valid then
				e.destroy()
			end

			reactor.entity = e2
		end

		reactor.stage = Public.REACTOR_STAGE_ENUM.needs_scaffold
	else -- We don't check if they've removed some, as they might never think to remove any
		if not (r and r.valid) then
			r = rendering.draw_text({
				text = "",
				color = { 255, 40, 0 },
				surface = surface,
				target = {
					entity = e,
					offset = { 0, -14 },
				},
				scale = 3,
				font = "default-game",
				alignment = "center",
				use_rich_text = true,
			})

			reactor.rendering = r
		end

		r.text = {
			"cerys.repair-remaining-description",
			"[item=concrete]",
			products_remaining,
			Public.REACTOR_STONE_BRICKS_TO_EXCAVATE,
		}
	end
end

function Public.reactor_repair_recipes_needed()
	-- local adjusted = Public.BASE_REACTOR_REPAIR_RECIPES_NEEDED
	-- * settings.global["cerys-fulgoran-reactor-repair-cost-multiplier"].value

	return math.ceil(Public.BASE_REACTOR_REPAIR_RECIPES_NEEDED)
end

function Public.reactor_repair_check(surface, reactor)
	local e = reactor.entity
	local r1 = reactor.rendering1
	local r2 = reactor.rendering2

	local recipes_needed = Public.reactor_repair_recipes_needed()

	local last_observed = reactor.repair_products_remaining_last_observed
	if not last_observed then
		reactor.repair_products_remaining_last_observed = e.products_finished
	else
		if e.products_finished > last_observed then
			surface.play_sound({
				position = e.position,
				path = "cerys-repair",
			})

			reactor.repair_products_remaining_last_observed = e.products_finished
		end
	end

	if e.products_finished >= recipes_needed then
		if r1 and r1.valid then
			reactor.rendering1 = nil
			r1.destroy()
		end

		if r2 and r2.valid then
			reactor.rendering2 = nil
			r2.destroy()
		end

		local e2 = surface.create_entity({
			name = "cerys-fulgoran-reactor",
			position = e.position,
			force = e.force,
			fast_replace = true,
			quality = e.quality,
		})

		if e2 and e2.valid then
			e2.minable_flag = false
			e2.destructible = false

			local module_inv = e.get_module_inventory()
			if module_inv and module_inv.valid then
				local contents = module_inv.get_contents()
				for _, m in pairs(contents) do
					surface.spill_item_stack({
						position = e2.position,
						stack = { name = m.name, count = m.count, quality = m.quality },
					})
				end
			end

			if e and e.valid then
				e.destroy()
			end

			reactor.entity = e2
		end

		reactor.stage = Public.REACTOR_STAGE_ENUM.active
	else
		if not (r1 and r1.valid) then
			r1 = rendering.draw_text({
				text = "",
				color = { 0, 255, 0 },
				surface = surface,
				target = {
					entity = e,
					offset = { -4.2, -13.5 },
				},
				scale = 2.5,
				font = "default-game",
				alignment = "center",
				use_rich_text = true,
			})

			reactor.rendering1 = r1
		end
		if not (r2 and r2.valid) then
			r2 = rendering.draw_text({
				text = "",
				color = { 0, 255, 0 },
				surface = surface,
				target = {
					entity = e,
					offset = { 4.2, -13.5 },
				},
				scale = 2.5,
				font = "default-game",
				alignment = "center",
				use_rich_text = true,
			})

			reactor.rendering2 = r2
		end

		local processing_units = 0
		local repair_parts = 0
		local chips_count = 0
		local repair_count = 0

		if e and e.valid then
			local input_inv = e.get_inventory(defines.inventory.assembling_machine_input)
			if input_inv and input_inv.valid then
				processing_units = input_inv.get_item_count({ name = "processing-unit", quality = "rare" })
				repair_parts = input_inv.get_item_count({ name = "ancient-structure-repair-part", quality = "rare" })
			end
			chips_count = 1 * (e.products_finished + (e.is_crafting() and 1 or 0)) + processing_units
			repair_count = 1 * (e.products_finished + (e.is_crafting() and 1 or 0)) + repair_parts
		end

		r1.color = chips_count >= recipes_needed and { 0, 255, 0 } or { 255, 200, 0 }
		r1.text = {
			"cerys.repair-remaining-description",
			"[item=processing-unit,quality=rare]",
			chips_count,
			recipes_needed * 1,
		}

		r2.color = repair_count >= recipes_needed * 4 and { 0, 255, 0 } or { 255, 200, 0 }
		r2.text = {
			"cerys.repair-remaining-description",
			"[item=ancient-structure-repair-part,quality=rare]",
			repair_count,
			recipes_needed * 1,
		}
	end
end

Public.scaffold_on_pre_build = function(event)
	if not event.player_index then
		return
	end

	local player = game.get_player(event.player_index)
	if not (player and player.valid) then
		return
	end

	local surface = player.surface
	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	local position = event.position
	local wreck = surface.find_entity("cerys-fulgoran-reactor-wreck-cleared", position)
	local can_build = wreck and wreck.valid

	if not storage.cerys.scaffold_build_position_validated then
		storage.cerys.scaffold_build_position_validated = {}
	end

	storage.cerys.scaffold_build_position_validated[position.x .. "," .. position.y] = can_build
	return can_build
end

Public.scaffold_on_build = function(scaffold_entity, player)
	local surface = scaffold_entity.surface
	local position = scaffold_entity.position
	local force = scaffold_entity.force

	if not (surface and surface.valid and force and force.valid) then
		return
	end

	local scaffold_quality = scaffold_entity.quality

	scaffold_entity.destroy()

	if not (storage.cerys and storage.cerys.reactor) then
		return
	end

	local reactor = storage.cerys.reactor
	if not storage.cerys.scaffold_build_position_validated then
		storage.cerys.scaffold_build_position_validated = {}
	end

	local can_build = storage.cerys.scaffold_build_position_validated[position.x .. "," .. position.y]

	if can_build then
		local e = surface.create_entity({
			name = "cerys-fulgoran-reactor-wreck-scaffolded",
			position = position,
			force = force,
		})

		if e and e.valid then
			e.minable_flag = false
			e.destructible = false
			reactor.entity = e
		end

		reactor.stage = Public.REACTOR_STAGE_ENUM.needs_repair
	else
		if player and player.valid then
			local is_cursor_empty = player.is_cursor_empty()

			if is_cursor_empty then
				player.cursor_stack.set_stack({
					name = "cerys-fulgoran-reactor-scaffold",
					count = 1,
					quality = scaffold_quality,
				})
			else
				local inv = player.get_main_inventory()
				if inv and inv.valid then
					inv.insert({ name = "cerys-fulgoran-reactor-scaffold", count = 1, quality = scaffold_quality })
				end
			end
		end
	end

	storage.cerys.scaffold_build_position_validated[position.x .. "," .. position.y] = nil
end

return Public
