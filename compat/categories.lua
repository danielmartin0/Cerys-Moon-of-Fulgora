local lib = require("lib")

for entity_type in pairs(defines.prototypes.entity) do
	for _, entity in pairs(data.raw[entity_type] or {}) do
		local burner = entity.burner or entity.energy_source
		if not burner then
			goto continue
		end
		if burner.type ~= "burner" then
			goto continue
		end

		burner.fuel_categories = burner.fuel_categories or { "chemical" }
		if lib.find(burner.fuel_categories, "chemical") then
			table.insert(burner.fuel_categories, "chemical-or-radiative")
		end

		::continue::
	end
end

for _, equipment in pairs(data.raw["generator-equipment"] or {}) do
	local burner = equipment.burner
	if burner and burner.type == "burner" then
		burner.fuel_categories = burner.fuel_categories or { "chemical" }
		if lib.find(burner.fuel_categories, "chemical") then
			table.insert(burner.fuel_categories, "chemical-or-radiative")
		end
	end
end
