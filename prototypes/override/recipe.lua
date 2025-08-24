local util = require("util")
local lib = require("lib")
local merge = lib.merge

--== Flare stack ==--

if settings.startup["cerys-disable-flare-stack-item-venting"].value then
	data.raw.recipe["electric-incinerator"].hidden = true
	data.raw.recipe["incinerator"].hidden = true
end

--== Allow personal mixed-oxide reactors to be used in upgrade recipes ==--

if data.raw["generator-equipment"]["fission-reactor-equipment"] then
	local new_recipes = {}
	local recipe_map = {} -- [old_recipe_name] = new_recipe_name

	for equipment_name, _ in pairs(data.raw["generator-equipment"]) do
		local recipe = data.raw.recipe[equipment_name]
		if recipe then
			local ingredients = recipe.ingredients or (recipe.normal and recipe.normal.ingredients)
			if ingredients then
				for i, ing in ipairs(ingredients) do
					local name = ing.name or ing[1]
					if name == "fission-reactor-equipment" then
						local new_recipe = merge(recipe, {
							name = equipment_name .. "-from-mixed-oxide",
							localised_name = { "cerys.from-mixed-oxide", { "equipment-name." .. equipment_name } },
							localised_description = {
								"cerys.alternative-recipe-from-mixed-oxide",
								{ "equipment-description.mixed-oxide-reactor-equipment" },
							},
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
						recipe_map[equipment_name] = new_recipe.name
						break
					end
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

--== Adjust decayed radioactive module recycling ==--

local decayed_recycling = data.raw.recipe["cerys-radioactive-module-decayed-recycling"]
local charged_recycling = data.raw.recipe["cerys-radioactive-module-charged-recycling"]

if decayed_recycling and charged_recycling then
	local new_decayed_recycling = util.table.deepcopy(charged_recycling)
	for _, result in pairs(new_decayed_recycling.results) do
		if result.name == "cerys-radioactive-module-charged" then
			result.name = "cerys-radioactive-module-decayed"
		end
	end
	for _, ingredient in pairs(new_decayed_recycling.ingredients) do
		if ingredient.name == "cerys-radioactive-module-charged" then
			ingredient.name = "cerys-radioactive-module-decayed"
		end
	end
	decayed_recycling.ingredients = new_decayed_recycling.ingredients
	decayed_recycling.results = new_decayed_recycling.results
end
