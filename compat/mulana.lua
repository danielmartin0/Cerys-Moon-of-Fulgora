local data_utils = require("data-utils")

-- TODO: Comb through these item categories for broader compatibility improvements.

--== Mulana seems to be overriding science packs to have min oxygen of 1, whereas oxygen is afaik supposed to be used to restrict burner items.

for pack_name in pairs(data_utils.current_lab_inputs()) do
	local recipe = data.raw["recipe"][pack_name]
	if recipe then
		if recipe.surface_conditions then
			for _, surface_condition in pairs(recipe.surface_conditions) do
				if
					surface_condition.property
					and surface_condition.property == "oxygen"
					and surface_condition.min == 1
				then
					surface_condition.min = 0
				end
			end
		end
	end
end
