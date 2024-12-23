local Public = {}

local CRAFTING_PROGRESS_THRESHOLD = 0.97 -- Since there's no API for completing a craft, we need to watch for recipes above this threshold

function Public.tick_15_check_cryo_quality_upgrades(surface)
	storage.cerys.cryo_upgrade_monitor = storage.cerys.cryo_upgrade_monitor or {}

	local plants = surface.find_entities_filtered({
		name = "cerys-fulgoran-cryogenic-plant",
	})

	for _, plant in pairs(plants) do
		if plant.valid and plant.is_crafting() then
			local recipe, recipe_quality = plant.get_recipe()
			if recipe and recipe.name == "cerys-upgrade-fulgoran-cryogenic-plant-quality" then
				local plant_quality = plant.quality

				if recipe_quality.level > plant_quality.level then
					storage.cerys.cryo_upgrade_monitor[plant.unit_number] = {
						entity = plant,
						quality_upgrading_to = recipe_quality.name,
					}
				else
					plant.set_recipe(nil)
					for _, ingredient in
						pairs(prototypes.recipe["cerys-upgrade-fulgoran-cryogenic-plant-quality"].ingredients)
					do
						for _ = 1, ingredient.amount do
							surface.spill_item_stack({
								position = plant.position,
								stack = {
									name = ingredient.name,
									count = 1,
									quality = recipe_quality.name,
								},
							})
						end
					end
					plant.set_recipe(recipe, recipe_quality)
					storage.cerys.cryo_upgrade_monitor[plant.unit_number] = nil
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

		if not (e and e.valid and e.is_crafting()) then
			storage.cerys.cryo_upgrade_monitor[unit_number] = nil
		else
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

					if e and e.valid and e2 and e2.valid then
						local old_input = e.get_inventory(defines.inventory.assembling_machine_input)
						local new_input = e2.get_inventory(defines.inventory.assembling_machine_input)

						local input = old_input.get_contents()
						for _, m in pairs(input) do
							new_input.insert({ name = m.name, count = m.count, quality = m.quality })
						end

						local old_modules = e.get_module_inventory()
						local new_modules = e2.get_module_inventory()

						local modules = old_modules.get_contents()
						for _, m in pairs(modules) do
							new_modules.insert({ name = m.name, count = m.count, quality = m.quality })
						end

						e.destroy()
					end

					storage.cerys.cryo_upgrade_monitor[unit_number] = nil
				end
			end
		end
	end
end

return Public
