local lib = require("lib")
local merge = lib.merge

--== Flare stack ==--

if settings.startup["cerys-disable-flare-stack-item-venting"].value then
	data.raw.recipe["electric-incinerator"].hidden = true
	data.raw.recipe["incinerator"].hidden = true
end

--== Mixed oxide reactor equipment recipe duplication ==--

if data.raw["generator-equipment"]["fission-reactor-equipment"] then
	local new_recipes = {}
	local recipe_map = {} -- [old_recipe_name] = new_recipe_name

	for recipe_name, recipe in pairs(data.raw.recipe) do
		local ingredients = recipe.ingredients or (recipe.normal and recipe.normal.ingredients)
		if ingredients then
			for i, ing in ipairs(ingredients) do
				local name = ing.name or ing[1]
				if name == "fission-reactor-equipment" then
					local new_recipe = merge(recipe, {
						name = recipe_name .. "-from-mixed-oxide",
						localised_name = { "recipe-name." .. recipe_name, { "cerys.from-mixed-oxide" } },
						localised_description = { "recipe-description." .. recipe_name },
					})

					local function replace_ingredient(ings)
						for _, ing2 in ipairs(ings) do
							if (ing2.name or ing2[1]) == "fission-reactor-equipment" then
								if ing2.name then
									ing2.name = "mixed-oxide-reactor-equipment"
								else
									ing2[1] = "mixed-oxide-reactor-equipment"
								end
							end
						end
					end
					if new_recipe.ingredients then
						replace_ingredient(new_recipe.ingredients)
					end
					if new_recipe.normal and new_recipe.normal.ingredients then
						replace_ingredient(new_recipe.normal.ingredients)
					end
					if new_recipe.expensive and new_recipe.expensive.ingredients then
						replace_ingredient(new_recipe.expensive.ingredients)
					end
					new_recipes[#new_recipes + 1] = new_recipe
					recipe_map[recipe_name] = new_recipe.name
					break
				end
			end
		end
	end

	if #new_recipes > 0 then
		data:extend(new_recipes)

		for _, tech in pairs(data.raw.technology) do
			if tech.effects then
				for _, effect in ipairs(tech.effects) do
					if effect.type == "unlock-recipe" and recipe_map[effect.recipe] then
						table.insert(tech.effects, { type = "unlock-recipe", recipe = recipe_map[effect.recipe] })
					end
				end
			end
		end
	end
end
