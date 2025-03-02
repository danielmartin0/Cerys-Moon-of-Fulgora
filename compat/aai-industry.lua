-- stone is required with AAI Industry, since you can't directly craft electric furnaces and need stone furnaces first
-- stone bricks can still be acquired (without smelting) from recycling concrete
if mods["aai-industry"] then
	-- for _, result in pairs(data.raw.recipe["cerys-nuclear-scrap-recycling"].results) do
	-- 	if result.name == "stone-brick" then
	-- 		result.name = "stone"
	-- 		result.probability = 2 * result.probability
	-- 		break
	-- 	end
	-- end
	table.insert(data.raw.recipe["cerys-nuclear-scrap-recycling"].results, {
		type = "item",
		name = "stone",
		amount = 1,
		probability = 1 / 100,
		show_details_in_recipe_tooltip = false,
	})
end
