local common = require("common")

local Public = {}

Public.CRYO_WRECK_STAGE_ENUM = {
	frozen = 0,
	needs_repair = 1,
}

-- Having more than two distinct values is a bad idea:
Public.FIRST_CRYO_REPAIR_RECIPES_NEEDED = common.FIRST_CRYO_REPAIR_RECIPES_NEEDED
Public.SECOND_CRYO_REPAIR_RECIPES_NEEDED = common.HARD_MODE_ON and 250 or 150
Public.DEFAULT_CRYO_REPAIR_RECIPES_NEEDED = common.HARD_MODE_ON and 250 or 150

function Public.tick_15_check_broken_cryo_plants(surface)
	if not storage.cerys.broken_cryo_plants then
		return
	end

	for unit_number, plant in pairs(storage.cerys.broken_cryo_plants) do
		local e = plant.entity

		if e and e.valid then
			local products_finished = e.products_finished

			local products_required = Public.DEFAULT_CRYO_REPAIR_RECIPES_NEEDED

			if storage.cerys.first_unfrozen_cryo_plant and storage.cerys.first_unfrozen_cryo_plant == e.unit_number then
				products_required = Public.FIRST_CRYO_REPAIR_RECIPES_NEEDED
			end
			if
				storage.cerys.second_unfrozen_cryo_plant
				and storage.cerys.second_unfrozen_cryo_plant == e.unit_number
			then
				products_required = Public.SECOND_CRYO_REPAIR_RECIPES_NEEDED
			end

			if plant.stage == Public.CRYO_WRECK_STAGE_ENUM.frozen then
				if not e.frozen and game.tick > plant.creation_tick + 300 then
					Public.unfreeze_cryo_plant(surface, plant)
				end
			elseif products_finished >= products_required then
				if plant.rendering then
					if plant.rendering.valid then
						plant.rendering.destroy()
					end
					plant.rendering = nil
				end

				local e2 = surface.create_entity({
					name = "cerys-fulgoran-cryogenic-plant",
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

				storage.cerys.broken_cryo_plants[unit_number] = nil
			elseif products_finished > 0 or e.is_crafting() then
				if not storage.cerys.first_unfrozen_cryo_plant then
					storage.cerys.first_unfrozen_cryo_plant = e.unit_number
				end
				if
					not storage.cerys.second_unfrozen_cryo_plant
					and (
						storage.cerys.first_unfrozen_cryo_plant
						and e.unit_number ~= storage.cerys.first_unfrozen_cryo_plant
					)
				then
					storage.cerys.second_unfrozen_cryo_plant = e.unit_number
				end

				if not (plant.rendering and plant.rendering.valid) then
					plant.rendering = rendering.draw_text({
						text = "",
						surface = surface,
						target = {
							entity = e,
							offset = { 0, -3.8 },
						},
						color = { 0, 255, 0 },
						scale = 1.2,
						font = "default-game",
						alignment = "center",
						use_rich_text = true,
					})
				end

				local repair_parts = 0

				if e and e.valid then
					local input_inv = e.get_inventory(defines.inventory.assembling_machine_input)
					if input_inv and input_inv.valid then
						repair_parts = input_inv.get_item_count("ancient-structure-repair-part")
					end
				end

				local repair_parts_count = products_finished + (e.is_crafting() and 1 or 0) + repair_parts

				plant.rendering.color = repair_parts_count >= products_required and { 0, 255, 0 } or { 255, 185, 0 }
				plant.rendering.text = {
					"cerys.repair-remaining-description",
					"[item=ancient-structure-repair-part]",
					repair_parts_count,
					products_required,
				}
			end
		else
			storage.cerys.broken_cryo_plants[unit_number] = nil
		end
	end
end

Public.register_ancient_cryogenic_plant = function(entity, frozen)
	if not (entity and entity.valid) then
		return
	end

	storage.cerys.broken_cryo_plants[entity.unit_number] = {
		entity = entity,
		stage = frozen and Public.CRYO_WRECK_STAGE_ENUM.frozen or Public.CRYO_WRECK_STAGE_ENUM.needs_repair,
		creation_tick = game.tick,
	}
end

function Public.unfreeze_cryo_plant(surface, plant)
	local e = plant.entity

	if not (e and e.valid) then
		return
	end

	local input_inv = e.get_inventory(defines.inventory.assembling_machine_input)
	local contents = nil
	if input_inv and input_inv.valid then
		contents = input_inv.get_contents()

		if #contents > 0 then
			-- Kick any players out of the GUI. A craft is about to complete, and we want them to notice the sign above the cryo plant.
			for _, player in pairs(game.connected_players) do
				if player.opened and player.opened == e then
					player.opened = nil
				end
			end
		end
	end

	local e2 = surface.create_entity({
		name = "cerys-fulgoran-cryogenic-plant-wreck",
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
					local new_count = c.count + 1 -- one will have been consumed when the plant started crafting. WARNING: If the recipe changes to have >1 count for ingredient, this will break.
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

			if e and e.valid then
				e.destroy()
			end
		end

		plant.entity = e2
	end

	plant.stage = Public.CRYO_WRECK_STAGE_ENUM.needs_repair
end

local CRAFTING_PROGRESS_THRESHOLD = 0.97 -- Since there's no API for completing a craft, we need to watch for recipes above this threshold

function Public.tick_20_check_cryo_quality_upgrades(surface)
	storage.cerys.cryo_upgrade_monitor = storage.cerys.cryo_upgrade_monitor or {}

	local plants = surface.find_entities_filtered({
		name = "cerys-fulgoran-cryogenic-plant",
	})

	for _, plant in pairs(plants) do
		storage.cerys.cryo_upgrade_monitor[plant.unit_number] = nil -- We'll re-add it shortly if we need to

		if plant and plant.valid then
			local recipe, recipe_quality = plant.get_recipe()

			if recipe and recipe.name == "cerys-upgrade-fulgoran-cryogenic-plant-quality" then
				if plant.quality and plant.quality.next and plant.quality.next.name == recipe_quality.name then
					storage.cerys.cryo_upgrade_monitor[plant.unit_number] = {
						entity = plant,
						quality_upgrading_to = recipe_quality.name,
					}
				else
					local inv = plant.get_inventory(defines.inventory.assembling_machine_input)

					if inv and inv.valid then
						local contents = inv.get_contents()
						for _, ingredient in pairs(contents) do
							inv.remove({
								name = ingredient.name,
								count = ingredient.count,
								quality = ingredient.quality,
							})

							surface.spill_item_stack({
								position = plant.position,
								stack = {
									name = ingredient.name,
									count = ingredient.count,
									quality = ingredient.quality,
								},
							})
						end
					end

					if plant.quality and plant.quality.next then
						plant.set_recipe(recipe, plant.quality.next)
					else
						plant.set_recipe(nil)
					end
				end
			end
		end
	end
end

function Public.tick_1_check_cryo_quality_upgrades(surface)
	if not (storage and storage.cerys and storage.cerys.cryo_upgrade_monitor) then
		return
	end

	for unit_number, data in pairs(storage.cerys.cryo_upgrade_monitor) do
		local e = data.entity
		local quality_upgrading_to = data.quality_upgrading_to

		if not (e and e.valid) then
			storage.cerys.cryo_upgrade_monitor[unit_number] = nil
		elseif e.is_crafting() then
			local recipe, quality = e.get_recipe()
			local still_the_same_recipe = recipe
				and recipe.name == "cerys-upgrade-fulgoran-cryogenic-plant-quality"
				and quality
				and quality.name == quality_upgrading_to

			if not still_the_same_recipe then
				storage.cerys.cryo_upgrade_monitor[unit_number] = nil
			else
				if e.crafting_progress > CRAFTING_PROGRESS_THRESHOLD then
					local e2 = surface.create_entity({
						name = "cerys-fulgoran-cryogenic-plant",
						position = e.position,
						force = e.force,
						direction = e.direction,
						fast_replace = true,
						quality = quality_upgrading_to,
					})

					if e2 and e2.valid then
						e2.minable_flag = false
						e2.destructible = false

						e2.set_recipe(nil)

						if e and e.valid then
							local old_input = e.get_inventory(defines.inventory.assembling_machine_input)

							local input = old_input.get_contents()
							for _, m in pairs(input) do
								for _ = 1, m.count do
									surface.spill_item_stack({
										position = e.position,
										stack = { name = m.name, count = 1, quality = m.quality },
									})
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
					end

					if e and e.valid then
						e.destroy()
					end

					storage.cerys.cryo_upgrade_monitor[unit_number] = nil
				end
			end
		end
	end
end

return Public
