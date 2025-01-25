local Public = {}

Public.CRUSHER_WRECK_STAGE_ENUM = {
	frozen = 0,
	needs_repair = 1,
}

Public.DEFAULT_CRUSHER_REPAIR_RECIPES_NEEDED = 10

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
								for _, c in pairs(contents) do
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
					if not crusher.rendering1 then
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
					if not crusher.rendering2 then
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
							if settings.startup["cerys-disable-quality-mechanics"].value then
								repair_parts = input_inv.get_item_count("ancient-structure-repair-part")

								local repair_recipe = prototypes.recipe["cerys-repair-crusher"]
								local chip_type = repair_recipe.ingredients[1].name

								circuits = input_inv.get_item_count(chip_type)
							else
								repair_parts = input_inv.get_item_count({
									name = "ancient-structure-repair-part",
									quality = "uncommon",
								})

								local repair_recipe = prototypes.recipe["cerys-repair-crusher"]
								local chip_type = repair_recipe.ingredients[1].name

								circuits = input_inv.get_item_count({
									name = chip_type,
									quality = "uncommon",
								})
							end
						end
					end

					local repair_count_multiplier = prototypes.recipe["cerys-repair-crusher"].ingredients[2].amount

					local circuit_count = products_finished + (e.is_crafting() and 1 or 0) + circuits
					local repair_count = (products_finished + (e.is_crafting() and 1 or 0)) * repair_count_multiplier
						+ repair_parts

					local quality_text = settings.startup["cerys-disable-quality-mechanics"].value and ""
						or ",quality=uncommon"

					crusher.rendering1.color = repair_count >= products_required * repair_count_multiplier
							and { 0, 255, 0 }
						or { 255, 200, 0 }

					crusher.rendering1.text = {
						"cerys.repair-remaining-description",
						"[item=ancient-structure-repair-part" .. quality_text .. "]",
						repair_count,
						products_required * repair_count_multiplier,
					}

					crusher.rendering2.color = circuit_count >= products_required and { 0, 255, 0 } or { 255, 200, 0 }
					crusher.rendering2.text = {
						"cerys.repair-remaining-description",
						"[item="
							.. prototypes.recipe["cerys-repair-crusher"].ingredients[1].name
							.. quality_text
							.. "]",
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

return Public
