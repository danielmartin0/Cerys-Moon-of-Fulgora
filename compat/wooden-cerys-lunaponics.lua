local common_data = require("common-data-only")

if mods["cerys-lunaponics"] and mods["bztin"] and data.raw.recipe["alternative-nitrogen-rich-mineral-processing"] then
	for _, ingredient in pairs(data.raw.recipe["alternative-nitrogen-rich-mineral-processing"].ingredients) do
		if ingredient.name == "nitric-acid" then
			ingredient.name = common_data.NITRIC_ACID_NAME
		end
	end
end
