if data.raw.item["kr-rare-metals"] then
	table.insert(data.raw.recipe["cerys-nuclear-scrap-recycling"].results, {
		type = "item",
		name = "kr-rare-metals",
		amount = 1,
		probability = 0.3 / 100,
		show_details_in_recipe_tooltip = false,
	})
end

-- if data.raw.item["kr-electronic-components"] then
-- 	table.insert(data.raw.recipe["cerys-nuclear-scrap-recycling"].results, {
-- 		type = "item",
-- 		name = "kr-electronic-components",
-- 		amount = 1,
-- 		probability = 0.1 / 100,
-- 		show_details_in_recipe_tooltip = false,
-- 	})
-- end
