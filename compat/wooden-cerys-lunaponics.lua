local data_utils = require("data-utils")

if mods["cerys-lunaponics"] and mods["bztin"] and data.raw.recipe["alternative-nitrogen-rich-mineral-processing"] then
	for _, ingredient in pairs(data.raw.recipe["alternative-nitrogen-rich-mineral-processing"].ingredients) do
		if ingredient.name == "nitric-acid" then
			ingredient.name = data_utils.NITRIC_ACID_NAME
		end
	end
end
