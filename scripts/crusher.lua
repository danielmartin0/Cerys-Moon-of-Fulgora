local Public = {}

Public.CRUSHER_WRECK_STAGE_ENUM = {
	frozen = 0,
	needs_repair = 1,
}

Public.DEFAULT_CRUSHER_REPAIR_RECIPES_NEEDED = 40

function Public.crusher_repair_recipes_needed()
	return math.ceil(Public.DEFAULT_CRUSHER_REPAIR_RECIPES_NEEDED)
end

function Public.tick_15_check_broken_crushers(surface)
	if not storage.cerys.broken_crushers then
		return
	end

	for unit_number, crusher in pairs(storage.cerys.broken_crushers) do
		local e = crusher.entity

		if e and e.valid then
			if crusher.stage == Public.CRUSHER_WRECK_STAGE_ENUM.frozen then
				if not e.frozen and game.tick > crusher.creation_tick + 300 then
					local input_inv = e.get_inventory(defines.inventory.assembling_machine_input)
					local contents = nil
					if input_inv and input_inv.valid then
						contents = input_inv.get_contents()

						if #contents > 0 then
							-- Kick any players out of the GUI. A craft is about to complete, and we want them to notice the sign above the crusher.
							for _, player in pairs(game.connected_players) do
								if player.opened and player.opened == e then
									player.opened = nil
								end
							end
						end
					end

					local e2 = surface.create_entity({
						name = "cerys-fulgoran-crusher-wreck",
						position = e.position,
						force = e.force,
						fast_replace = true,
					})

					if e2 and e2.valid then
						e2.minable_flag = false
						e2.destructible = false

						if e and e.valid and input_inv and input_inv.valid then
							local input_inv2 = e2.get_inventory(defines.inventory.assembling_machine_input)
							if input_inv2 and input_inv2.valid then
								for _, c in pairs(contents or {}) do
									local new_count = c.count
									input_inv2.insert({ name = c.name, count = new_count, quality = c.quality })
								end
							end

							local module_inv = e.get_inventory(defines.inventory.assembling_machine_modules)
							local module_inv2 = e2.get_inventory(defines.inventory.assembling_machine_modules)
							if module_inv and module_inv.valid and module_inv2 and module_inv2.valid then
								local contents2 = module_inv.get_contents()
								for _, c in pairs(contents2) do
									module_inv2.insert({ name = c.name, count = c.count, quality = c.quality })
								end
							end
						end

						if e and e.valid then
							e.destroy()
						end

						crusher.entity = e2
					end

					crusher.stage = Public.CRUSHER_WRECK_STAGE_ENUM.needs_repair
				end
			else
				local products_finished = e.products_finished
				local products_required = Public.crusher_repair_recipes_needed()

				if products_finished >= products_required then
					if crusher.rendering1 then
						if crusher.rendering1.valid then
							crusher.rendering1.destroy()
						end
						crusher.rendering1 = nil
					end
					if crusher.rendering2 then
						if crusher.rendering2.valid then
							crusher.rendering2.destroy()
						end
						crusher.rendering2 = nil
					end

					local e2 = surface.create_entity({
						name = "cerys-fulgoran-crusher",
						position = e.position,
						force = e.force,
						direction = e.direction,
						fast_replace = true,
					})

					if e2 and e2.valid then
						e2.minable_flag = false
						e2.destructible = false
					end

					if e and e.valid then
						local input_inv = e.get_inventory(defines.inventory.assembling_machine_input)
						if input_inv and input_inv.valid then
							local contents = input_inv.get_contents()
							for _, item in pairs(contents) do
								surface.spill_item_stack({ position = e.position, stack = item })
							end
						end

						local module_inv = e.get_module_inventory()
						local module_inv2 = e2.get_module_inventory()
						if module_inv and module_inv.valid and module_inv2 and module_inv2.valid then
							local contents = module_inv.get_contents()
							for _, m in pairs(contents) do
								module_inv2.insert({ name = m.name, count = m.count, quality = m.quality })
							end
						end

						e.destroy()
					end

					storage.cerys.broken_crushers[unit_number] = nil
				elseif products_finished > 0 or e.is_crafting() then
					if not (crusher.rendering1 and crusher.rendering1.valid) then
						crusher.rendering1 = rendering.draw_text({
							text = "",
							surface = surface,
							target = {
								entity = e,
								offset = { 0, -3.7 },
							},
							color = { 0, 255, 0 },
							scale = 1.2,
							font = "default-game",
							alignment = "center",
							use_rich_text = true,
						})
					end
					if not (crusher.rendering2 and crusher.rendering2.valid) then
						crusher.rendering2 = rendering.draw_text({
							text = "",
							surface = surface,
							target = {
								entity = e,
								offset = { 0, -2.65 },
							},
							color = { 0, 255, 0 },
							scale = 1.2,
							font = "default-game",
							alignment = "center",
							use_rich_text = true,
						})
					end

					local repair_parts = 0
					local circuits = 0

					if e and e.valid then
						local input_inv = e.get_inventory(defines.inventory.assembling_machine_input)
						if input_inv and input_inv.valid then
							repair_parts = input_inv.get_item_count("ancient-structure-repair-part")

							local repair_recipe = prototypes.recipe["cerys-repair-crusher"]
							local chip_type = repair_recipe.ingredients[1].name

							circuits = input_inv.get_item_count(chip_type)
						end
					end

					local repair_count_multiplier = prototypes.recipe["cerys-repair-crusher"].ingredients[2].amount

					local circuit_count = products_finished + (e.is_crafting() and 1 or 0) + circuits
					local repair_count = (products_finished + (e.is_crafting() and 1 or 0)) * repair_count_multiplier
						+ repair_parts

					crusher.rendering1.color = repair_count >= products_required * repair_count_multiplier
							and { 0, 255, 0 }
						or { 255, 185, 0 }

					crusher.rendering1.text = {
						"cerys.repair-remaining-description",
						"[item=ancient-structure-repair-part]",
						repair_count,
						products_required * repair_count_multiplier,
					}

					crusher.rendering2.color = circuit_count >= products_required and { 0, 255, 0 } or { 255, 185, 0 }
					crusher.rendering2.text = {
						"cerys.repair-remaining-description",
						"[item=processing-unit]",
						circuit_count,
						products_required,
					}
				end
			end
		else
			storage.cerys.broken_crushers[unit_number] = nil
		end
	end
