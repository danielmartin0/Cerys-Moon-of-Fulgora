-- stone is required with AAI Industry, since you can't directly craft electric furnaces and need stone furnaces first
-- stone bricks can still be acquired (without smelting) from recycling concrete
-- stone is also required with Rusting Iron for derusting
if mods["aai-industry"] or mods["Rocs-Rusting-Iron"] then
	table.insert(data.raw.recipe["cerys-nuclear-scrap-recycling"].results, {
		type = "item",
		name = "stone",
		amount = 1,
		probability = 1 / 100,
		show_details_in_recipe_tooltip = false,
	})
end