end

Public.register_ancient_crusher = function(entity, frozen)
	if not (entity and entity.valid) then
		return
	end

	storage.cerys.broken_crushers = storage.cerys.broken_crushers or {}

	storage.cerys.broken_crushers[entity.unit_number] = {
		entity = entity,
		stage = frozen and Public.CRUSHER_WRECK_STAGE_ENUM.frozen or Public.CRUSHER_WRECK_STAGE_ENUM.needs_repair,
		creation_tick = game.tick,
	}
end

local CRAFTING_PROGRESS_THRESHOLD = 0.97

function Public.tick_20_check_crusher_quality_upgrades(surface)
	storage.cerys.crusher_upgrade_monitor = storage.cerys.crusher_upgrade_monitor or {}
	storage.cerys_fulgoran_crushers = storage.cerys_fulgoran_crushers or {}

	for unit_number, crusher in pairs(storage.cerys_fulgoran_crushers) do
		if not (crusher and crusher.valid) then
			storage.cerys_fulgoran_crushers[unit_number] = nil
		end
	end

	for unit_number, crusher in pairs(storage.cerys_fulgoran_crushers) do
		storage.cerys.crusher_upgrade_monitor[unit_number] = nil

		if crusher.quality and crusher.quality.next then
			local recipe, recipe_quality = crusher.get_recipe()

			if recipe and recipe.name == "cerys-upgrade-fulgoran-crusher-quality" then
				if crusher.quality.next.name == recipe_quality.name then
					storage.cerys.crusher_upgrade_monitor[unit_number] = {
						entity = crusher,
						quality_upgrading_to = recipe_quality,
					}
				else
					local input_inv = crusher.get_inventory(defines.inventory.assembling_machine_input)
					if input_inv and input_inv.valid then
						local contents = input_inv.get_contents()
						for _, ingredient in pairs(contents) do
							input_inv.remove({
								name = ingredient.name,
								count = ingredient.count,
								quality = ingredient.quality,
							})
							surface.spill_item_stack({
								position = crusher.position,
								stack = {
									name = ingredient.name,
									count = ingredient.count,
									quality = ingredient.quality,
								},
							})
						end
					end
					crusher.set_recipe(recipe, crusher.quality.next)
				end
			end
		end
	end
end

function Public.tick_1_check_crusher_quality_upgrades(surface)
	if not (storage and storage.cerys and storage.cerys.crusher_upgrade_monitor) then
		return
	end

	for unit_number, data in pairs(storage.cerys.crusher_upgrade_monitor) do
		local e = data.entity
		local quality_upgrading_to = data.quality_upgrading_to

		if not (e and e.valid) then
			storage.cerys.crusher_upgrade_monitor[unit_number] = nil
		elseif e.is_crafting() then
			local recipe, quality = e.get_recipe()
			local still_the_same_recipe = recipe
				and recipe.name == "cerys-upgrade-fulgoran-crusher-quality"
				and quality
				and quality.name == quality_upgrading_to.name

			if not still_the_same_recipe then
				storage.cerys.crusher_upgrade_monitor[unit_number] = nil
			else
				if e.crafting_progress > CRAFTING_PROGRESS_THRESHOLD then
					local new_entity_name = "cerys-fulgoran-crusher-quality-" .. quality_upgrading_to.level

					local e2 = surface.create_entity({
						name = new_entity_name,
						position = e.position,
						force = e.force,
						direction = e.direction,
						fast_replace = true,
						quality = quality_upgrading_to.name,
					})

					if e2 and e2.valid then
						e2.minable_flag = false
						e2.destructible = false

						e2.set_recipe(nil)

						local old_input = e.get_inventory(defines.inventory.assembling_machine_input)
						if old_input and old_input.valid then
							local contents = old_input.get_contents()
							for _, m in pairs(contents) do
								for _ = 1, m.count do
									surface.spill_item_stack({
										position = e.position,
										stack = { name = m.name, count = 1, quality = m.quality },
									})
								end
							end
						end

						local old_modules = e.get_module_inventory()
						local new_modules = e2.get_module_inventory()

						if old_modules and old_modules.valid and new_modules and new_modules.valid then
							local modules = old_modules.get_contents()
							for _, m in pairs(modules) do
								new_modules.insert({ name = m.name, count = m.count, quality = m.quality })
							end
						end
					end

					if e and e.valid then
						e.destroy()
					end
					storage.cerys.crusher_upgrade_monitor[unit_number] = nil
				end
			end
		end
	end
end

Public.register_crusher = function(entity)
	if not (entity and entity.valid) then
		return
	end

	storage.cerys_fulgoran_crushers = storage.cerys_fulgoran_crushers or {}
	storage.cerys_fulgoran_crushers[entity.unit_number] = entity
end

return Public
